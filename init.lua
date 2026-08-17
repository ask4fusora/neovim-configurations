vim.loader.enable()
require("vim._core.ui2").enable()

---@type fsr.initializer.Registration[]
local registry = {
    {
        event = "VimEnter",
        module_names = { "opt.setup" },
    },
}

require("initializer").initialize(registry)
