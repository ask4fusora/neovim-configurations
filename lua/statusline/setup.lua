vim.o.statusline = "%!v:lua.require('statusline').render()"

local components = require("statusline.components")

---@type string[]
local rerender_events = vim.iter(components)
    :filter(function(c)
        return c.rerender_event ~= nil
    end)
    :map(function(c)
        return c.rerender_event
    end)
    :totable()

vim.api.nvim_create_autocmd(rerender_events, {
    group = vim.api.nvim_create_augroup(
        "fsr.RerenderStatusLine",
        { clear = true }
    ),
    callback = function()
        vim.cmd.redrawstatus()
    end,
})
