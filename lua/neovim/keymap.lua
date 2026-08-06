---@class Keymap
---@field modes string|string[] Mode "short-name" (see |nvim_set_keymap()|), or a list thereof.
---@field lhs string            Left-hand side |{lhs}| of the mapping.
---@field rhs string|function   Right-hand side |{rhs}| of the mapping, can be a Lua function.
---@field opts? vim.keymap.set.Opts

---@param setup fun() Setup function to call before setting the keymap.
---@param keymaps Keymap[] List of keymaps.
local function lazy_load(setup, keymaps)
    local is_setup = false

    for _, keymap in ipairs(keymaps) do
        local modes = keymap.modes
        local lhs = keymap.lhs
        local rhs = keymap.rhs
        local opts = keymap.opts

        vim.keymap.set(modes, lhs, function()
            if not is_setup then
                setup()
                is_setup = true
            end

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
end

return {
    lazy_load = lazy_load,
}
