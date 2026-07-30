vim.filetype.add({
    extension = {
        mbt = "moonbit",
        mbti = "moonbit",
        moonbit = "moonbit",
    },
    filename = {
        ["moon.pkg"] = "moonbit",
    },
})

vim.api.nvim_create_autocmd("FileType", {
    once = true,
    callback = function()
        require("arborist").setup({
            update_cadence = "weekly",
            install_popular = true,
            ensure_installed = {
                "moonbit",
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
            },
            overrides = {
                moonbit = {
                    url = "https://github.com/moonbitlang/tree-sitter-moonbit",
                },
            }
        })
    end,
})
