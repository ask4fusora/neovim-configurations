vim.schedule(function()
    local set = vim.keymap.set
    local lsp = vim.lsp

    set(
        'n',
        '<M-F>',
        function() lsp.buf.format({ async = true }) end,
        { desc = 'Format buffer (async)' }
    )
end)
