return {
  'folke/zen-mode.nvim',
  keys = {
    { '<C-W>z', '<cmd>ZenMode<cr>', desc = "Toggle zen mode" }
  },
  opts = {
    window = {
      backdrop = 1,
      width = 0.6,
      height = 1,
    },
    plugins = {
      tmux = { enabled = true }
    }
  }
}
