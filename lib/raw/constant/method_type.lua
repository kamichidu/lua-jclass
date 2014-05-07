local cp_info= require 'raw.cp_info'

local method_type= cp_info:clone()

method_type.kind= 'MethodType'

function method_type.new(tag, file)
    assert(tag == 16, 'illegal argument')

    local info= method_type:clone()

    info.tag=              tag
    info.descriptor_index= file:read('u2')

    return info
end

return method_type
