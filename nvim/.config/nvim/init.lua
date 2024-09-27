local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

IsWindows = package.config:sub(1,1) == '\\'
InNeovide = vim.g.neovide

if not IsWindows then
  vim.g.neovide_transparency = 0.9
  vim.g.neovide_window_blurred = true
end

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

vim.keymap.set('n', '<leader>l', ':Lazy<CR>')

function toSeconds(minutes)
  return minutes * 60
end

require("config")
require("lazy").setup({
  spec = {
    import = "plugins"
  },
  ui = {
    border = "rounded"
  },
  install = {
    colorscheme = { "catppuccin" }
  },
  git = {
    timeout = toSeconds(15)
  }
})

