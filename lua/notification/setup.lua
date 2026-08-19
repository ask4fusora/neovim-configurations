local success, mn = pcall(require, "mini.notify")
if not success then
    vim.notify("`mini.notify` is either not installed or not available.", vim.log.levels.ERROR)
    return
end

mn.setup({
    window = { max_width_share = 0.618 },
    content = {
        format = function(notification)
            local time_string =
                vim.fn.strftime("%H:%M:%S", math.floor(notification.ts_update))

            return (" %s | %s | %s "):format(
                time_string,
                notification.level,
                notification.msg
            )
        end,
    },
})
