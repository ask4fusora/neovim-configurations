vim.api.nvim_create_autocmd("SafeState", {
    once = true,
    callback = function()
        local miniclue = require("mini.clue")

        miniclue.setup({
            window = {
                delay = 200,
                config = {
                    width = "auto",
                },
            },

            triggers = {
                { mode = "n", keys = "<Leader>" },
                { mode = "v", keys = "<Leader>" },
                { mode = "v", keys = "i" },
                { mode = "v", keys = "a" },
                { mode = "n", keys = "g" },
                { mode = "v", keys = "g" },
                { mode = "n", keys = "[" },
                { mode = "n", keys = "]" },
                { mode = "n", keys = "<C-G>" },
                { mode = "v", keys = "<C-G>" },
                { mode = "n", keys = "<C-W>" },
                { mode = "i", keys = "<C-X>" },
            },

            clues = {
                miniclue.gen_clues.builtin_completion(),
                miniclue.gen_clues.g(),
                miniclue.gen_clues.marks(),
                miniclue.gen_clues.registers(),
                miniclue.gen_clues.square_brackets(),
                miniclue.gen_clues.windows({ submode_resize = true }),
                miniclue.gen_clues.z(),
            },
        })
    end
})
