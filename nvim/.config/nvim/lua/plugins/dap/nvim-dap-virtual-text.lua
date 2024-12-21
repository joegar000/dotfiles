-- Inline Debug Text
return {
  -- https://github.com/theHamsta/nvim-dap-virtual-text
  'theHamsta/nvim-dap-virtual-text',
  lazy = true,
  opts = {
    virt_text_pos = 'eol',
    clear_on_continue = true
  },
  cond = not InVSCode
}
