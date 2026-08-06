local group = vim.api.nvim_create_augroup(
    "RestoreCursorPositionPostYank",
    { clear = true }
)

vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
        local cursor_position = vim.fn.getpos("'[")
        vim.fn.setpos(".", cursor_position)
    end,
})
