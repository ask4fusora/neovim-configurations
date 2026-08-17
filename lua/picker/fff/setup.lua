local keymap = require("lazy.keymap")

vim.g.fff = {
    prompt = "  ",
    layout = {
        prompt_position = "top",
    },
    follow_symlinks = true,
    debug = {
        enabled = false,
        show_scores = false,
    },
}

keymap.set(function()
    local success, fff = pcall(require, "fff")
    if not success then
        vim.print("`fff` is either not installed or not available.", fff)
        return error(fff, 0)
    end

    require("neovim.g").insert_to_list("nominicompletion_filetypes", "fff_input")
end, {
    {
        modes = "n",
        lhs = "<C-P>",
        rhs = function()
            require("fff").find_files()
        end,
        opts = { desc = "File picker" },
    },
    {
        modes = "n",
        lhs = "<Leader>/",
        rhs = function()
            require("fff").live_grep()
        end,
        opts = { desc = "Live grep" },
    },
    {
        modes = "v",
        lhs = "<Leader>/",
        rhs = function()
            require("fff").live_grep_under_cursor()
        end,
        opts = { desc = "Live grep under cursor" },
    },
})
