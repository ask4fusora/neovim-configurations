---@type vim.lsp.Config
return {
    cmd = {
        "dprint",
        "lsp",
    },
    filetypes = { "markdown" },
    root_markers = {
        { "dprint.json", "dprint.jsonc" },
    },
}
