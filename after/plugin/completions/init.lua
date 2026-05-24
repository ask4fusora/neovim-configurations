vim.o.completeopt = 'fuzzy,menu,menuone,noselect'
vim.o.pumborder = 'single'

vim.api.nvim_create_autocmd('ColorScheme', {
    pattern = '*',
    callback = function()
        vim.api.nvim_set_hl(0, "Pmenu", { link = 'Normal' })
        vim.api.nvim_set_hl(0, "PmenuThumb", { link = "PmenuSel" })
    end
})

require('mini.completion').setup({})
