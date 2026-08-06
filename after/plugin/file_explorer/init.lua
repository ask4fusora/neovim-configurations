local keymap = require("neovim.keymap")

keymap.lazy_load(
    function()
        require("mini.files").setup({
            windows = {
                max_number = 3,
            },
        })
        require("neovim.g").insert_to_list(
            "nominicompletion_filetypes",
            "minifiles"
        )
    end,
    {
        {
            modes = "n",
            lhs = "<Leader>e",
            rhs = function()
                MiniFiles.open()
            end,
            opts = { desc = "Open file explorer" }
        },
        {
            modes = "n",
            lhs = "<Leader>E",
            rhs = function()
                MiniFiles.open(vim.api.nvim_buf_get_name(0))
            end,
            opts = { desc = "Open file explorer at current file" }
        }
    }
)
