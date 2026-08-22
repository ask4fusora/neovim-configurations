vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    group = vim.api.nvim_create_augroup(
        "fsr.autocmd.OpenQuickFixListPostGrep",
        { clear = true }
    ),
    pattern = "grep",
    command = "cwindow",
})
