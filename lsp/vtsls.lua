--- local vue_language_server_path = '/path/to/@vue/language-server'
--- local vue_plugin = {
---   name = '@vue/typescript-plugin',
---   location = vue_language_server_path,
---   languages = { 'vue' },
---   configNamespace = 'typescript',
--- }
--- vim.lsp.config('vtsls', {
---   settings = {
---     vtsls = {
---       tsserver = {
---         globalPlugins = {
---           vue_plugin,
---         },
---       },
---     },
---   },
---   filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' },
--- })
--- ```
---
--- - `location` MUST be defined. If the plugin is installed in `node_modules`, `location` can have any value.
--- - `languages` must include vue even if it is listed in filetypes.
--- - `filetypes` is extended here to include Vue SFC.

---@type vim.lsp.Config
return {
    cmd = { 'vtsls', '--stdio' },
    init_options = {
        hostInfo = 'neovim',
    },
    filetypes = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
    },
    --[[
    NOTE: We need `root_dir` function, because `deno` is troublesome.
    We would not want to start `vtsls` if `deno`'s root is closer than or equal to `node`'s root.
    --]]
    root_dir = function(bufnr, on_dir)
        local deno_root_markers = { { 'deno.json', 'deno.jsonc' }, 'deno.lock' }
        local node_root_markers = {
            'package-lock.json',
            'yarn.lock',
            'pnpm-lock.yaml',
            'bun.lockb',
            'bun.lock',
        }

        local deno_root_dir = vim.fs.root(bufnr, deno_root_markers)
        local node_root_dir = vim.fs.root(bufnr, { node_root_markers, { '.git' } })

        if deno_root_dir == nil then
            return on_dir(node_root_dir or vim.fn.getcwd())
        end

        if node_root_dir == nil or #deno_root_dir >= #node_root_dir then
            -- `node` root not found but `deno` root found -> abort.
            -- `deno` root is closer than or equal to `node` root -> abort.
            return
        end

        on_dir(node_root_dir or vim.fn.getcwd())
    end,
}
