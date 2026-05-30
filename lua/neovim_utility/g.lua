local M = {}

---@param key string
---@param value any
function M.insert_to_list(key, value)
    local temporary_table = vim.g[key] or {}
    table.insert(temporary_table, value)
    vim.g[key] = temporary_table
end

return M
