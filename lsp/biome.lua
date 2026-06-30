---@type vim.lsp.Config
return {
    cmd = require("lsp.ecosystem.nodejs.cmd").configure_cmd(
        "biome",
        { "lsp-proxy" },
        false
    ),
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
    root_markers = { { "biome.json", "biome.jsonc" } },
}
