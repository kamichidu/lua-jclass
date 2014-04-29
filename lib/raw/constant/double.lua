local cp_info= require 'raw.cp_info'

local double= cp_info:clone()

double.kind= 'Double'

function double.new(tag, reader)
    assert(tag == 6, 'illegal argument')

    local info= double:clone()

    info.tag= tag
    info.high_bytes= reader:read_int32()
    info.low_bytes= reader:read_int32()

    return info
end

return double
