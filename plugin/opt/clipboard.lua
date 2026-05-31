vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
    once = true,
    callback = function()
        vim.notify('clipboard', vim.log.levels.ERROR)
        vim.o.clipboard = "unnamedplus"
    end,
})
