---@param root_dir string?
local function get_tsdk_path(root_dir)
    local project_roots = vim.fs.find(
        "node_modules",
        { path = root_dir, upward = true, limit = math.huge }
    )

    for _, project_root in ipairs(project_roots) do
        local typescript_path = vim.fs.joinpath(project_root, "typescript")
        local stat = vim.loop.fs_stat(typescript_path)

        if stat and stat.type == "directory" then
            return vim.fs.joinpath(typescript_path, "lib")
        end
    end

    return nil
end

--- Make sure `init_options` has `typescript = {}` at least.
---@param config vim.lsp.ClientConfig
local function configure_tsdk(config)
    local typescript_config = config.init_options.typescript
    ---@cast typescript_config table<string, any>

    if not typescript_config.tsdk then
        local tsdk_path = get_tsdk_path(config.root_dir)

        if tsdk_path ~= nil then
            typescript_config.tsdk = tsdk_path
        end
    end
end

local M = {
    configure_tsdk = configure_tsdk,
}

return M
