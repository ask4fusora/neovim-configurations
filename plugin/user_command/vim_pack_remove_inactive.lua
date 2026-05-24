vim.api.nvim_create_user_command("VimPackRemoveInactive", function()
    local inactive_packages = vim.iter(vim.pack.get())
        :filter(function(x) return not x.active end)
        :map(function(x) return x.spec.name end)
        :totable()

    for _, pkg in ipairs(inactive_packages) do
        vim.pack.del({ pkg })
    end
end, {})
