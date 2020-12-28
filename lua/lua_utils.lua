local treesit = require 'nvim-treesitter'

local M = {}

function M.mytransform(line)
    if line:match('->') then line = line:gsub('.*>>>', '') end
    local matched = line:gsub('%s*[%[%(%{]*%s*$', ''):gsub('def ', ''):gsub(
                        'class ', ''):match('([%a_%d]+)'):gsub(' ', '')
    -- line = line:gsub('def ', '')
    -- line = line:gsub('class ', '')
    -- final = line:match('([%a_%d]+)')
    return matched
end

function M.get_curr_parent()
    local opts = {
        indicator_size = 100,
        type_patterns = {'class', 'function', 'method'},
        transform_fn = M.mytransform,
        separator = ' >>> '
    }
    local curr = treesit.statusline(opts)
    return curr
end

return M
