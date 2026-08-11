require("neovim.formatter.global_formatter_registry")

---@param path string
---@param opts vim.ui.open.Opts?
local function nushell_ui_open(path, opts)
    local is_uri = path:match("%w+:")
    if not is_uri then
        path = vim.fs.normalize(path)
    end

    opts = opts or {}
    local cmd ---@type string[]
    local job_opt = { text = true, detach = true } --- @type vim.SystemOpts

    if opts.cmd then
        cmd = vim.list_extend(opts.cmd --[[@as string[] ]], { path })

        if cmd[1] == "xdg-open" then
            job_opt.stdout = false
            job_opt.stderr = false
        end
    else
        cmd = { "nu", "-c", ("start '%s'"):format(path) }
    end

    return vim.system(cmd, job_opt)
end

vim.ui.open = nushell_ui_open
