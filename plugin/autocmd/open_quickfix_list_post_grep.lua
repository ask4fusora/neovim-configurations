vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    group = vim.api.nvim_create_augroup(
        "OpenQuickfixListPostGrep",
        { clear = true }
    ),
    pattern = "grep",
    command = "cwindow",
})
