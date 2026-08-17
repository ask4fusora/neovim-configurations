---@type vim.lsp.Config
return {
    cmd = require("lsp.adapter.node_modules").cmd(
        "vscode-json-language-server",
        nil,
        { better_typescript_error = false }
    ),
    filetypes = { "json", "jsonc" },
    init_options = {
        provideFormatter = true,
    },
    root_markers = { ".git" },
}
