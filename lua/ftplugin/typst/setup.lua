local success, tp = pcall(require, "typst-preview")
if not success then
    vim.print("`typst-preview` is either not installed or not available.", tp)
    return
end

tp.setup({
    dependencies_bin = {
        tinymist = "tinymist",
        websocat = "websocat",
    },
})
