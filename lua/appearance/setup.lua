---@type string|nil
local theme = vim.env.SYSTEM_THEME

if theme and theme:find("Light") then
    vim.o.background = "light"
end

local success, jb = pcall(require, "jb")
if not success then
    vim.print("`jb` is either not installed or not available.", jb)
    return
end

jb.setup({
    transparent = true,
    snacks = { explorer = { enabled = false } },
    telescope = { enabled = false },
})

vim.cmd.colorscheme("jb")

-- Update `Cursor` highlight group.
local hl_group = vim.api.nvim_get_hl(0, { name = "Custom_Statusbar" })
vim.api.nvim_set_hl(0, "Cursor", { force = true, bg = hl_group.fg })
