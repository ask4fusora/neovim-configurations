vim.api.nvim_create_user_command("PickBuffer", function()
    require("picker.buffer").open()
end, {})
