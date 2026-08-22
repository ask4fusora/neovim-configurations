local success, mi = pcall(require, "mini.icons")
if not success then
    vim.notify(
        "`mini.icons` is either not installed or not available.",
        vim.log.levels.ERROR
    )
    return
end

mi.setup()
