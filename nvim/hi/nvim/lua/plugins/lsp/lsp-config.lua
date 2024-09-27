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
          'tsserver'
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
  }
}
