vim.o.autocomplete = false
vim.o.completeopt = "fuzzy,menuone,noselect"

vim.g.nominicompletion_filetypes = {} ---@type string[]

vim.api.nvim_create_autocmd("LspAttach", {
    once = true,
    callback = function()
        require("mini.completion").setup({
            -- NOTE: Mimicking `disable_completion_on_type`.
            delay = { completion = 1000000 },
            lsp_completion = { source_func = "omnifunc", auto_setup = false },
        })
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        vim.bo[args.buf].omnifunc = "v:lua.MiniCompletion.completefunc_lsp"
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
        local array = require("lua.array")

        local matched_filetype_pos = array.find_pos(
            vim.g.nominicompletion_filetypes or {},
            function(filetype)
                return filetype == vim.bo.filetype
            end
        )

        if matched_filetype_pos ~= 0 then
            vim.b.minicompletion_disable = true
        end
    end,
})
