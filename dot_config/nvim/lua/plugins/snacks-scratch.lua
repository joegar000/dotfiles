return {
  "folke/snacks.nvim",
  keys = {
    { "<leader>.",  function() Snacks.scratch({ ft = vim.fn.input('Scratch Filetype') or vim.bo.filetype }) end, desc = "Toggle Scratch Buffer" },
    { "<leader>S",  function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },
  }
}
