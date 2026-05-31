require('mini.notify').setup({
    window = { max_width_share = 0.618 },
    content = {
        format = function(notification)
            local time_string = vim.fn.strftime(
                '%H:%M:%S',
                math.floor(notification.ts_update)
            )

            return (' %s | %s | %s '):format(
                time_string,
                notification.level,
                notification.msg
            )
        end
    }
})
