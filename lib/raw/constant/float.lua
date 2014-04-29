local cp_info= require 'raw.cp_info'

local float= cp_info:clone()

float.kind= 'Float'

function float.new(tag, reader)
    assert(tag == 4, 'illegal argument')

    local info= float:clone()

    info.tag= tag
    info.bytes= reader:read_int32()

    return info
end

return float
