local formatters_by_ft = {
  lua = { "stylua" },
  python = { "autopep8", "autoflake" },
  cpp = { "clang_format" },
  c = { "clang_format" },
  go = { "gofumpt" },
  cs = { "csharpier" },
  yaml = { "yamlfmt" },
  css = { "prettierd" },
  flow = { "prettierd" },
  graphql = { "prettierd" },
  html = { "prettierd" },
  json = { "prettierd" },
  javascriptreact = { "prettierd" },
  javascript = { "prettierd" },
  less = { "prettierd" },
  markdown = { "prettierd" },
  scss = { "prettierd" },
  typescript = { "prettierd" },
  typescriptreact = { "prettierd" },
  vue = { "prettierd" },
}

return {
  "stevearc/conform.nvim",
  event = "BufReadPost",
  opts = {
    formatters_by_ft = formatters_by_ft,
  },
  keys = {
    { "<leader>gf", function() require('conform').format() end, desc = "Format" }
  }
}

