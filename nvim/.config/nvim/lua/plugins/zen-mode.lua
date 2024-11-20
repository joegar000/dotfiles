return {
  'folke/zen-mode.nvim',
  keys = {
    { '<C-W>z', '<cmd>ZenMode<cr>', desc = "Toggle zen mode" },
    { '<leader>z', '<cmd>ZenMode<cr>', desc = "Toggle zen mode" }
  },
  opts = {
    window = {
      backdrop = 1,
      width = 0.6,
      height = 1,
    },
    plugins = {
      -- Would use but it automatically minimizes pane when exiting zen mode, even if pane started zoomed
      tmux = { enabled = false }
    }
  }
}
