vim.o.background = 'dark'

vim.cmd.colorscheme('jb')

local function set_cursor_hl()
    -- NOTE: Setting `guicursor` is critical. Without it, the cursor will be
    -- inherited from the terminal solely.
    vim.o.guicursor = vim.fn.join(
        { vim.o.guicursor, 'a:Cursor' },
        ','
    )

    local hl_group = vim.api.nvim_get_hl(0, { name = 'Custom_Statusbar' })
    vim.api.nvim_set_hl(0, 'Cursor', { force = true, bg = hl_group.fg })
end

set_cursor_hl()
