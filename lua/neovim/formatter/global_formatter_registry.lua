_G.Formatter = {}

---@type FormatterKind[]
local biome_formatters = {
    { language_server = { name = "biome" } },
    { code_action = "source.fixAll.biome" }
}

---@type table<string, FormatterKind[]?>
_G.Formatter.formatters_by_filetype = {
    lua = { { language_server = { name = "lua-language-server" } } },
    typescriptreact = biome_formatters,
    typescript = biome_formatters,
    typst = { { language_server = { name = "tinymist" } } },
}

return _G.Formatter
