vim.api.nvim_create_autocmd("LspAttach", {
    once = true,
    callback = function()
        vim.diagnostic.config({
            float = {
                source = "if_many",
            },
            signs = function()
                return {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.INFO]= "",
                        [vim.diagnostic.severity.HINT] = ""
                    }
                }
            end,
            virtual_text = { spacing = 2 },
            severity_sort = true,
        })
    end
})
