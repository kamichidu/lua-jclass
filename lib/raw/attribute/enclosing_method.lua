local attribute_info= require 'raw.attribute_info'

local enclosing_method= attribute_info:clone()

enclosing_method.kind= 'EnclosingMethod'

function enclosing_method.new(constant_pools, file)
    local info= enclosing_method:clone()

    info.attribute_length= file:read('u4')
    info.class_index=      file:read('u2')
    info.method_index=     file:read('u2')

    return info
end

return enclosing_method
