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

require("neovim.g").insert_to_list("nominicompletion_filetypes", "fff_input")

vim.keymap.set("n", "<C-P>", function()
    require("fff").find_files()
end, { desc = "File picker" })

vim.keymap.set("n", "<Leader>/", function()
    require("fff").live_grep()
end, { desc = "Live grep" })

vim.keymap.set("v", "<Leader>/", function()
    require("fff").live_grep_under_cursor()
end, { desc = "Live grep under cursor" })

vim.keymap.set({ "n", "v" }, "<Leader>b", function()
    require("neovim.picker.pick_buffer").pick_buffer()
end, {})
