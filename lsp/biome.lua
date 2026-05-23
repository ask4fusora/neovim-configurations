---@type vim.lsp.Config
return {
    cmd = function(dispatchers, config)
        local cmd = 'biome'
        local local_cmd = config.root_dir
            and vim.fs.joinpath(config.root_dir, 'node_modules/.bin', cmd)

        if local_cmd and vim.fn.executable(local_cmd) == 1 then
            cmd = local_cmd
        end

        return vim.lsp.rpc.start({ cmd, 'lsp-proxy' }, dispatchers)
    end,
    filetypes = {
        "astro",
        "css",
        "graphql",
        "html",
        "javascript",
        "javascriptreact",
        "json",
        "jsonc",
        "svelte",
        "typescript",
        "typescriptreact",
        "vue",
    },
    workspace_required = true,
    root_markers = { { 'biome.json', 'biome.jsonc' } }
}
