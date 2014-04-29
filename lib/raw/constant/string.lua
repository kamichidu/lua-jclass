local cp_info= require 'raw.cp_info'

local string= cp_info:clone()

string.kind= 'String'

function string.new(tag, reader)
    assert(tag == 8, 'illegal argument')

    local info= string:clone()

    info.tag= tag
    info.string_index= reader:read_int16()

    return info
end

return string
