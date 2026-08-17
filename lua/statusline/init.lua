local M = {}

local array = require("lua.array")
local components = require("statusline.components")

function M.render()
    -- NOTE: Yes, `:help statusline_winid`.
    local winid = tonumber(vim.g.statusline_winid)
        or vim.api.nvim_get_current_win()

    ---@type fsr.statusline.Context
    local ctx = {
        winid = winid,
        bufnr = vim.api.nvim_win_get_buf(winid),
    }

    return table.concat(
        array.reduce(components, {}, function(stl_components, c)
            local result = c.render(ctx)
            if result ~= "" then
                table.insert(stl_components, result)
            end

            return stl_components
        end),
        "  "
    )
end

return M
