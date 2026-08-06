---@type string|nil
local theme = vim.env.SYSTEM_THEME

if theme and theme:find("Light") then
    vim.o.background = "light"
end

require("jb").setup({
    transparent = true,
    snacks = { explorer = { enabled = false } },
    telescope = { enabled = false },
})

vim.cmd.colorscheme("jb")

local function set_cursor_hl()
    -- NOTE: Setting `guicursor` is critical. Without it, the cursor will be
    -- inherited from the terminal solely.
    vim.o.guicursor = vim.fn.join({ vim.o.guicursor, "a:Cursor" }, ",")

    local hl_group = vim.api.nvim_get_hl(0, { name = "Custom_Statusbar" })
    vim.api.nvim_set_hl(0, "Cursor", { force = true, bg = hl_group.fg })
end

set_cursor_hl()

local color_scheme_group =
    vim.api.nvim_create_augroup("CursorHlSetOnColorScheme", { clear = true })
vim.api.nvim_create_autocmd(
    "ColorScheme",
    { group = color_scheme_group, callback = set_cursor_hl }
)

local option_set_group =
    vim.api.nvim_create_augroup("CursorHlSetOnOptionSet", { clear = true })

vim.api.nvim_create_autocmd("OptionSet", {
    pattern = "background",
    group = option_set_group,
    callback = set_cursor_hl,
})
