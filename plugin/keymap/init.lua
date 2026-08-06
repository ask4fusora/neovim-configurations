vim.keymap.set("ca", "grep", "silent grep!")

vim.keymap.set({ "n", "v" }, "<C-s>", function()
    vim.cmd("silent w")
end)

vim.keymap.set("n", "<M-F>", function()
    local formatters = Formatter.formatters_by_filetype[vim.bo.filetype]
    if formatters and next(formatters) then
        require("neovim.formatter").format(formatters)
    end
end, { desc = "Format document" })

vim.keymap.set("v", "<C-k><C-f>", function()
    local formatters = Formatter.formatters_by_filetype[vim.bo.filetype]
    if formatters and next(formatters) then
        require("neovim.formatter").format(formatters, "'<,'>")
    end
end, { desc = "Format selections" })
