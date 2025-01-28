-- I'm not using it right now, but GitHub's official copilot nvim plugin is https://github.com/github/copilot.vim
-- This is an alternative written in lua
return {
    "zbirenbaum/copilot.lua",
    enabled = true,
    cond = not InVSCode,
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
        require("copilot").setup({
            suggestion = { enabled = false },
            panel = { enabled = true }
        })
    end,
}

