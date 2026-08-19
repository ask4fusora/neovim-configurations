local M = {}

---@param setup fun() Setup function to call before setting the keymap.
---@param keymaps fsr.lazy.keymap.Keymap[] List of keymaps.
function M.set(setup, keymaps)
    local is_setup = false

    for _, keymap in ipairs(keymaps) do
        local modes = keymap.modes
        local lhs = keymap.lhs
        local rhs = keymap.rhs
        local opts = keymap.opts

        vim.keymap.set(modes, lhs, function()
            if not is_setup then
                local success, _ = pcall(setup)
                if not success then
                    vim.notify(
                        "Failed to set up keymap `" .. lhs .. "`.",
                        vim.log.levels.ERROR
                    )
                    return
                end

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

return M
