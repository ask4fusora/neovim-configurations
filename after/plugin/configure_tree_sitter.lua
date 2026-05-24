vim.schedule(function()
    require('arborist').setup({
        update_cadence = 'weekly',
        install_popular = false,
        ensure_installed = {
            'markdown',
            'markdown_inline',
            'typst',
            'mermaid'
        }
    })
end)
