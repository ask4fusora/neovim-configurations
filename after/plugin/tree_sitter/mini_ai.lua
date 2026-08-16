vim.api.nvim_create_autocmd("SafeState", {
    once = true,
    callback = function()
        require("mini.ai").setup()
    end,
})
