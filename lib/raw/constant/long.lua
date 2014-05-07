local cp_info= require 'raw.cp_info'

local long= cp_info:clone()

long.kind= 'Long'

function long.new(tag, file)
    assert(tag == 5, 'illegal argument')

    local info= long:clone()

    info.tag=        tag
    info.high_bytes= file:read('u4')
    info.low_bytes=  file:read('u4')

    return info
end

return long
