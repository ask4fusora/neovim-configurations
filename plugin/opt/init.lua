-- Mapleader.

vim.g.mapleader = " "

-- Winborder.

vim.o.winborder = "single"

-- Gutter.

vim.o.number = true
vim.o.relativenumber = true
vim.o.numberwidth = 5
vim.o.statuscolumn = " %s%=%{v:relnum ? v:relnum : v:lnum} "
vim.o.signcolumn = "yes:1"

-- Indentation.

vim.o.autoindent = true
vim.o.smartindent = true

-- Is filename.

vim.o.shellslash = true
vim.o.isfname = table.concat({ vim.o.isfname, "(", ")" }, ",")

-- List chars.

vim.o.list = true
vim.o.listchars = vim.fn.join({
    "eol:",
    "tab:→ ",
    "trail:•",
    "nbsp: ",
}, ",")

-- Wrap.

vim.o.wrap = true

-- Neovim.

vim.o.undofile = true
vim.o.autoread = true

-- Providers.

vim.g.loaded_perl_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_python_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Scrolloff.

vim.o.scrolloff = 4
vim.o.sidescrolloff = 8

-- Search features.

vim.o.incsearch = true
vim.o.smartcase = true
