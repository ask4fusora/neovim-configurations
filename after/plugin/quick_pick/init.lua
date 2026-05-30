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

require('neovim_utility.g').insert_to_list(
    'nominicompletion_filetypes',
    'fff_input'
)
