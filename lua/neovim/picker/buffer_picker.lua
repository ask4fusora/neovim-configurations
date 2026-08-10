local MAX_BUFFER_PICKER_LINES = 15

local api = vim.api

---@return integer[]
local function list_buffers()
    return vim.tbl_filter(function(buf)
        return api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted
    end, api.nvim_list_bufs())
end

---@param buffers integer[]
---@return string[]
local function buffers_to_paths(buffers)
    return vim.tbl_map(function(buf)
        local buf_name = api.nvim_buf_get_name(buf)
        local buf_fname = buf_name == "" and "untitled"
            or vim.fn.fnamemodify(buf_name, ":~:.")

        local modified_marker = vim.bo[buf].modified and " [+]" or ""

        return ("%s%s"):format(buf_fname, modified_marker)
    end, buffers)
end

---@param buffer_paths string[]
---@return integer bufnr
local function create_picker_buffer(buffer_paths)
    local bufnr = api.nvim_create_buf(false, true)

    api.nvim_buf_set_lines(bufnr, 0, -1, false, buffer_paths)
    vim.bo[bufnr].modifiable = false
    vim.bo[bufnr].bufhidden = "wipe"

    return bufnr
end

---@param buffer_paths string[]
---@return integer width
---@return integer height
local function calc_buf_dimensions(buffer_paths)
    local width = 1
    local height = math.min(#buffer_paths, MAX_BUFFER_PICKER_LINES)

    for _, line in ipairs(buffer_paths) do
        width = math.max(width, vim.fn.strdisplaywidth(line))
    end

    width = math.min(
        width + vim.o.sidescrolloff * 2,
        vim.o.columns - vim.o.sidescrolloff * 2
    )

    return width, height
end

---@param buffers integer[]
---@param current_bufnr integer
---@param picker_bufnr integer
---@param width integer
---@param height integer
local function open_picker_win(
    buffers,
    current_bufnr,
    picker_bufnr,
    width,
    height
)
    local win = api.nvim_open_win(picker_bufnr, true, {
        relative = "editor",
        style = "minimal",
        title = " Buffers ",
        title_pos = "left",
        width = width,
        height = height,
        row = math.floor((vim.o.lines - height) / 2),
        col = math.floor((vim.o.columns - width) / 2),
    })

    vim.wo[win].cursorline = true
    vim.wo[win].wrap = false

    -- Initially select the current buffer.

    for index, bufnr in ipairs(buffers) do
        if bufnr == current_bufnr then
            api.nvim_win_set_cursor(win, { index, 0 })
            break
        end
    end

    return win
end

---@param win integer
local function close_picker(win)
    if api.nvim_win_is_valid(win) then
        api.nvim_win_close(win, true)
    end
end

---@param win integer
---@param buffers integer[]
local function open_buffer(win, buffers)
    local index = unpack(api.nvim_win_get_cursor(win))
    local selected_bufnr = buffers[index]

    close_picker(win)

    if selected_bufnr and api.nvim_buf_is_valid(selected_bufnr) then
        api.nvim_set_current_buf(selected_bufnr)
    end
end

---@param current_win integer
---@param picker_win integer
---@param picker_bufnr integer
---@param buffers integer[]
---@param buffer_paths string[]
local function close_buffer(
    current_win,
    picker_win,
    picker_bufnr,
    buffers,
    buffer_paths
)
    local index = unpack(api.nvim_win_get_cursor(picker_win))
    local selected_bufnr = buffers[index]
    assert(
        type(selected_bufnr) == "number",
        "`buffers[index]` should have been `integer`."
    )

    local success = pcall(api.nvim_win_call, current_win, function()
        api.nvim_buf_delete(selected_bufnr, {
            force = false,
        })
    end)

    if not success then
        vim.notify(
            "Cannot close buffer unsaved since last change.",
            vim.log.levels.ERROR
        )
        return
    end

    -- Remove selected buffer from memory.

    table.remove(buffers, index)
    table.remove(buffer_paths, index)

    -- Remove selected buffer from picker UI.

    vim.bo[picker_bufnr].modifiable = true
    api.nvim_buf_set_lines(picker_bufnr, 0, -1, false, buffer_paths)
    vim.bo[picker_bufnr].modifiable = false

    -- Update picker height.

    local _, height = calc_buf_dimensions(buffer_paths)
    if height == 0 then
        close_picker(picker_win)
        return
    end

    api.nvim_win_set_config(picker_win, {
        height = height,
    })
end

---@param current_win integer
---@param picker_win integer
---@param picker_bufnr integer
---@param buffers integer[]
---@param buffer_paths string[]
local function set_picker_keymaps(
    current_win,
    picker_win,
    picker_bufnr,
    buffers,
    buffer_paths
)
    vim.keymap.set("n", "<CR>", function()
        open_buffer(picker_win, buffers)
    end, {
        buffer = picker_bufnr,
        nowait = true,
    })

    vim.keymap.set("n", "q", function()
        close_picker(picker_win)
    end, {
        buffer = picker_bufnr,
        nowait = true,
    })

    vim.keymap.set("n", "<Esc>", function()
        close_picker(picker_win)
    end, {
        buffer = picker_bufnr,
        nowait = true,
    })

    vim.keymap.set("n", "dd", function()
        close_buffer(
            current_win,
            picker_win,
            picker_bufnr,
            buffers,
            buffer_paths
        )
    end, {
        buffer = picker_bufnr,
        nowait = true,
    })
end

local function pick_buffer()
    local buffers = list_buffers()
    if #buffers == 0 then
        return
    end

    local current_bufnr = api.nvim_get_current_buf()
    local current_win = api.nvim_get_current_win()
    local buffer_paths = buffers_to_paths(buffers)
    local picker_bufnr = create_picker_buffer(buffer_paths)
    local width, height = calc_buf_dimensions(buffer_paths)
    local picker_win =
        open_picker_win(buffers, current_bufnr, picker_bufnr, width, height)

    set_picker_keymaps(
        current_win,
        picker_win,
        picker_bufnr,
        buffers,
        buffer_paths
    )
end

return {
    pick_buffer = pick_buffer,
}
