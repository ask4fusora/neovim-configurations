vim.schedule(function()
    local set = vim.keymap.set
    local lsp = vim.lsp

    set(
        'n',
        '<Leader>lf',
        function() lsp.buf.format({ async = true }) end,
        { desc = 'LSP format buffer (async)' }
    )
end)
