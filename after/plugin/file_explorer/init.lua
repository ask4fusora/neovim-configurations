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
    "n",
    "<Leader>e",
    function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0))
    end,
    { desc = "Open file explorer" }
)
