---@type vim.lsp.Config
return {
    cmd = require("lsp.adapter.nodejs.cmd").configure_cmd("astro-ls"),
    filetypes = { "astro" },
    root_markers = { "tsconfig.json", "package.json", ".git" },
    init_options = {
        typescript = {},
    },
    before_init = function(_, config)
        require("lsp.adapter.nodejs.tsdk").configure_tsdk(config)
    end,
}
