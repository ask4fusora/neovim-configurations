require('mini.files').setup({})

vim.keymap.set(
    "n",
    "<Leader>e",
    function()
        MiniFiles.open()
    end,
    { desc = 'Open file explorer' }
)

require('neovim_utility.g').insert_to_g_list(
    'nominicompletion_filetypes',
    'minifiles'
)
