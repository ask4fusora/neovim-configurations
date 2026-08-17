_G.fsr = {}

require("initializer").initialize({
    {
        module_names = {
            "opt.setup",
            "plugin.setup",
            "plugin.fff.setup",
            "appearance.setup",
            "tweak.setup",
            "statusline.setup",
            "filetype.setup",
            "formatter.setup",
            "autocmd.highlight_on_yank.setup",
            "autocmd.open_quick_fix_list_post_grep.setup",
            "user_command.neovim_open_settings.setup",
            "user_command.vim_pack_remove_inactive.setup",
            "keymap.setup",
        },
    },
    {
        event = "SafeState",
        module_names = {
            "lsp.setup",
            "file_explorer.setup",
            "picker.fff.setup",
            "notification.setup",
        },
    },
    {
        event = "LspAttach",
        module_names = {
            "lsp.completion.setup",
            "lsp.diagnostic.setup",
            "lsp.document_highlight.setup",
            "lsp.keymap.setup",
        },
    },
    {
        event = "FileType",
        pattern = "typst",
        module_names = {
            "ftplugin.typst.setup",
        },
    },
})
