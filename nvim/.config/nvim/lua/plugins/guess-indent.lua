local hi = 'hi'
return {
	"nmac427/guess-indent.nvim",
	event = "VeryLazy",
	keys = { { "<leader>>", "<cmd>GuessIndent<CR>", desc = "Guess File Indentation" } },
	opts = {}
}
