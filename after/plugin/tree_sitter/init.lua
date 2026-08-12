vim.api.nvim_create_autocmd("SafeState", {
    once = true,
    callback = function()
        require("arborist").setup({
            update_cadence = "weekly",
            install_popular = true,
            ensure_installed = {
                "moonbit",
                "moonbit_mbtp",
                "markdown",
                "markdown_inline",
                "typst",
                "mermaid",
                "astro",
                "zig",
                "rust",
                "c",
                "cpp",
                "php",
                "ruby",
                "odin",
                "sql",
                "lua",
                "luap",
                "luadoc",
                "luau",
                "typescript",
                "tsx",
                "toml",
                "json",
                "nu",
            },
            overrides = {
                moonbit = {
                    url = "https://github.com/moonbitlang/tree-sitter-moonbit",
                },
                moonbit_mbtp = {
                    url = "https://github.com/moonbitlang/tree-sitter-moonbit",
                    location = "grammars/mbtp",
                },
            },
        })
    end,
})
