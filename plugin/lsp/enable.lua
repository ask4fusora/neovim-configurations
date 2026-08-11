vim.api.nvim_create_autocmd("SafeState", {
    once = true,
    callback = function()
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
    end,
})
