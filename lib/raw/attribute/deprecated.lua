local attribute_info= require 'raw.attribute_info'

local deprecated= attribute_info:clone()

deprecated.kind= 'Deprecated'

function deprecated.new(constant_pools, reader)
    local info= deprecated:clone()

    info.attribute_length= reader:read_int32()

    assert(info.attribute_length == 0)

    return info
end

return deprecated
