local is_configured = false

return {
    init = function()
        if is_configured then
            return
        end

        require("ts-error-translator").setup({
            auto_attach = true,
            servers = {
                "astro-language-server",
                "vtsls",
            },
        })
    end,
}
