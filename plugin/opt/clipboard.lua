vim.api.nvim_create_autocmd({ "BufReadPost", "BufNewFile" }, {
    once = true,
    callback = function()
        vim.o.clipboard = "unnamedplus"
    end,
})
