---@type vim.lsp.Config
return {
    cmd = function(dispatchers, config)
        local cmd = 'biome'
        local local_cmd = config.root_dir
            and vim.fs.joinpath(config.root_dir, 'node_modules/.bin/biome')

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
    root_dir = function(bufnr, on_dir)
        local root_markers = {
            ".git",
            'package-lock.json',
            'yarn.lock',
            'pnpm-lock.yaml',
            'bun.lockb',
            'bun.lock',
        }

        local biome_config_filenames = { 'biome.json', 'biome.jsonc' }

        local project_root = vim.fs.root(bufnr, root_markers) or vim.fn.getcwd()
        local current_file_path = vim.api.nvim_buf_get_name(bufnr)
        local biome_config_file_paths = vim.fs.find(biome_config_filenames, {
            path = current_file_path,
            stop = vim.fs.dirname(project_root),
            type = 'file',
            limit = 1,
            upward = true,
        })

        if #biome_config_file_paths == 0 then return end

        local nearest_biome_configuration_file_path = unpack(
            biome_config_file_paths
        )
        local biome_configuration_path = vim.fs.dirname(
            nearest_biome_configuration_file_path
        )

        on_dir(biome_configuration_path)
    end,
}
