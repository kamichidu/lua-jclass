local attribute_info= require 'raw.attribute_info'

local signature= attribute_info:clone()

signature.kind= 'Signature'

function signature.new(constant_pools, file)
    local info= signature:clone()

    info.attribute_length= file:read('u4')
    info.signature_index=  file:read('u2')

    assert(info.attribute_length == 2, 'Signature_attribute.attribute_length must be 2')

    return info
end

return signature
