local group = vim.api.nvim_create_augroup(
    "DisableSearchHighlightAutomatically",
    { clear = true }
)

vim.api.nvim_create_autocmd("CursorMoved", {
    group = group,
    callback = function()
        if vim.v.hlsearch == 0 or vim.fn.mode() ~= 'n' then
            return
        end

        local is_okay, match_pos = pcall(vim.fn.searchpos, vim.fn.getreg("/"),
            "cnb")
        if not is_okay or match_pos[1] == 0 then return end

        local row, col = unpack(vim.api.nvim_win_get_cursor(0))
        if match_pos[1] == row and match_pos[2] == col + 1 then
            return
        end

        vim.schedule(function() vim.cmd.nohlsearch() end)
    end,
    desc = "Autoclear hlsearch when moving off a match.",
})

vim.api.nvim_create_autocmd("InsertEnter", {
    group = group,
    callback = vim.schedule_wrap(function()
        vim.cmd.nohlsearch()
    end),
    desc = "Autoclear hlsearch when entering insert mode.",
})
