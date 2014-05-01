local attribute_info= require 'raw.attribute_info'

local enclosing_method= attribute_info:clone()

enclosing_method.kind= 'EnclosingMethod'

function enclosing_method.new(constant_pools, reader)
    local info= enclosing_method:clone()

    info.attribute_length= reader:read_int32()
    info.class_index=      reader:read_int16()
    info.method_index=     reader:read_int16()

    return info
end

return enclosing_method
