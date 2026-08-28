-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Move selected lines up and down.
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move Selection Down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move Selection Up" })

-- Join the next line without moving the cursor.
vim.keymap.set("n", "<S-Down>", "mzJ`z", { desc = "Join Line Below" })

-- Disable Ex mode.
vim.keymap.set("n", "Q", "<nop>")

-- Return to Normal mode from a terminal.
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Enter Normal Mode" })
