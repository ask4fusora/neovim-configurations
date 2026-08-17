local M = {}

---@param registry fsr.initializer.Registration[]
function M.initialize(registry)
    for _, r in ipairs(registry) do
        vim.api.nvim_create_autocmd(r.event, {
            pattern = r.pattern,
            once = true,
            callback = function()
                for _, name in ipairs(r.module_names) do
                    local success, result = pcall(require, name)
                    if success then
                        return
                    end

                    vim.print("Failed to initialize `" .. name .. "`.", result)
                end
            end,
        })
    end
end

return M
