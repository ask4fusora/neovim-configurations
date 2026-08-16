---@class StatusLineContext
---@field winid integer
---@field bufnr integer

---@class StatusLineComponent
---@field rerender_event string|nil
---@field render fun(ctx: StatusLineContext): string

local array = require("lua.array")

vim.api.nvim_create_autocmd("ColorScheme", {
    group = vim.api.nvim_create_augroup("StlColorScheme", { clear = true }),
    callback = function()
        vim.api.nvim_set_hl(0, "StlFilenameModified", { bold = true })

        local title_hl_group =
            vim.api.nvim_get_hl(0, { name = "Title", link = false })
        vim.api.nvim_set_hl(
            0,
            "StlVimMode",
            vim.tbl_extend("force", title_hl_group, {
                bold = true,
                italic = false,
                reverse = true,
            })
        )
    end,
})

local mode_name_by_key_code = {
    n = "NORMAL",
    no = "OPERATOR-PENDING",
    nt = "TERMINAL NORMAL",

    v = "VISUAL",
    V = "VISUAL LINE",
    [vim.keycode("<C-V>")] = "VISUAL BLOCK",

    s = "SELECT",
    S = "SELECT LINE",
    [vim.keycode("<C-S>")] = "SELECT BLOCK",

    i = "INSERT",
    R = "REPLACE",
    Rv = "VIRTUAL REPLACE",

    c = "COMMAND",
    r = "PROMPT",
    ["!"] = "SHELL",
    t = "TERMINAL",
}

---@type StatusLineComponent[]
local components = {
    {
        render = function(ctx)
            local file_path = vim.api.nvim_buf_get_name(ctx.bufnr)
            if file_path == "" then
                return "%t%m"
            end

            local cwd = vim.fn.getcwd(ctx.winid)
            local relative_file_path = vim.fs.relpath(cwd, file_path)
                or file_path
            local dir = vim.fs.dirname(relative_file_path)
            local prefix = ""

            if dir and dir ~= "." then
                prefix = dir .. "/"
            end

            local hl_group = vim.bo[ctx.bufnr].modified
                    and "%$StlFilenameModified$"
                or ""

            return prefix .. hl_group .. "%t%*"
        end,
    },
    {
        rerender_event = "DiagnosticChanged",
        render = function(ctx)
            ---`diagnostic_counts[i]` where `i` is **1-4** is the number of
            ---a diagnostic count.
            ---- **1** is error count.
            ---- **2** is warning count.
            ---- **3** is information count.
            ---- **4** is hint count.
            local diagnostic_counts = vim.diagnostic.count(ctx.bufnr)
            local icons = { "", "", "", "" }
            local hl_groups = {
                "DiagnosticError",
                "DiagnosticWarn",
                "DiagnosticInfo",
                "DiagnosticHint",
            }

            return table.concat(
                array.map(diagnostic_counts, function(count, level)
                    return "%$"
                        .. hl_groups[level]
                        .. "$"
                        .. icons[level]
                        .. " "
                        .. tostring(count)
                        .. "%*"
                end),
                " "
            )
        end,
    },
    {
        render = function()
            return "%="
        end,
    },
    {
        render = function()
            return "%l:%c"
        end,
    },
    {
        render = function()
            local mode_key_code = vim.api.nvim_get_mode().mode
            local mode_name = mode_name_by_key_code[mode_key_code:sub(1, 2)]
                or mode_name_by_key_code[mode_key_code:sub(1, 1)]
                or mode_key_code

            return ("%%$StlVimMode$ %s %%*"):format(mode_name)
        end,
    },
    {
        render = function(ctx)
            return string.upper(vim.bo[ctx.bufnr].fileformat)
        end,
    },
    {
        render = function(ctx)
            return vim.bo[ctx.bufnr].filetype
        end,
    },
    {
        render = function(ctx)
            return string.upper(vim.bo[ctx.bufnr].fileencoding)
        end,
    },
}

local rerender_events = array.filter(
    array.map(components, function(c)
        return c.rerender_event
    end),
    function(e)
        return e ~= nil
    end
)

local function status_line()
    local winid = tonumber(vim.g.statusline_winid)
        or vim.api.nvim_get_current_win()

    ---@type StatusLineContext
    local ctx = {
        winid = winid,
        bufnr = vim.api.nvim_win_get_buf(winid),
    }

    return table.concat(
        array.map(components, function(c)
            return c.render(ctx)
        end),
        " "
    )
end

_G.status_line = status_line

vim.api.nvim_create_autocmd(rerender_events, {
    group = vim.api.nvim_create_augroup("RerenderStatusLine", { clear = true }),
    callback = function()
        vim.cmd.redrawstatus()
    end,
})

vim.o.statusline = "%!v:lua.status_line()"
