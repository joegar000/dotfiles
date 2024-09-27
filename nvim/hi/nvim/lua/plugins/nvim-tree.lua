local WIDTH_RATIO = 0.8
local HEIGHT_RATIO = 0.8
return {
    'nvim-tree/nvim-tree.lua',
    keys = { { '<leader>e', '<cmd>NvimTreeFindFileToggle<CR>', desc = 'Open file explorer' } },
    lazy = false,
    config = function()
        local _setup, nvimtree = pcall(require, "nvim-tree")

        nvimtree.setup({
            disable_netrw = true,
            hijack_netrw = true,
            respect_buf_cwd = true,
            sync_root_with_cwd = true,
            view = {
                relativenumber = true,
                float = {
                    enable = true,
                    quit_on_focus_loss = true,
                    open_win_config = {
                        border = "rounded",
                        relative = "cursor",
                        row = 0,
                        col = 0,
                        width = 40,
                        height = 30,
                    }
                },
                -- float = {
                --     enable = true,
                --     open_win_config = function()
                --         local screen_w = vim.opt.columns:get()
                --         local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
                --         local window_w = screen_w * WIDTH_RATIO
                --         local window_h = screen_h * HEIGHT_RATIO
                --         local window_w_int = math.floor(window_w)
                --         local window_h_int = math.floor(window_h)
                --         local center_x = (screen_w - window_w) / 2
                --         local center_y = ((vim.opt.lines:get() - window_h) / 2) - vim.opt.cmdheight:get()
                --
                --         return {
                --             border = "rounded",
                --             relative = "editor",
                --             row = center_y,
                --             col = center_x,
                --             width = window_w_int,
                --             height = window_h_int,
                --         }
                --     end,
                -- },
                width = function()
                    return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
                end,
            },
            git = {
                enable = true,
                show_on_dirs = true,
                show_on_open_dirs = true,
                disable_for_dirs = {},
                timeout = 2000,
                cygwin_support = false,
            },
            actions = {
                open_file = {
                    quit_on_open = true,
                    resize_window = true,
                    window_picker = {
                        enable = true
                    },
                },
            }
        })

        -- Immediately open file after creation
        local api = require('nvim-tree.api')
        api.events.subscribe(api.events.Event.FileCreated, function(file)
            vim.cmd('edit ' .. file.fname)
        end)
    end
}
