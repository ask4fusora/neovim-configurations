local fff = require("fff")

vim.g.fff = {
    prompt = "  ",
    layout = {
        prompt_position = "top",
    },
}

vim.keymap.set("n", "<C-P>", function()
    fff.find_files()
end, { desc = "File picker" })

vim.keymap.set("n", "<Leader>/", function()
    fff.live_grep()
end, { desc = "Live grep" })

vim.api.nvim_create_user_command("FFFRescan", function()
    fff.scan_files()
    fff.refresh_git_status()
end, {})

require("neovim.g").insert_to_list("nominicompletion_filetypes", "fff_input")
