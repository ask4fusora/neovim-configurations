local success, mini_ai = pcall(require, "mini.ai")
if not success then
    vim.print("`mini.ai` is either not installed or not available.", mini_ai)
    return
end

mini_ai.setup()
