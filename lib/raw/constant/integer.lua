local cp_info= require 'raw.cp_info'

local integer= cp_info:clone()

integer.kind= 'Integer'

function integer.new(tag, file)
    assert(tag == 3, 'illegal argument')

    local info= integer:clone()

    info.tag=   tag
    info.bytes= file:read('u4')

    return info
end

return integer
