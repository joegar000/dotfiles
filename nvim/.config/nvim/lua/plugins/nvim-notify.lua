return {
  "rcarriga/nvim-notify",
  lazy = false,
  opts = {
    stages = "slide",
    render = "simple",
    timeout = 3000,
    max_height = function()
      return math.floor(vim.o.lines * 0.75)
    end,
    max_width = function()
      return math.floor(vim.o.columns * 0.75)
    end,
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { zindex = 100 })
    end,
  },
  keys = {
    {
      "<leader>un",
      function()
        require("notify").dismiss({ silent = true, pending = true })
      end,
      desc = "Dismiss All Notifications",
    },
  },
  init = function()
    vim.notify = require("notify")
  end,
  cond = not InVSCode
}


