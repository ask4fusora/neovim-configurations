local M = {}

---@return fsr.formatter.Formatter.LanguageServer[]
local function default_formatters()
    return vim.iter(vim.lsp.get_clients({ bufnr = 0 }))
        :map(function(client)
            ---@cast client vim.lsp.Client
            ---@type fsr.formatter.Formatter.LanguageServer
            return { language_server = { name = client.name } }
        end)
        :totable()
end

---@param formatters fsr.formatter.Formatter[]?
---@param range string? Default to `%` (whole file).
------
---Format document range.
function M.format(formatters, range)
    formatters = formatters or default_formatters()

    local buffer_path = vim.api.nvim_buf_get_name(0)

    for _, formatter in ipairs(formatters) do
        if formatter.language_server then
            vim.lsp.buf.format({
                filter = function(client)
                    return client.name == formatter.language_server.name
                end,
            })
        elseif formatter.external then
            local command = { formatter.external.command }

            for _, argument in ipairs(formatter.external.arguments or {}) do
                argument = argument:gsub("{buffer_path}", buffer_path)
                command[#command + 1] = argument
            end

            local view = vim.fn.winsaveview()

            vim.cmd(
                ("silent keepjumps %s!%s"):format(
                    range or "%",
                    table.concat(command, " ")
                )
            )

            vim.fn.winrestview(view)
        elseif formatter.code_action then
            require("lsp.code_action").code_action_sync({
                apply = true,
                context = {
                    only = { formatter.code_action },
                },
            })
        end
    end
end

return M
