return {
  "mfussenegger/nvim-lint",
  event = "BufReadPost",
  enabled = false,
  config = function()
    require("lint").linters_by_ft = {
      python = {
        "flake8",
        "mypy",
        "pylint"
      },
      javascript = {
        "eslint",
        "eslint_d"
      },
      javascriptreact = {
        "eslint",
        "eslint_d"
      },
      typescript = {
        "eslint",
        "eslint_d"
      },
      typescriptreact = {
        "eslint",
        "eslint_d"
      },
      htmldjango = {
        "djlint", "jinja-lsp"
      }
    }

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
