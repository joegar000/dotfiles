return {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.6', -- or, branch = '0.1.x',
    dependencies = {
        {
            'nvim-lua/plenary.nvim'
        },
        {
            'folke/which-key.nvim',
            optional = true,
            opts = {
                defaults = {
                    ['<leader>t'] = { name = '+telescope' }
                }
            }
        }
    },
    keys = {
        { '<leader>tf', "<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' } })<CR>", desc = 'Find files' },
        { '<leader>bl', "<cmd>lua require'telescope.builtin'.buffers({ show_all_buffers = true })<CR>", desc = 'Show all buffers' },
        { '<leader>tg', '<cmd>Telescope git_files<CR>', desc = 'Git files' },
        { '<leader>tlg', '<cmd>Telescope live_grep<CR>', desc = 'Live grep' },
        { '<leader>tk', '<cmd>Telescope keymaps<CR>', desc = 'Keymaps' },
        { '<leader>tn', '<cmd>Telescope notify<CR>', desc = 'Nofication history' },
        {
            '<leader>tt',
            function ()
                require('telescope.builtin').find_files({
                    cwd = './__notes__/',
                    prompt_title = "Project Notes"
                })
            end,
            desc = 'Open notes'
        }
    },
    cmd = 'Telescope',
    config = function ()
        local actions = require('telescope.actions')
        require('telescope').setup({
            defaults = {
                mappings = {
                    i = {
                        ['<C-c>'] = false,
                        ['<esc>'] = actions.close
                    },
                    n = {
                        ['<C-c>'] = actions.close
                    }
                }
            },
            pickers = {
                live_grep = {
                    additional_args = function(opts)
                        return { '--hidden', '-g', '!.git' }
                    end
                }
            }
        })
    end,
    cond = not InVSCode
}
