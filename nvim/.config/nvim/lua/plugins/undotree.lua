return {
    'mbbill/undotree',
    keys = { { '<leader>ut', vim.cmd.UndotreeToggle, desc = 'Toggle Undotree' } },
    config = function ()
        vim.opt.swapfile = false
        vim.opt.backup = false
        vim.opt.undodir = (os.getenv('HOME') or (os.getenv('HOMEDRIVE')) .. os.getenv('HOMEPATH')) .. "/.vim/undodir"
        vim.opt.undofile = true
    end
}
