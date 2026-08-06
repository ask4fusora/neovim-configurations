vim.keymap.set({ "n", "v" }, "<Leader>d", function()
    vim.diagnostic.setloclist()
end, { desc = "Deploy current file diagnostics" })

vim.keymap.set({ "n", "v" }, "<Leader>D", function()
    vim.diagnostic.setqflist()
end, { desc = "Deploy diagnostics" })
