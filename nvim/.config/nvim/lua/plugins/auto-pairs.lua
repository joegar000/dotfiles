return {
  "jiangmiao/auto-pairs",
  lazy = false,
  keys = {
    {
      '<leader>ap',
      function()
        local notify = require('notify').notify
        if vim.b.autopairs_enabled == 1 then
          notify('Disabled auto pairs', vim.log.levels.WARN, { title = 'auto-pairs' })
          vim.b.autopairs_enabled = 0
        else
          notify('Enabled auto pairs', vim.log.levels.INFO, { title = 'auto-pairs' })
          vim.b.autopairs_enabled = 1
        end
      end,
      desc = 'Toggle auto pairs'
    }
  },
  config = function()
    vim.g.AutoPairsShortcutToggle = ''
    vim.g.AutoPairsShortcutFastWrap = ''
    vim.g.AutoPairsShortcutJump = ''
    vim.g.AutoPairsShortcutBackInsert = ''
  end
}
