local treesit = require 'nvim-treesitter'

lua_utils = {}

    function lua_utils.mytransform(line)
        if line:match('->') then
            line = line:gsub('.*>>>', '')
        end 
        matched = line:gsub('%s*[%[%(%{]*%s*$', '')
                    :gsub('def ', '')
                    :gsub('class ', '')
                    :match('([%a_%d]+)')
                    :gsub(' ', '')
        -- line = line:gsub('def ', '')
        -- line = line:gsub('class ', '')
        -- final = line:match('([%a_%d]+)')
        return matched
    end

    function lua_utils.get_curr_parent()
        opts = {
            indicator_size = 100,
            type_patterns = {'class', 'function', 'method'},
            transform_fn = mytransform,
            separator = ' >>> '
          }
        curr = treesit.statusline(opts)
        return curr
    end

return lua_utils
