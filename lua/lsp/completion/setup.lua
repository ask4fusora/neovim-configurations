local success, mc = pcall(require, "mini.completion")
if not success then
    vim.print("`mini.completion` is either not installed or not available.", mc)
    return
end

local array = require("lua.array")

mc.setup({
    -- NOTE: Mimicking `disable_completion_on_type`.
    delay = { completion = 1000000 },
    lsp_completion = { source_func = "omnifunc" },
})

vim.o.omnifunc = "v:lua.MiniCompletion.completefunc_lsp"

vim.g.nominicompletion_filetypes = {} ---@type string[]

vim.api.nvim_create_autocmd("FileType", {
    callback = function()
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
