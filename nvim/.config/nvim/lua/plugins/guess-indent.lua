return {
    "nmac427/guess-indent.nvim",
    keys = { { "<leader>>", "<cmd>GuessIndent<CR>", desc = "Guess File Indentation" } },
    event = "BufReadPost",
    config = function()
        require('guess-indent').setup({
            filetype_exclude = { "dashboard", "NvimTree", "lazy", "mason", "netrw" }
        })
    end
}
