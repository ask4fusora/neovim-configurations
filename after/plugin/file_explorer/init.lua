require("mini.files").setup({})

vim.keymap.set("n", "<Leader>e", function()
    MiniFiles.open()
end, { desc = "Open file explorer" })

require("neovim.g").insert_to_list("nominicompletion_filetypes", "minifiles")
