local M = {}

local CODE_ACTION_TIMEOUT_MS = 5000

local dep = require("lsp.code_action.dependency")
local lsp = dep.lsp
local api = dep.api
local validate = dep.validate
local util = dep.util
local range_from_selection = dep.range_from_selection
local diagnostic_contains_cursor = dep.diagnostic_contains_cursor
local on_code_action_results = dep.on_code_action_results

---@param opts? vim.lsp.buf.code_action.Opts
------
---Selects a sync code action (LSP: "textDocument/codeAction" request) available at cursor position.
function M.code_action_sync(opts)
    validate('options', opts, 'table', true)
    opts = opts or {}
    -- Detect old API call code_action(context) which should now be
    -- code_action({ context = context} )
    --- @diagnostic disable-next-line:undefined-field
    if opts.diagnostics or opts.only then
        opts = { options = opts }
    end
    local context = opts.context and vim.deepcopy(opts.context) or {}
    if not context.triggerKind then
        context.triggerKind = lsp.protocol.CodeActionTriggerKind.Invoked
    end
    local mode = api.nvim_get_mode().mode
    local bufnr = api.nvim_get_current_buf()
    local win = api.nvim_get_current_win()
    local range = opts.range
    if range == nil and (mode == 'v' or mode == 'V') then
        range = range_from_selection(bufnr, mode)
    end
    local cursor = api.nvim_win_get_cursor(win)
    local lnum = cursor[1] - 1
    local col = cursor[2]
    local clients = lsp.get_clients({
        bufnr = bufnr,
        method =
        'textDocument/codeAction'
    })
    if not next(clients) then
        vim.notify(lsp._unsupported_method('textDocument/codeAction'),
            vim.log.levels.WARN)
        return
    end

    local results = lsp.buf_request_sync(
        bufnr,
        'textDocument/codeAction',
        function(client)
            ---@type lsp.CodeActionParams
            local params

            if range then
                assert(type(range) == 'table',
                    'code_action range must be a table')
                local start = assert(range.start,
                    'range must have a `start` property')
                local end_ = assert(range['end'],
                    'range must have a `end` property')
                params = util.make_given_range_params(start, end_, bufnr,
                    client.offset_encoding)
            else
                params = util.make_range_params(win, client.offset_encoding)
            end

            --- @cast params lsp.CodeActionParams

            if context.diagnostics then
                params.context = context
            else
                local ns_push = lsp.diagnostic.get_namespace(client.id)
                local diagnostics = {}

                client:_provider_foreach('textDocument/diagnostic', function(cap)
                    local ns_pull = lsp.diagnostic.get_namespace(client.id, true,
                        cap.identifier)
                    vim.list_extend(
                        diagnostics,
                        vim.diagnostic.get(bufnr,
                            { namespace = ns_pull, lnum = lnum })
                    )
                end)

                vim.list_extend(diagnostics,
                    vim.diagnostic.get(bufnr,
                        { namespace = ns_push, lnum = lnum }))
                if range == nil then
                    diagnostics = vim.tbl_filter(function(diagnostic)
                        return diagnostic_contains_cursor(diagnostic, bufnr, lnum,
                            col)
                    end, diagnostics)
                end
                params.context = vim.tbl_extend('force', context, {
                    ---@diagnostic disable-next-line: no-unknown
                    diagnostics = vim.tbl_map(function(d)
                        return d.user_data.lsp
                    end, diagnostics),
                })
            end

            return params
        end,
        CODE_ACTION_TIMEOUT_MS
    )

    if results == nil then return end

    on_code_action_results(results, opts)
end

return M
