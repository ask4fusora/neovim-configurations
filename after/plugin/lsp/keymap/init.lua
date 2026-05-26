-- TODO: Only set lsp keymap on `LspAttach`.
vim.schedule(function()
    local set = vim.keymap.set
    local lsp = vim.lsp

    set(
        'n',
        '<Leader>lf',
        function() lsp.buf.format({ async = true }) end,
        { desc = 'Format buffer with lsp (async)' }
    )
    set(
        'n',
        '<A-F>',
        function() lsp.buf.format({ async = true }) end,
        { desc = 'Format buffer with lsp (async)' }
    )
end)
