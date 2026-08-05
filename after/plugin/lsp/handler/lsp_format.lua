-- I forgot why I did this. Kinda cool so let's keep this.

local function override_format_handler()
    local default_format_handler = vim.lsp.handlers["textDocument/formatting"]

    vim.lsp.handlers["textDocument/formatting"] = function(
        err,
        result,
        context,
        config
    )
        -- 1. Run the default handler.

        local notification_id = MiniNotify.add("Formatting...", "INFO")

        default_format_handler(err, result, context, config)

        -- 2. Error -> failure.

        if err then
            MiniNotify.update(notification_id, {
                msg = "Formatting failed: " .. err.message .. ".",
                level = "ERROR",
            })

            return vim.defer_fn(function()
                MiniNotify.remove(notification_id)
            end, 5000)
        end

        -- 3. Result -> success.

        if result then
            MiniNotify.update(notification_id, {
                msg = "Formatting completed.",
                level = "INFO",
            })

            return vim.defer_fn(function()
                MiniNotify.remove(notification_id)
            end, 1000)
        end

        -- 4. No result nor error -> no formatting needed.

        MiniNotify.update(notification_id, {
            msg = "No formatting needed.",
            level = "INFO",
        })

        vim.defer_fn(function()
            MiniNotify.remove(notification_id)
        end, 1000)
    end
end

vim.api.nvim_create_autocmd(
    "LspAttach",
    { once = true, callback = override_format_handler }
)
