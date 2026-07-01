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
        MiniFiles.open()
    end,
    { desc = "Open file explorer" }
)
