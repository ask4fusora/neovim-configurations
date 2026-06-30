---@param setup fun() Setup function to call before setting the keymap.
---@param modes string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
---@param lhs string           Left-hand side |{lhs}| of the mapping.
---@param rhs string|function  Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@param opts? vim.keymap.set.Opts
local function lazy_load(setup, modes, lhs, rhs, opts)
    vim.keymap.set(modes, lhs, function()
        setup()
        ---@type vim.keymap.del.Opts?
        local del_opts = opts ~= nil and { buf = opts.buf } or nil
        vim.keymap.del(modes, lhs, del_opts)
        vim.keymap.set(modes, lhs, rhs, opts)
        if type(rhs) == "string" then
            return vim.api.nvim_feedkeys(rhs, "t", true)
        else
            return rhs()
        end
    end, opts)
end

return {
    lazy_load = lazy_load,
}
