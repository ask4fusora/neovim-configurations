local M = {}

local lsp = vim.lsp
M.lsp = lsp
local api = vim.api
M.api = api
local validate = vim.validate
M.validate = validate
local util = require("vim.lsp.util")
M.util = util

---@param bufnr integer
---@param mode "v"|"V"
---@return table {start={row,col}, end={row,col}} using (1, 0) indexing
function M.range_from_selection(bufnr, mode)
  -- TODO: Use `vim.fn.getregionpos()` instead.

  -- [bufnum, lnum, col, off]; both row and column 1-indexed
  local start = vim.fn.getpos('v')
  local end_ = vim.fn.getpos('.')
  local start_row = start[2]
  local start_col = start[3]
  local end_row = end_[2]
  local end_col = end_[3]

  -- A user can start visual selection at the end and move backwards
  -- Normalize the range to start < end
  if start_row == end_row and end_col < start_col then
    end_col, start_col = start_col, end_col --- @type integer, integer
  elseif end_row < start_row then
    start_row, end_row = end_row, start_row --- @type integer, integer
    start_col, end_col = end_col, start_col --- @type integer, integer
  end
  if mode == 'V' then
    start_col = 1
    local lines = api.nvim_buf_get_lines(bufnr, end_row - 1, end_row, true)
    end_col = #lines[1]
  end
  return {
    ['start'] = { start_row, start_col - 1 },
    ['end'] = { end_row, end_col - 1 },
  }
end

---@param diagnostic vim.Diagnostic
---@param bufnr integer
---@param lnum integer
---@param col integer
---@return boolean
function M.diagnostic_contains_cursor(diagnostic, bufnr, lnum, col)
  local start = vim.pos(bufnr, diagnostic.lnum, diagnostic.col)
  local finish =
    vim.pos(bufnr, diagnostic.end_lnum or diagnostic.lnum, diagnostic.end_col or diagnostic.col)
  local cursor = vim.pos(bufnr, lnum, col)

  if start == finish then
    return cursor == start
  end

  return start <= cursor and cursor < finish
end

--- This is not public because the main extension point is
--- vim.ui.select which can be overridden independently.
---
--- Can't call/use vim.lsp.handlers['textDocument/codeAction'] because it expects
--- `(err, CodeAction[] | Command[], ctx)`, but we want to aggregate the results
--- from multiple clients to have 1 single UI prompt for the user, yet we still
--- need to be able to link a `CodeAction|Command` to the right client for
--- `codeAction/resolve`
---@param results table<integer, vim.lsp.CodeActionResultEntry>
---@param opts? vim.lsp.buf.code_action.Opts
function M.on_code_action_results(results, opts)
  ---@param a lsp.Command|lsp.CodeAction
  ---@param client_id integer
  local function action_filter(a, client_id)
    -- filter by specified action kind
    if opts and opts.context then
      if opts.context.only then
        if not a.kind then
          return false
        end
        local found = false
        for _, o in ipairs(opts.context.only) do
          -- action kinds are hierarchical with . as a separator: when requesting only 'type-annotate'
          -- this filter allows both 'type-annotate' and 'type-annotate.foo', for example
          if a.kind == o or vim.startswith(a.kind, o .. '.') then
            found = true
            break
          end
        end
        if not found then
          return false
        end
      end
      -- Only show disabled code actions when the trigger kind is "Invoked".
      if a.disabled and opts.context.triggerKind ~= lsp.protocol.CodeActionTriggerKind.Invoked then
        return false
      end
    end
    -- filter by user function
    if opts and opts.filter and not opts.filter(a, client_id) then
      return false
    end
    -- no filter removed this action
    return true
  end

  ---@type {action: lsp.Command|lsp.CodeAction, ctx: lsp.HandlerContext}[]
  local actions = {}
  for _, result in pairs(results) do
    for _, action in pairs(result.result or {}) do
      if action_filter(action, result.context.client_id) then
        table.insert(actions, { action = action, ctx = result.context })
      end
    end
  end
  if #actions == 0 then
    vim.notify('No code actions available', vim.log.levels.INFO)
    return
  end

  ---@param action lsp.Command|lsp.CodeAction
  ---@param client vim.lsp.Client
  ---@param ctx lsp.HandlerContext
  local function apply_action(action, client, ctx)
    if action.edit then
      util.apply_workspace_edit(action.edit, client.offset_encoding)
    end
    local a_cmd = action.command
    if a_cmd then
      local command = type(a_cmd) == 'table' and a_cmd or action
      --- @cast command lsp.Command
      client:exec_cmd(command, ctx)
    end
  end

  ---@param choice {action: lsp.Command|lsp.CodeAction, ctx: lsp.HandlerContext}
  local function on_user_choice(choice)
    if not choice then
      return
    end

    -- textDocument/codeAction can return either Command[] or CodeAction[]
    --
    -- CodeAction
    --  ...
    --  edit?: WorkspaceEdit    -- <- must be applied before command
    --  command?: Command
    --
    -- Command:
    --  title: string
    --  command: string
    --  arguments?: any[]

    local client = assert(lsp.get_client_by_id(choice.ctx.client_id))
    local action = choice.action
    local bufnr = assert(choice.ctx.bufnr, 'Must have buffer number')

    -- Only code actions are resolved, so if we have a command, just apply it.
    if type(action.title) == 'string' and type(action.command) == 'string' then
      apply_action(action, client, choice.ctx)
      return
    end

    if action.disabled then
      vim.notify(action.disabled.reason, vim.log.levels.ERROR)
      return
    end

    if not (action.edit and action.command) and client:supports_method('codeAction/resolve') then
      client:request('codeAction/resolve', action, function(err, resolved_action)
        if err then
          -- If resolve fails, try to apply the edit/command from the original code action.
          if action.edit or action.command then
            apply_action(action, client, choice.ctx)
          else
            vim.notify(err.code .. ': ' .. err.message, vim.log.levels.ERROR)
          end
        else
          apply_action(resolved_action, client, choice.ctx)
        end
      end, bufnr)
    else
      apply_action(action, client, choice.ctx)
    end
  end

  -- If options.apply is given, and there are just one remaining code action,
  -- apply it directly without querying the user.
  if opts and opts.apply and #actions == 1 then
    on_user_choice(actions[1])
    return
  end

  ---@param item {action: lsp.Command|lsp.CodeAction, ctx: lsp.HandlerContext}
  local function format_item(item)
    local clients = lsp.get_clients({ bufnr = item.ctx.bufnr })
    local title = item.action.title:gsub('\r\n', '\\r\\n'):gsub('\n', '\\n')

    if item.action.disabled then
      title = title .. ' (disabled)'
    end

    if #clients == 1 then
      return title
    end

    local source = assert(lsp.get_client_by_id(item.ctx.client_id)).name
    return ('%s [%s]'):format(title, source)
  end

  local select_opts = {
    prompt = 'Code actions:',
    kind = 'codeaction',
    format_item = format_item,
  }
  vim.ui.select(actions, select_opts, on_user_choice)
end

return M
