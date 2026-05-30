---@param root_dir string?
local function get_tsdk_path(root_dir)
    local project_roots = vim.fs.find(
        'node_modules',
        { path = root_dir, upward = true, limit = math.huge }
    )

    for _, project_root in ipairs(project_roots) do
        local typescript_path = vim.fs.joinpath(project_root, 'typescript')
        local stat = vim.loop.fs_stat(typescript_path)

        if stat and stat.type == 'directory' then
            return vim.fs.joinpath(typescript_path, 'lib')
        end
    end

    return nil
end

local M = {
    get_tsdk_path = get_tsdk_path,
}

return M
