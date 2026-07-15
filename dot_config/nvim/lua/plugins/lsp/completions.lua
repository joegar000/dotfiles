return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      { 'hrsh7th/cmp-buffer' },
      { 'onsails/lspkind.nvim' },
      {
        'L3MON4D3/LuaSnip',
        dependencies = {
          'saadparwaiz1/cmp_luasnip',
          'rafamadriz/friendly-snippets'
        }
      },
      {
        'zbirenbaum/copilot-cmp',
        dependencies = {
          'zbirenbaum/copilot.lua'
        },
        enabled = true,
        config = function ()
          require('copilot_cmp').setup()
        end
      }
    },
    event = 'InsertEnter',
    config = function()
      local cmp = require('cmp')
      require("luasnip.loaders.from_vscode").lazy_load()

      cmp.setup({
        snippet = {
          expand = function(args)
            require('luasnip').lsp_expand(args.body)
          end,
        },
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), {'i','c'}),
          ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), {'i','c'}),
          ['<C-u>'] = cmp.mapping.scroll_docs(-4),
          ['<C-d>'] = cmp.mapping.scroll_docs(4),
          ['<C-y>'] = cmp.mapping.confirm({ select = true }),
          ['<C-Space>'] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources(
          {
            {
              name = 'nvim_lsp',
              entry_filter = function(entry, ctx)
                return require("cmp").lsp.CompletionItemKind.Text ~= entry:get_kind()
              end
            },
            { name = 'luasnip' },
            { name = 'copilot' }
          }, {
            { name = 'buffer' } -- TODO: SILL NOT WORKING
          }
        ),
        formatting = {
          format = require('lspkind').cmp_format({
            mode = 'symbol',
            max_width = 50,
            symbol_map = {
              Copilot = ''
            }
          })
        }
      })
    end,
    cond = not InVSCode
  }
}
