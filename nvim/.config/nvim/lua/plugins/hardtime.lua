return {
   enabled = false,
   "m4xshen/hardtime.nvim",
   dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
   opts = {
      disabled_filetypes = { "dashboard", "NvimTree", "lazy", "mason", "netrw", "noice", 'TelescopePrompt', 'qf', 'trouble', 'help', 'DressingInput' }
   },
   cond = not InVSCode
}
