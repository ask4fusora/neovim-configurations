vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    once = true,
    callback = function()
        vim.o.clipboard = "unnamedplus"
    end,
})
