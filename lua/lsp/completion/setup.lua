local success, mc = pcall(require, "mini.completion")
if not success then
    vim.notify(
        "`mini.completion` is either not installed or not available.",
        vim.log.levels.ERROR
    )
    return
end

mc.setup({
    -- NOTE: Mimicking `disable_completion_on_type`.
    delay = { completion = 1000000 },
    lsp_completion = { source_func = "omnifunc" },
})

vim.o.omnifunc = "v:lua.MiniCompletion.completefunc_lsp"

vim.g.nominicompletion_filetypes = {} ---@type string[]

vim.api.nvim_create_autocmd("FileType", {
    callback = function(args)
        ---@type string|nil
        local matched_filetype_pos = vim.iter(
            vim.g.nominicompletion_filetypes or {} ---@type string[]
        ):find(function(filetype)
            ---@cast filetype string
            return filetype == vim.bo[args.buf].filetype
        end)

        if matched_filetype_pos ~= nil then
            vim.b[args.buf].minicompletion_disable = true
        end
    end,
})
