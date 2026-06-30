local lsp_utils = require("neovim_utility.lsp")

---@type vim.lsp.Config
return {
    cmd = function(dispatchers, config)
        local cmd = "astro-ls"

        local local_cmd = config.root_dir
            and vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)

        if local_cmd and vim.fn.executable(local_cmd) == 1 then
            cmd = local_cmd
        end

        return vim.lsp.rpc.start({ cmd, "--stdio" }, dispatchers)
    end,
    filetypes = { "astro" },
    root_markers = { "tsconfig.json", "package.json", ".git" },
    init_options = {
        typescript = {},
    },
    before_init = function(_, config)
        local typescript_config = config.init_options.typescript
        ---@cast typescript_config table<string, any>

        if not typescript_config.tsdk then
            local tsdk_path = lsp_utils.get_tsdk_path(config.root_dir)

            if tsdk_path ~= nil then
                typescript_config.tsdk = tsdk_path
            end
        end
    end,
}
