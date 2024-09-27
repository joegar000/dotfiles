return {
    'nvim-neotest/neotest',
    dependencies = {
        'nvim-neotest/nvim-nio',
        'nvim-lua/plenary.nvim',
        'antoinemadec/FixCursorHold.nvim',
        'nvim-treesitter/nvim-treesitter',
        'nvim-neotest/neotest-jest',
        'nvim-neotest/neotest-python'
    },
    config = function(_, opts)
        local adapters = {
            require('neotest-jest')({
                jestCommand = "npm test --",
                jestConfigFile = 'custom.jest.config.ts',
                env = { CI = true },
                cwd = function(path)
                    return vim.fn.getcwd()
                end
            })
        }
        table.insert(opts, adapters)
        table.insert(opts, {
            config = {
                output_panel = { open_on_run = true },
                diagnostic = true
            }
        })
        require('neotest').setup(opts)
    end
}
