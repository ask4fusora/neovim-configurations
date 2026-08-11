---@type vim.lsp.Config
return {
    cmd = require("lsp.ecosystem.nodejs.cmd").configure_cmd( "yaml-language-server"),
    filetypes = {
        "yaml",
        "yaml.docker-compose",
        "yaml.gitlab",
        "yaml.helm-values",
    },
    root_markers = { ".git" },
    settings = {
        -- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
        redhat = { telemetry = { enabled = false } },
        -- Formatting disabled by default in `yaml-language-server`.
        yaml = { format = { enable = true } },
    },
}
