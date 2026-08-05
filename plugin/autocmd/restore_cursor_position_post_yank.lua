local cursor_position = { 0, 0, 0, 0 }

local group = vim.api.nvim_create_augroup(
    "RestoreCursorPositionPostYank",
    { clear = true }
)

vim.api.nvim_create_autocmd({ "VimEnter", "CursorMoved" }, {
    group = group,
    callback = function()
        cursor_position = vim.fn.getpos(".")
    end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
        if vim.v.event.operator == "y" then
            vim.fn.setpos(".", cursor_position)
        end
    end,
})
