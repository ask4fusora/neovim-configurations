vim.schedule(function()
    require('arborist').setup({
        update_cadence = 'weekly',
        install_popular = false,
        ensure_installed = {
            'markdown',
            'markdown_inline',
            'typst',
            'mermaid',
            'astro',
            'zig',
            'rust',
            'cpp',
            'sql',
            'lua',
            'luau',
            'typescript',
            'tsx',
            'toml',
            'json',
        }
    })
end)
