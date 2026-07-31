---@param fn fun()
---@param delay_ms number
local function debounce_fn(fn, delay_ms)
    ---@type uv.uv_timer_t?
    local timer = nil

    return function()
        if timer and not timer:is_closing() then
            timer:close()
        end

        timer = vim.defer_fn(function()
            timer = nil
            fn()
        end, delay_ms)
    end
end

return {
    debounce_fn = debounce_fn,
}
