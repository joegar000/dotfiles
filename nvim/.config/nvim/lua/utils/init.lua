local function get_args()
  local args_string = vim.fn.input('Arguments: ')
  return vim.split(args_string, " +")
end

-- Function to parse a .env file into a table of key-value pairs
local function parse_env_file(filePath)
    local envTable = {}
    local file = io.open(filePath, "r") -- Open the file in read mode

    if not file then
        error("Could not open file: " .. filePath)
    end

    for line in file:lines() do
        -- Skip empty lines and lines starting with '#'
        if line:match("^%s*#") or line:match("^%s*$") then
            goto continue
        end

        -- Match key=value pairs
        local key, value = line:match("^%s*([%w_]+)%s*=%s*(.+)%s*$")
        if key and value then
            -- Remove surrounding quotes from value, if any
            value = value:match('^"(.*)"$') or value:match("^'(.*)'$") or value
            envTable[key] = value
        end

        ::continue::
    end

    file:close() -- Close the file
    return envTable
end


return {
  get_args = get_args,
  parse_env_file = parse_env_file
}

