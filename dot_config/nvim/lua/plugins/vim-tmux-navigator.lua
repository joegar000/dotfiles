return {
  'aimdevlee/herdr-nvim-nav',
  dependencies = { 'christoomey/vim-tmux-navigator' },
  event = 'VeryLazy',
  config = function()
    -- LazyVim installs its default Ctrl+hjkl maps during VeryLazy. Defer one
    -- event-loop turn so herdr-nvim-nav owns the final mappings.
    vim.schedule(function()
      require('herdr-nvim-nav').setup()
    end)
  end
}
