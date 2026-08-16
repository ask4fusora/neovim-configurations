vim.api.nvim_create_autocmd("SafeState", {
    once = true,
    callback = function()
        vim.keymap.set(
            "",
            "<leader>s",
            "<Plug>Sneak_s",
            { remap = true, desc = "Sneak forward" }
        )
        vim.keymap.set(
            "",
            "<leader>S",
            "<Plug>Sneak_S",
            { remap = true, desc = "Sneak backward" }
        )
    end,
})
