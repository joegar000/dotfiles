local function get_args()
  local args_string = vim.fn.input('Arguments: ')
  return vim.split(args_string, " +")
end

return {
  get_args = get_args
}

