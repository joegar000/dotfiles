return {
  {
    'williamboman/mason.nvim',
    keys = {
      { '<leader>m', '<cmd>Mason<CR>', desc = 'Open Mason' }
    },
    config = function()
      require('mason').setup({
        ui = {
          border = 'rounded',
          width = 0.8,
          height = 0.8
        }
      })
    end,
    cond = not InVSCode
  },
  {
    "neovim/nvim-lspconfig",
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      'williamboman/mason-lspconfig.nvim',
      'folke/neodev.nvim',
    },
    lazy = false,
    config = function()
      require('neodev').setup()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
      local lspconfig = require('lspconfig')
      require("mason-lspconfig").setup({
        auto_install = true,
        ensure_installed = {
          'lua_ls',
          'basedpyright',
          'pylsp',
          'ts_ls',
          'jinja_lsp'
        },
        handlers = {
          -- this first function is the "default handler"
          -- it applies to every language server without a "custom handler"
          function(server_name)
            lspconfig[server_name].setup({
              capabilities = capabilities
            })
          end
        }
      })

      lspconfig['basedpyright'].setup({
        capabilities = capabilities,
        settings = {
          basedpyright = {
            typeCheckingMode = 'standard'
          }
        }
      })

      lspconfig['pylsp'].setup({
        capabilities = capabilities,
        settings = {
          pylsp = {
            configurationSources = { 'flake8' },
            flake8 = { enabled = true },
            pycodestyle = { enabled = false },
            mccabe = { enabled = false },
            pyflakes = { enabled = false },
          }
        }
      })

      -- Since jinja_lsp only takes a single configuration. It is best to set this up in .nvim.lua
      -- lspconfig['jinja_lsp'].setup({
      --   capabilities = capabilities,
      --   filetypes = { 'jinja', 'jinja.html', 'htmldjango' },
      --   init_options = {
      --     templates = './src/templates',
      --     backend = { './src' },
      --     lang = "python"
      --   }
      -- })

      lspconfig['html'].setup({
        capabilities = capabilities,
        filetypes = { 'html', 'tpl', 'jinja', 'jinja.html', 'htmldjango' }
      })
    end,
    keys = {
      { 'K',           vim.lsp.buf.hover,                                                                      desc = 'Hover' },
      { 'gd',          function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end,      desc = "Goto Definition" },
      { 'gD',          vim.lsp.buf.declaration,                                                                desc = "Goto Declaration" },
      { 'gI',          function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end,  desc = "Goto Implementation" },
      { 'gy',          function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
      { 'gr',          function() require("telescope.builtin").lsp_references({ reuse_win = true }) end,       desc = 'References' },
      { 'gK',          vim.lsp.buf.signature_help,                                                             desc = 'Signature help' },
      { '<C-k>',       vim.lsp.buf.signature_help,                                                             desc = 'Signature help',             mode = 'i' },
      { '<leader>cws', vim.lsp.buf.workspace_symbol,                                                           desc = 'Workspace symbols' },
      { '<leader>cop', vim.diagnostic.open_float,                                                              desc = 'Open diagnostic float' },
      { '<leader>ca',  vim.lsp.buf.code_action,                                                                desc = 'Code action' },
      { '<leader>cr',  vim.lsp.buf.rename,                                                                     desc = 'Rename' },
      { ']d',          vim.diagnostic.goto_next,                                                               desc = 'Go to next diagnostic' },
      { '[d',          vim.diagnostic.goto_prev,                                                               desc = 'Go to previous diagnostic' },
      { '<leader>cc',  vim.lsp.codelens.run,                                                                   desc = 'Run Codelens',               mode = { 'n', 'v' } },
      { '<leader>cC',  vim.lsp.codelens.refresh,                                                               desc = 'Refresh & Display Codelens', mode = { 'n' } },
      {
        "<leader>cA",
        function()
          vim.lsp.buf.code_action({
            context = {
              only = {
                "source",
              },
              diagnostics = {},
            },
          })
        end,
        desc = "Source Action",
      },
    },
    cond = not InVSCode
  },
  {
    "rshkarin/mason-nvim-lint",
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      "williamboman/mason.nvim",
      "mfussenegger/nvim-lint"
    },
    config = function()
      require('lint').linters_by_ft = {
        python = { "flake8" },
        javascript = { "eslint_d" },
        javascriptreact = { "eslint_d" },
        typescript = { "eslint_d" },
        typescriptreact = { "eslint_d" },
        htmldjango = { "djlint" },
        jinja = { "djlint" },
        ['jinja.html'] = { "djlint" },
        yaml = { "actionlint", "yamllint" },
        json = { "jsonlint" }
      }

      require('mason-nvim-lint').setup({
        ensure_installed = { "flake8", "eslint_d", "djlint", "actionlint" },
      })
      vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeavePre" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })
    end,
    cond = not InVSCode
  },
  {
    "zapling/mason-conform.nvim",
    dependencies = {
      "williamboman/mason.nvim",
      "stevearc/conform.nvim"
    },
    config = function()
      require('conform').setup({
        formatters_by_ft = {
          lua = { "stylua" },
          python = { "autopep8", "autoflake" },
          yaml = { "yamlfmt" },
          css = { "prettierd" },
          flow = { "prettierd" },
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
      })
      require('mason-conform').setup()
    end,
    keys = {
      { '<leader>gf', function() require('conform').format() end, desc = 'Format' },
    },
    cond = not InVSCode
  }
  -- {
  --   "jay-babu/mason-null-ls.nvim",
  --   event = { "BufReadPre", "BufNewFile" },
  --   dependencies = {
  --     "williamboman/mason.nvim",
  --     {
  --       "nvimtools/none-ls.nvim",
  --       event = { "BufReadPre", "BufNewFile" },
  --       dependencies = { "nvim-lua/plenary.nvim" },
  --     }
  --   },
  --   config = function()
  --     -- primary source of truth is mason
  --     require('mason-null-ls').setup({
  --       ensure_installed = { "stylua", "flake8", "mypy", "autopep8", "autoflake", "eslint_d", "djlint", "yamlfmt", "prettierd" },
  --       automatic_installation = false
  --     })
  --     local null_ls = require('null-ls')
  --     null_ls.setup({
  --       sources = {
  --         null_ls.builtins.formatting.djhtml.with({
  --           filetypes = { "django", "jinja.html", "htmldjango" }
  --         })
  --       }
  --     })
  --   end,
  --   cond = not InVSCode
  -- },
}
