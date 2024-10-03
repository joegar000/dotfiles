local function flatten_ft_to_str(t)
  local flattened = {}
  for _, ft in pairs(t) do
    for _, s in ipairs(ft) do
      table.insert(flattened, s)
    end
  end
  return flattened
end

local function merge_tables(t1, t2)
  local merged = {}

  -- Copy all elements from the first table
  for k, v in pairs(t1) do
    merged[k] = v
  end

  -- Copy all elements from the second table, overriding duplicates
  for k, v in pairs(t2) do
    merged[k] = v
  end

  return merged
end

return {
  {
    'williamboman/mason.nvim',
    lazy = false,
    keys = {
      { '<leader>m', '<cmd>Mason<CR>', desc = 'Open Mason' }
    },
    config = function()
      require('mason').setup({
        ui = {
          border = 'rounded'
        }
      })
    end
  },
  {
    'williamboman/mason-lspconfig.nvim'
  },
  {
    "neovim/nvim-lspconfig",
    cmd = { 'LspInfo', 'LspInstall', 'LspStart' },
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
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
          'ts_ls'
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
      vim.diagnostic.config({
        virtual_text = false,
        float = {
          border = 'rounded'
        }
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
      { "<leader>cc",  vim.lsp.codelens.run,                                                                   desc = "Run Codelens",               mode = { "n", "v" } },
      { "<leader>cC",  vim.lsp.codelens.refresh,                                                               desc = "Refresh & Display Codelens", mode = { "n" } },
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
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = {
      "mfussenegger/nvim-lint",
      "stevearc/conform.nvim"
    },
    event = "BufReadPost",
    config = function()
      local linters_by_ft = {
        python = {
          "flake8",
          "mypy",
          "pylint"
        },
        javascript = {
          "eslint_d"
        },
        javascriptreact = {
          "eslint_d"
        },
        typescript = {
          "eslint_d"
        },
        typescriptreact = {
          "eslint_d"
        },
        htmldjango = {
          "djlint", "jinja-lsp"
        }
      }

      local formatters_by_ft = {
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

      local ensure_installed = merge_tables(flatten_ft_to_str(linters_by_ft), flatten_ft_to_str(formatters_by_ft))
      require('mason-tool-installer').setup({
        ensure_installed = ensure_installed,
        integrations = {
          ['mason-nvim-dap'] = true
        }
      })

      require("lint").linters_by_ft = linters_by_ft

      vim.api.nvim_create_autocmd({ "BufWritePost" }, {
        callback = function()
          require("lint").try_lint()
        end,
      })

      require('conform').setup({
        formatters_by_ft = formatters_by_ft,
      })
    end,
    keys = {
      { "<leader>gf", function() require('conform').format() end, desc = "Format" }
    }
  }
}
