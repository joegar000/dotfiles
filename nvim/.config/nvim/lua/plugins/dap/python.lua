local function get_args()
  local args_string = vim.fn.input('Arguments: ')
  return vim.split(args_string, " +")
end

-- Run Python app with `python -m debugpy [--wait-for-client] --listen 0.0.0.0:5678 -m 'regular_run_command'`
return {
  -- https://github.com/mfussenegger/nvim-dap-python
  'mfussenegger/nvim-dap-python',
  ft = 'python',
  dependencies = {
    -- https://github.com/mfussenegger/nvim-dap
    'mfussenegger/nvim-dap',
  },
  config = function ()
    -- Update the path passed to setup to point to your system or virtual env python binary
    -- local path = vim.fn.exepath('python')
    require('dap-python').setup('python')
    local dap = require('dap')

    table.insert(dap.configurations.python, {
      name = "Launch Flask Server",
      type = "python",
      request = "launch",
      console = "integratedTerminal",
      module = "flask",
      justMyCode = false,
      args = get_args
      -- args = {
      --   "run", "-h", "0.0.0.0", "-p", "8087", "--cert=adhoc", "--debug"
      -- }
    })

    table.insert(dap.configurations.python, {
      name = "Launch Flask Server (External Terminal)",
      type = "python",
      request = "launch",
      console = "externalTerminal",
      module = "flask",
      justMyCode = false,
      args = get_args
      -- args = {
      --   "run", "-h", "0.0.0.0", "-p", "8087", "--cert=adhoc", "--debug"
      -- }
    })
  end
}
