---@type vim.lsp.Config
return {
    cmd = require("lsp.adapter.nodejs.cmd").configure_cmd(
        "vscode-json-language-server",
        nil,
        false
    ),
    filetypes = { "json", "jsonc" },
    init_options = {
        provideFormatter = true,
    },
    root_markers = { ".git" },
}
