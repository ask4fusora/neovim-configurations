local keymap = require("lazy.keymap")

keymap.set(function()
    local success, fff = pcall(require, "fff")
    if not success then
        vim.print("`fff` is either not installed or not available.", fff)
        return error(fff, 0)
    end

    fff.setup({
        prompt = "  ",
        layout = {
            prompt_position = "top",
        },
        follow_symlinks = true,
        debug = {
            enabled = false,
            show_scores = false,
        },
    })

    require("neovim.g").insert_to_list("nominicompletion_filetypes", "fff_input")
end, {
    {
        modes = "n",
        lhs = "<C-P>",
        rhs = function()
            require("fff").find_files()
        end,
        desc = "File picker",
    },
    {
        modes = "n",
        lhs = "<Leader>/",
        rhs = function()
            require("fff").live_grep()
        end,
        desc = "Live grep",
    },
    {
        modes = "v",
        lhs = "<Leader>/",
        rhs = function()
            require("fff").live_grep_under_cursor()
        end,
        desc = "Live grep under cursor",
    },
})
