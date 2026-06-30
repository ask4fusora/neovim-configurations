local M = {}

---@param key string
---@param value any
function M.insert_to_list(key, value)
    local temporary_table = vim.g[key] or {}
    if type(value) == "table" then
        table.move(value, 1, #value, #temporary_table + 1, temporary_table)
    else
        table.insert(temporary_table, value)
    end
    vim.g[key] = temporary_table
end

return M
