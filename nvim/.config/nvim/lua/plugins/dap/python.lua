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

  end
}
