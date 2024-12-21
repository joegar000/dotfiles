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
      tmux = { enabled = false },
      options = {
        enabled = true,
        laststatus = 0
      }
    },
    on_open = function(win)
      local view = require("zen-mode.view")
      local layout = view.layout(view.opts)
      vim.api.nvim_win_set_config(win, {
        width = layout.width,
        height = layout.height - 1,
      })
      vim.api.nvim_win_set_config(view.bg_win, {
        width = vim.o.columns,
        height = view.height() - 1,
        row = 1,
        col = layout.col,
        relative = "editor",
      })
    end,
  },
  cond = not InVSCode
}
