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
    root_dir = function(bufnr, on_dir)
        local node_root_markers = {
            '.git',
            'package-lock.json',
            'yarn.lock',
            'pnpm-lock.yaml',
            'bun.lockb',
            'bun.lock'
        }

        local deno_root = vim.fs.root(bufnr, { 'deno.json', 'deno.jsonc' })
        local deno_lock_root = vim.fs.root(bufnr, { 'deno.lock' })
        local node_root = vim.fs.root(bufnr, node_root_markers)

        if deno_lock_root and (not node_root or #deno_lock_root > #node_root) then
            -- deno lock is closer than node lock -> abort
            return
        end

        if deno_root and (not node_root or #deno_root >= #node_root) then
            -- deno config is closer than or equal to node lock -> abort
            return
        end

        -- project is standard TS, not deno
        on_dir(node_root or vim.fn.getcwd())
    end,
}
