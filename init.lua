_G.fsr = {}

require("initializer").initialize({
    {
        module_names = {
            "tweak.setup",
            "plugin.setup",
            "appearance.setup",
            "filetype.setup",
        },
    },
    {
        event = "UIEnter",
        module_names = {
            "opt.setup",
            "statusline.setup",
            "file_explorer.setup",
            "plugin.fff.setup",
            "picker.fff.setup",
            "notification.setup",
            "autocmd.open_quick_fix_list_post_grep.setup",
            "user_command.neovim_open_settings.setup",
            "user_command.vim_pack_remove_inactive.setup",
            "keymap.setup",
            "which_key.setup",
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
        module_names = {
            "tree_sitter.setup",
            "tree_sitter.mini_ai.setup",
            "lsp.setup",
        },
    },
    {
        event = "FileType",
        pattern = "typst",
        module_names = {
            "ftplugin.typst.setup",
        },
    },
    {
        event = "BufEnter",
        module_names = {
            "formatter.setup",
            "autocmd.highlight_on_yank.setup",
        },
    },
})
