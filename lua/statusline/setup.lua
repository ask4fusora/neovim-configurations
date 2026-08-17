vim.o.statusline = "%!v:lua.require('statusline').render()"

local array = require("lua.array")
local components = require("statusline.components")

---@type string[]
local rerender_events = array.reduce(components, {}, function(events, c)
    if c.rerender_event then
        table.insert(events, c.rerender_event)
    end
    return events
end)

vim.api.nvim_create_autocmd(rerender_events, {
    group = vim.api.nvim_create_augroup(
        "fsr.RerenderStatusLine",
        { clear = true }
    ),
    callback = function()
        vim.cmd.redrawstatus()
    end,
})
