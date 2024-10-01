-- "Move lines up and down"
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Keeps cursor in same position when appending lines to current lines when using J
-- vim.keymap.set("n", "J", "mzJ`z")

-- local map = vim.keymap.set
-- if os.getenv("TMUX") then
--   map("n", "<c-h>", "<cmd>TmuxNavigateLeft<cr>")
--   map("n", "<c-j>", "<cmd>TmuxNavigateDown<cr>")
--   map("n", "<c-k>", "<cmd>TmuxNavigateUp<cr>")
--   map("n", "<c-l>", "<cmd>TmuxNavigateRight<cr>")
-- else
--   map("n", "<c-h>", "<cmd>wincmd h<cr>")
--   map("n", "<c-j>", "<cmd>wincmd j<cr>")
--   map("n", "<c-k>", "<cmd>wincmd k<cr>")
--   map("n", "<c-l>", "<cmd>wincmd l<cr>")
-- end
--

-- Keeps cursor in center of screen when using C-d or C-u
-- vim.keymap.set("n", "<C-d>", "<C-d>zz")
-- vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Keeps cursor in center of screen when using search
-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")

-- Don't know why, but primeagen doesn't like capital q
vim.keymap.set("n", "Q", "<nop>")

