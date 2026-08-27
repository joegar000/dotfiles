return {
    'echasnovski/mini.animate',
    config = function()
        require('mini.animate').setup()
    end,
    enabled = false,
    cond = not InNeovide and not InVSCode
}
