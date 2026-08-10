_G.Formatter = {}

---@type FormatterKind[]
local biome_formatters = {
    { language_server = { name = "biome" } },
    { code_action = "source.fixAll.biome" },
}

---@type table<string, FormatterKind[]?>
_G.Formatter.formatters_by_filetype = {
    lua = {
        {
            external = {
                command = "stylua",
                arguments = {
                    "--syntax=LuaJit",
                    "--stdin-filepath={buffer_path}",
                    "-",
                },
            },
        },
    },

    typescriptreact = biome_formatters,
    typescript = biome_formatters,

    typst = { { language_server = { name = "tinymist" } } },

    nu = { { external = { command = "nufmt", arguments = { "--stdin" } } } },
}

return _G.Formatter
