local cp_info= require 'raw.cp_info'

local double= cp_info:clone()

double.kind= 'Double'

function double.new(tag, file)
    assert(tag == 6, 'illegal argument')

    local info= double:clone()

    info.tag=        tag
    info.high_bytes= file:read('u4')
    info.low_bytes=  file:read('u4')

    return info
end

return double
