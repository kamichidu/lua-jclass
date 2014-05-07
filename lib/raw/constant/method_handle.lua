local cp_info= require 'raw.cp_info'

local method_handle= cp_info:clone()

method_handle.kind= 'MethodHandle'

function method_handle.new(tag, file)
    assert(tag == 15, 'illegal argument')

    local info= method_handle:clone()

    info.tag=             tag
    info.reference_kind=  file:read('u1')
    info.reference_index= file:read('u2')

    return info
end

return method_handle
