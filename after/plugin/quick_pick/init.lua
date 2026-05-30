local fff = require('fff')

vim.g.fff = {
    layout = {
        prompt_position = 'top'
    }
}

vim.keymap.set(
    'n',
    '<C-P>',
    function() fff.find_files() end,
    { desc = 'File picker' }
)

vim.keymap.set(
    'n',
    '<Leader>/',
    function() fff.live_grep() end,
    { desc = 'Live grep' }
)

-- local nocompletion_filetypes = vim.g.nominicompletion_filetypes or {}
-- table.insert(nocompletion_filetypes, "minifiles")
-- vim.g.nominicompletion_filetypes = nocompletion_filetypes

require('neovim_utility.g').insert_to_list(
    'nominicompletion_filetypes',
    'fff_input'
)
