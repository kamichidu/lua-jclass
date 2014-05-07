local attribute_info= require 'raw.attribute_info'

local constant_value= attribute_info:clone()

constant_value.kind= 'ConstantValue'

function constant_value.new(constant_pools, file)
    local info= constant_value:clone()

    info.attribute_length=    file:read('u4')
    info.constantvalue_index= file:read('u2')

    assert(info.attribute_length == 2)

    return info
end

return constant_value
