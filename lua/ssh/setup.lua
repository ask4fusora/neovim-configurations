if not vim.env.SSH_CONNECTION then
    return
end

local osc52_clipboard = require("vim.ui.clipboard.osc52")

vim.g.clipboard = {
    copy = {
        ["+"] = osc52_clipboard.copy("+"),
        ["*"] = osc52_clipboard.copy("*"),
    },
    paste = {
        ["+"] = function()
            return {}
        end,
        ["*"] = function()
            return {}
        end,
    },
}
