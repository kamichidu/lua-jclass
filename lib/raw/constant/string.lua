local cp_info= require 'raw.cp_info'

local string= cp_info:clone()

string.kind= 'String'

function string.new(tag, file)
    assert(tag == 8, 'illegal argument')

    local info= string:clone()

    info.tag=          tag
    info.string_index= file:read('u2')

    return info
end

return string
