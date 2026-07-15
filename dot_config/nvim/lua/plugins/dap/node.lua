local get_args = require('utils').get_args

return {
    {
        'mxsdev/nvim-dap-vscode-js',
        ft = {
            'javascript',
            'typescript',
            'javascriptreact',
            'typescriptreact'
        },
        dependencies = {
            'mfussenegger/nvim-dap',
            {
                'microsoft/vscode-js-debug',
                commit = "4d7c704d3f07",
                build = 'npm i && npm run compile vsDebugServerBundle && mv dist out',
            },
        },
        config = function ()
            local dap = require('dap')

            local exts = {
                'javascript',
                'typescript',
                'javascriptreact',
                'typescriptreact'
            }

            -- TODO: if https://github.com/mxsdev/nvim-dap-vscode-js/issues/65 gets resolved then switch back to this mason_path
            -- local mason_path = require('mason-registry').get_package('js-debug-adapter'):get_install_path()

            ---@diagnostic disable-next-line: missing-fields
            require('dap-vscode-js').setup({
                debugger_path = vim.fn.stdpath('data') .. '/lazy/vscode-js-debug',
                adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' }
            })

            for _, ext in ipairs(exts) do
                dap.configurations[ext] = {
                    {
                        type = "pwa-node",
                        name = "Launch File Tests (pwa-node with jest)",
                        request = "launch",
                        args = function ()
                            local watch = string.lower(vim.fn.input('Watch? (y/[n])') or 'n')
                            watch = watch == 'y' and '--watchAll=true' or '--watchAll=false'
                            return {
                                "run",
                                "test",
                                "--",
                                "--runInBand",
                                watch,
                                "--runTestsByPath",
                                "${file}"
                            }
                        end,
                        cwd = vim.fn.getcwd(),
                        console = "integratedTerminal",
                        internalConsoleOptions = "neverOpen",
                        disableOptimisticBPs = "true",
                        runtimeExecutable = "npm",
                        protocol = "inspector",
                        sourceMaps = true
                    },
                    {
                        type = "pwa-node",
                        name = "Launch Workspace Tests (pwa-node with jest)",
                        request = "launch",
                        args = {
                            "run",
                            "test",
                            "--",
                            "test",
                            "--runInBand",
                            "--watchAll=false"
                        },
                        cwd = vim.fn.getcwd(),
                        console = "integratedTerminal",
                        internalConsoleOptions = "neverOpen",
                        disableOptimisticBPs = "true",
                        runtimeExecutable = "npm",
                        protocol = "inspector",
                        sourceMaps = true
                    },
                }
            end
        end,
        cond = not InVSCode
    },
    {
        'David-Kunz/jester',
        opts = {
            cmd = "npm test -- -t '$result' $file",
            path_to_jest_debug = './node_modules/.bin/react-scripts',
            dap = {
                type = "pwa-node",
                name = "Launch File Tests (pwa-node with jest)",
                request = "launch",
                args = {
                    "run",
                    "test",
                    "--",
                    "test",
                    "--runInBand",
                    "--watchAll=false"
                },
                cwd = vim.fn.getcwd(),
                console = "integratedTerminal",
                internalConsoleOptions = "neverOpen",
                disableOptimisticBPs = "true",
                protocol = "inspector",
                sourceMaps = true
            }
        },
        cond = not InVsCode
    }
}
