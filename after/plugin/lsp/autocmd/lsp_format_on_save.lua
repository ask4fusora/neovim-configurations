local group = vim.api.nvim_create_augroup(
    'LspFormatOnSave',
    { clear = true }
)

vim.api.nvim_create_autocmd("BufWritePre", {
    group = group,
    callback = function()
        vim.lsp.buf.format()
    end,
})
