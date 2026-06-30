---@type vim.lsp.Config
return {
    cmd = require("lsp.ecosystem.nodejs.cmd").configure_cmd(
        "dprint",
        { "lsp" },
        false
    ),
    filetypes = { "markdown" },
    root_markers = {
        { "dprint.json", "dprint.jsonc" },
    },
}
