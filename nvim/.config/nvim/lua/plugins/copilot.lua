-- I'm not using it right now, but GitHub's official copilot nvim plugin is https://github.com/github/copilot.vim
return {
    "zbirenbaum/copilot.lua",
    enabled = false,
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

