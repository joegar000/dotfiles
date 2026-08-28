return {
  {
    "mason.nvim",
    opts = {
      ensure_installed = {
        "stylua",
        "shfmt",
        "prettier",
        "ruff",
        "black",
        "csharpier",
        "clang-format",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        sh = { "shfmt" },
        python = { "ruff", "black" },
        javascript = { "prettier" },
        typescript = { "prettier" },
        javascriptreact = { "prettier" },
        typescriptreact = { "prettier" },
        json = { "prettier" },
        yaml = { "prettier" },
        cs = { "csharpier", "clang-format" },
      },
    },
  },
}

