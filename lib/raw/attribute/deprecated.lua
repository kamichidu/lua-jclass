local attribute_info= require 'raw.attribute_info'

local deprecated= attribute_info:clone()

deprecated.kind= 'Deprecated'

function deprecated.new(constant_pools, file)
    local info= deprecated:clone()

    info.attribute_length= file:read('u4')

    assert(info.attribute_length == 0)

    return info
end

return deprecated
