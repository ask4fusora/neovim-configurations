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
            "document_highlight.setup",
            "keymap.setup",
        },
    },
    {
        event = "LspAttach",
        module_names = {
            "diagnostic.setup",
        },
    },
}, "lsp")
