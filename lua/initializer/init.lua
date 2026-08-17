local M = {}

local array = require("lua.array")

---@param module_names string[]
function M.require_modules(module_names)
    array.for_each(module_names, function(name)
        local success, result = pcall(require, name)
        if success then
            return
        end

        vim.print("Failed to initialize `" .. name .. "`.", result)
    end)
end

---@param registry fsr.initializer.Registration[]
function M.initialize(registry)
    array.for_each(registry, function(r)
        if not r.event then
            M.require_modules(r.module_names)
            return
        end

        vim.api.nvim_create_autocmd(r.event, {
            pattern = r.pattern,
            once = true,
            callback = function()
                M.require_modules(r.module_names)
            end,
        })
    end)
end

return M
