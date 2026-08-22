local M = {}

---@param args vim.api.keyset.create_autocmd.callback_args|nil
---@param module_names string[]
function M.require_modules(args, module_names)
    vim.iter(module_names):each(function(name)
        ---@cast name string
        local require_success, module = pcall(require, name)
        if not require_success then
            vim.notify(
                "Failed to require `" .. name .. "`.",
                vim.log.levels.ERROR
            )
            return
        end

        if type(module) == "table" and type(module.exec) == "function" then
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
        end
    end)
end

---@param registry fsr.initializer.Registration[]
function M.register(registry)
    vim.iter(registry):each(function(r)
        ---@cast r fsr.initializer.Registration
        vim.api.nvim_create_autocmd(r.event, {
            pattern = r.pattern,
            once = r.once == nil or r.once,
            callback = function(args)
                M.require_modules(args, r.module_names)
            end,
        })
    end)
end

return M
