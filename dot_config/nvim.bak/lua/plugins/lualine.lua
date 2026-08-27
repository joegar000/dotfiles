return {
    'nvim-lualine/lualine.nvim',
    event = "VeryLazy",
    main = 'lualine',
    dependencies = {
        'nvim-tree/nvim-web-devicons',
        'mfussenegger/nvim-lint'
    },
    config = function ()
        local lint_progress = function()
            local linters = require("lint").get_running()
            if #linters == 0 then
                return "󰦕"
            end
            return "󱉶 " .. table.concat(linters, ", ")
        end
        require('lualine').setup({
            options = {
                -- component_separators = { left = '┃', right = '┃'},
                component_separators = '',
                -- section_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
            },
            refresh = {
                statusline = 1000
            },
            sections = {
                lualine_x = {lint_progress, 'encoding', 'fileformat', 'filetype'}
            }
        })
        vim.o.laststatus = 3
    end,
    cond = not InVSCode
}
