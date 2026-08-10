vim.keymap.set({ "n", "v" }, "<Leader>d", function()
    vim.diagnostic.setloclist()
end, { desc = "Deploy current file diagnostics" })

vim.keymap.set({ "n", "v" }, "<Leader>D", function()
    vim.diagnostic.setqflist()
end, { desc = "Deploy diagnostics" })

vim.keymap.set({ "n", "v" }, "<Leader>li", function()
    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hint" })

vim.keymap.set({ "n", "v" }, "<Leader>lc", function()
    vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())
end, { desc = "Toggle code lens" })
