vim.api.nvim_create_user_command('NeovimOpenSettings', function()
    vim.cmd.edit({ vim.fn.stdpath('config') })
end, {})
