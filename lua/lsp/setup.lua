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

require("initializer").require_modules({
    "lsp.document_highlight.setup",
    "lsp.diagnostic.setup",
    "lsp.keymap.setup",
})
