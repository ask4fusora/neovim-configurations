vim.loader.enable()
require("vim._core.ui2").enable()

---@type fsr.initializer.Registration[]
local registry = {
    {
        module_names = { "opt.setup", "plugin.setup", "appearance.setup" },
    },
}

require("initializer").initialize(registry)
