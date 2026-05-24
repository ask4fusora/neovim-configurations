require('mini.notify').setup({
    content = {
        format = function(notification)
            local time_string = vim.fn.strftime(
                '%H:%M:%S',
                math.floor(notification.ts_update)
            )

            return (' %s │ [%s] %s '):format(
                time_string,
                notification.level,
                notification.msg
            )
        end
    }
})
