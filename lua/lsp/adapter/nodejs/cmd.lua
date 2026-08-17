---@param command string Binary.
---@param arguments string[]? Default `{ "--stdio" }`.
---@param better_typescript_error boolean? Default `true`.
---@return fun(
---  dispatchers: vim.lsp.rpc.Dispatchers,
---  config: vim.lsp.ClientConfig,
---): vim.lsp.rpc.PublicClient
local function configure_cmd(command, arguments, better_typescript_error)
    return function(dispatchers, config)
        local cmd = command

        local local_cmd = config.root_dir
            and vim.fs.joinpath(config.root_dir, "node_modules/.bin", cmd)

        if local_cmd and vim.fn.executable(local_cmd) == 1 then
            cmd = local_cmd
        end

        if better_typescript_error then
            require("lsp.adapter.nodejs.better_typescript_error").init()
        end

        return vim.lsp.rpc.start(
            { cmd, unpack(arguments or { "--stdio" }) },
            dispatchers
        )
    end
end

return {
    configure_cmd = configure_cmd,
}
