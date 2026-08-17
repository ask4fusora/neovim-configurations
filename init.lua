vim.loader.enable()
require("vim._core.ui2").enable()

---@type fsr.initializer.Registration[]
local registry = {
    {
        module_names = {
            "opt.setup",
            "plugin.setup",
            "appearance.setup",
            "filetype.setup",
            "autocmd.setup",
            "formatter.setup",
        },
    },
}

require("initializer").initialize(registry)
