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

local function update_cursor_hl_group()
    local hl_group = vim.api.nvim_get_hl(0, { name = "Custom_Statusbar" })
    vim.api.nvim_set_hl(0, "Cursor", { force = true, bg = hl_group.fg })
end

jb.setup({
    transparent = true,
    snacks = { explorer = { enabled = false } },
    telescope = { enabled = false },
})

vim.cmd.colorscheme("jb")
update_cursor_hl_group()

local color_scheme_group = vim.api.nvim_create_augroup(
    "fsr.UpdateCursorHlGroupOnColorScheme",
    { clear = true }
)
vim.api.nvim_create_autocmd(
    "ColorScheme",
    { group = color_scheme_group, callback = update_cursor_hl_group }
)

local option_set_group = vim.api.nvim_create_augroup(
    "fsr.UpdateCursorHlGroupOnOptionSet",
    { clear = true }
)
vim.api.nvim_create_autocmd("OptionSet", {
    pattern = "background",
    group = option_set_group,
    callback = update_cursor_hl_group,
})
