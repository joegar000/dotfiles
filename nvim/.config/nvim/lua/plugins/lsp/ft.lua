local function file_has_extension(extension)
  local file_name = vim.fn.expand("%:t")  -- Get the current file name (without path)
  return file_name:sub(-#extension) == extension
end

local correct_ft = function ()
    if file_has_extension('tpl') then
        vim.bo.filetype = 'tpl'
    end
end

return {
    {
        name = 'Ensure Correct FT',
        dir = '.',
        init = function ()
            vim.api.nvim_create_autocmd({ 'BufNewFile', 'BufRead', 'BufReadPost' }, {
                callback = correct_ft
            })
            correct_ft()
        end
    },
    {
        'armyers/vim-jinja2-syntax', -- the plugin is running and taking over when smarty.vim should
        ft = { 'html', 'jinja', 'jinaj2', 'jinja.html', 'htmldjango', 'django' },
    },
    {
        'blueyed/smarty.vim',
        ft = { 'tpl' }
    }
}
