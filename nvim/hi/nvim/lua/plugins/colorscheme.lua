return {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    opts = {
        flavor = 'mocha'
    },
    config = function(opts)
        require('catppuccin').setup(opts)
        require('catppuccin').load()
    end
}
-- return {
--     'linrongbin16/colorbox.nvim',
--     dependencies = {
--         { "catppuccin/nvim", name = "catppuccin" }
--     },
--     lazy = false,
--     priority = 3000,
--     filter = false,
--     build = function()
--         require("colorbox").update()
--     end,
--     config = function()
--         require("colorbox").setup({
--             timing = "filetype",
--             fallback = "catppuccin",
--             empty = "catppuccin",
--             policy = {
--                 mapping = {
--                     javascript = "vscode",
--                     typescript = "vscode",
--                     javascriptreact = "vscode",
--                     typescriptreact = "vscode",
--                     html = "vscode",
--                     htmldjango = "vscode",
--                     json = "vscode",
--                     lua = "catppuccin",
--                     markdown = "catppuccin",
--                     python = "everforest",
--                     sql = "kanagawa",
--                     php = "embark",
--                     dashboard = "catppuccin",
--                 }
--             },
--             -- post_hook = function(color, spec)
--             --     print(color)
--             -- end
--         })
--     end,
-- }
