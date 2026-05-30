vim.o.list = true
vim.o.listchars = vim.fn.join(
    {
        "eol:",
        "tab:→ ",
        "trail:•",
        "nbsp: ",
    },
    ','
)
