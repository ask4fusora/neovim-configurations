vim.lsp.enable({
    "vtsls",
    "biome",
    "lua-language-server",
    "json-language-server",
    "tinymist",
    "astro-language-server",
    "dprint",
    "moon-lsp",
    "nu",
    "yaml-language-server",
})

require("initializer").initialize({
    {
        module_names = {
            "lsp.document_highlight.setup",
            "lsp.keymap.setup",
        },
    },
    {
        event = "LspAttach",
        module_names = {
            "lsp.diagnostic.setup",
        },
    }
})
