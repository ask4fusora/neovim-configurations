---@type vim.lsp.Config
return {
    cmd = {
        "dprint",
        "lsp"
    },
    filetypes = { "markdown", "markdowninline" },
    root_markers = {
        { "dprint.json", "dprint.jsonc" }
    },
}
