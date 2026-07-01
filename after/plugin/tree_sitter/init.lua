vim.api.nvim_create_autocmd("FileType", {
    once = true,
    callback = function()
        require("arborist").setup({
            update_cadence = "weekly",
            install_popular = true,
            ensure_installed = {
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
        })
    end,
})
