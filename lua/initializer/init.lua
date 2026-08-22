local M = {}

local array = require("lua.array")

---@param args vim.api.keyset.create_autocmd.callback_args|nil
---@param module_names string[]
function M.require_modules(args, module_names)
    array.for_each(module_names, function(name)
        local require_success, module = pcall(require, name)
        if not require_success then
            vim.notify(
                "Failed to require `" .. name .. "`.",
                vim.log.levels.ERROR
            )
            return
        end

        if not type(module.exec) == "function" then
            return
        end
        ---@cast module fsr.initializer.Module

        assert(args ~= nil, ("`args` is missing for `%s`."):format(name))
        ---@cast args vim.api.keyset.create_autocmd.callback_args

        local exec_success = pcall(module.exec, args)
        if not exec_success then
            vim.notify(
                "Failed to execute `" .. name .. "`.",
                vim.log.levels.ERROR
            )
        end
    end)
end

---@param registry fsr.initializer.Registration[]
function M.register(registry)
    array.for_each(registry, function(r)
        vim.api.nvim_create_autocmd(r.event, {
            pattern = r.pattern,
            once = r.once or true,
            callback = function(args)
                M.require_modules(args, r.module_names)
            end,
        })
    end)
end

return M
