vim.loader.enable()
require("vim._core.ui2").enable()

_G.fsr = {}

---@type fsr.initializer.Registration[]
local registry = {
    {
        module_names = {
            "opt.setup",
            "plugin.setup",
            "appearance.setup",
            "statusline.setup",
            "filetype.setup",
            "formatter.setup",
            "autocmd.setup",
            "user_command.setup",
            "keymap.setup",
        },
    },
}

require("initializer").initialize(registry)
