vim.keymap.set("n", "<M-F>", function()
    require('neovim.formatter').format()
end, { desc = "Format document" })

vim.keymap.set("v", "<M-F>", function()
    require('neovim.formatter').format("'<,'>")
end, { desc = "Format document" })
