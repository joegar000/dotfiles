-- These links are from the debugpy repo. They can help you get started.
-- CLI reference: https://github.com/microsoft/debugpy/wiki/Command-Line-Reference
-- Config reference: https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings
--
-- Run Python app with `python -m debugpy [--wait-for-client] --listen 0.0.0.0:5678 -m 'regular_run_command'`

local get_args = require('utils').get_args

return {
  'mfussenegger/nvim-dap-python',
  ft = 'python',
  dependencies = {
    'mfussenegger/nvim-dap',
  },
  config = function ()
    require('dap-python').setup('python')
    local dap = require('dap')

    table.insert(dap.configurations.python, {
      name = "Launch Flask Server",
      type = "python",
      request = "launch",
      console = "integratedTerminal",
      module = "flask",
      justMyCode = false,
      env = function ()
        local path = vim.fn.input('Path to .env')
        return path ~= '' and require('utils').parse_env_file(path) or nil
      end,
      args = get_args
      -- args = {
      --   "run", "-h", "0.0.0.0", "-p", "8087", "--cert=adhoc", "--debug"
      -- }
    })
  end
}
