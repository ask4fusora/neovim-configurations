local M = {}

---@param module_names string[]
local function require_modules(module_names)
    for _, name in ipairs(module_names) do
        local success, result = pcall(require, name)
        if success then
            return
        end

        vim.print("Failed to initialize `" .. name .. "`.", result)
    end
end

---@param registry fsr.initializer.Registration[]
function M.initialize(registry)
    require("lua.array").for_each(registry, function(r)
        if not r.event then
            require_modules(r.module_names)
            return
        end

        vim.api.nvim_create_autocmd(r.event, {
            pattern = r.pattern,
            once = true,
            callback = function()
                require_modules(r.module_names)
            end,
        })
    end)
end

return M
