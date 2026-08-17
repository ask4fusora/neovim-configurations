vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    group = vim.api.nvim_create_augroup(
        "fsr.OpenQuickFixListPostGrep",
        { clear = true }
    ),
    pattern = "grep",
    command = "cwindow",
})
