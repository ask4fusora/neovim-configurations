local M = {}

local array = require("lua.array")

---@param module_names string[]
local function require_modules(module_names)
    array.for_each(module_names, function(name)
        local success, result = pcall(require, name)
        if success then
            return
        end

        vim.print("Failed to initialize `" .. name .. "`.", result)
    end)
end

---@param registry fsr.initializer.Registration[]
---@param namespace string?
function M.initialize(registry, namespace)
    if namespace then
        array.for_each(registry, function(r)
            r.module_names = array.reduce(r.module_names, {}, function(prefixed_module_names, name)
                table.insert(prefixed_module_names, namespace .. "." .. name)
                return prefixed_module_names
            end)
        end)
    end

    array.for_each(registry, function(r)
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
