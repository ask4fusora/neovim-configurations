local root_markers = {
    "nufmt.nuon",
}

---@type vim.lsp.Config
return {
    cmd = { "nu", "--lsp" },
    filetypes = { "nu" },
    root_markers = { ".git", root_markers },
}
