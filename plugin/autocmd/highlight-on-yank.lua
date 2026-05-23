local TIMEOUT_MS = 100

local group = vim.api.nvim_create_augroup(
    "HighlightOnYank",
    { clear = true }
)

vim.api.nvim_create_autocmd("TextYankPost", {
    group = group,
    callback = function()
        vim.hl.on_yank({ higroup = "Visual", timeout = TIMEOUT_MS })
    end
})
