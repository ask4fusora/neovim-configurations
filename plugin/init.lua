_G.fsr = {}

require("initializer").initialize({
    {
        module_names = {
            "opt.setup",
            "plugin.setup",
            "appearance.setup",
            "tweak.setup",
            "statusline.setup",
            "filetype.setup",
            "ftplugin.setup",
            "formatter.setup",
            "autocmd.setup",
            "user_command.setup",
            "keymap.setup",
        },
    },
    {
        event = "SafeState",
        module_names = {
            "lsp.setup",
        },
    },
})
