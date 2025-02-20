return {
  "folke/noice.nvim",
  commit = "df448c649ef6bc5a6a633a44f2ad0ed8d4442499",
  dependencies = {
    'MunifTanjim/nui.nvim',
    "rcarriga/nvim-notify"
  },
  event = "VeryLazy",
  config = function ()
    vim.diagnostic.config({
      virtual_text = false,
      float = {
        border = 'rounded'
      }
    })
    vim.api.nvim_command('highlight! link NormalFloat Normal')
    vim.api.nvim_command('highlight! link NvimTreeNormal Normal')
    require('noice').setup({
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        hover = {
          enabled = true,
          view = "hover",
          border = {
            style = "rounded"
          }
        },
        signature = {
          enabled = true,
          auto_open = {
            enabled = false
          },
          view = "hover",
          border = {
            style = "rounded"
          }
        },
        documentation = {
          view = "hover",
          opts = { -- lsp_docs settings
            replace = true,
            render = "plain",
            format = { "{message}" },
            position = { row = 2, col = 2 },
            size = {
              max_width = math.floor(0.8 * vim.api.nvim_win_get_width(0)),
              max_height = 15,
            },
            border = {
              style = "rounded",
            },
          },
        }
      },
      routes = {
        {
          filter = {
            event = "msg_show",
            any = {
              { find = "%d+L, %d+B" },
              { find = "; after #%d+" },
              { find = "; before #%d+" },
            },
          },
          view = "mini",
        },
      },
      presets = {
        bottom_search = false,
        command_palette = true,
        long_message_to_split = true,
        inc_rename = true,
      },
    })
  end,
  keys = {
    { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
    { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
    { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
    { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
    { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
    { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll Forward", mode = {"i", "n", "s"} },
    { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll Backward", mode = {"i", "n", "s"}},
  },
  cond = not InVSCode
}
