vim.api.nvim_create_autocmd("PackChanged", {
    callback = function(args)
        local name, kind = args.data.spec.name, args.data.kind
        if name == "fff.nvim" and (kind == "install" or kind == "update") then
            if not args.data.active then
                vim.cmd.packadd("fff.nvim")
            end
            require("fff.download").download_or_build_binary()
        end
    end,
})
