---@type fsr.initializer.Module
return {
    exec = function(args)
        local name, kind = args.data.spec.name, args.data.kind
        if name == "fff" and (kind == "install" or kind == "update") then
            if not args.data.active then
                vim.cmd.packadd("fff")
            end
            require("fff.download").download_or_build_binary()
        end
    end,
}
