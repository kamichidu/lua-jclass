local cp_info= require 'raw.cp_info'

local long= cp_info:clone()

long.kind= 'Long'

function long.new(tag, reader)
    assert(tag == 5, 'illegal argument')

    local info= long:clone()

    info.tag= tag
    info.high_bytes= reader:read_int32()
    info.low_bytes= reader:read_int32()

    return info
end

return long
