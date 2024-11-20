return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    win = {
      border = "rounded"
    }
  },
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 300
  end,
  config = function(_, opts)
    local wk = require('which-key')
    wk.setup(opts)
    wk.add({
      "<C-W>f",
      function()
        local buf = vim.api.nvim_get_current_buf() -- Get the current buffer
        local width = math.floor(vim.o.columns * 0.9) -- 90% of the screen width
        local height = math.floor(vim.o.lines * 0.9)  -- 90% of the screen height
        local row = math.floor((vim.o.lines - height) / 2) -- Center vertically
        local col = math.floor((vim.o.columns - width) / 2) -- Center horizontally

        -- Create a floating window
        local win_id = vim.api.nvim_open_win(buf, true, {
          relative = 'editor',
          width = width,
          height = height,
          row = row,
          col = col,
          border = 'rounded'
        })
        vim.api.nvim_create_autocmd({ 'BufLeave', 'WinLeave' }, {
          buffer = buf,
          callback = function()
            if vim.api.nvim_win_is_valid(win_id) then
              vim.api.nvim_win_close(win_id, true)
              pcall(vim.api.nvim_buf_del_keymap, buf, 'n', 'q') -- Safely remove the 'q' keymap
            end
          end
        })
        vim.api.nvim_buf_set_keymap(buf, 'n', 'q', '<cmd>close<CR>', { noremap = true, silent = true })
      end,
      desc = "Open current buffer as float"
    })
    wk.register(opts.defaults)
  end,
}
