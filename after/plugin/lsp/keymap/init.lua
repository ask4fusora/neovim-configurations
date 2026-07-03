vim.keymap.set("n", "<M-F>", function()
    vim.lsp.buf.format({ async = true })
end, { desc = "Format document" })
