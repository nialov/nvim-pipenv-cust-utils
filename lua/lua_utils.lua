local treesit = require 'nvim-treesitter'

local M = {}

M.separator = "\n"

function M.mytransform(line)
    -- M.logfile:write("hello")
    -- local lines = {}
    -- for s in line:gmatch("[^\r\n]+") do table.insert(lines, s) end
    -- -- while line:match(">>>") ~= nil do line = line:gsub('.*>>> ', '') end

    local matched = line:gsub('%s*[%[%(%{]*%s*$', ''):gsub('def ', ''):gsub(
                        'class ', ''):match('([%a_%d]+)'):gsub(' ', '')
    -- -- line = line:gsub('def ', '')
    -- -- line = line:gsub('class ', '')
    -- -- final = line:match('([%a_%d]+)')
    -- -- return matched

    -- -- return matched
    return matched
end

function M.get_curr_parent()
    local opts = {
        indicator_size = 100,
        type_patterns = {'class', 'function', 'method'},
        transform_fn = M.mytransform,
        separator = M.separator
    }
    local curr = treesit.statusline(opts)
    local lines = {}
    for s in curr:gmatch("[^\r\n]+") do table.insert(lines, s) end
    return lines[#lines]
end

return M
