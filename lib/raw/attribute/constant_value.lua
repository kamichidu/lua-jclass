local attribute_info= require 'raw.attribute_info'

local constant_value= attribute_info:clone()

constant_value.kind= 'ConstantValue'

function constant_value.new(constant_pools, reader)
    local info= constant_value:clone()

    info.attribute_length= reader:read_int32()
    info.constantvalue_index= reader:read_int16()

    assert(info.attribute_length == 2)

    return info
end

return constant_value
