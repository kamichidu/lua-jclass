local prototype= require 'prototype'

local attribute_info= prototype {
    default= prototype.assignment_copy,
    table=   prototype.deep_copy,
}

attribute_info.attrs= {}

function attribute_info.parse(reader)
    local ai= attribute_info:clone()

    ai:attribute_name_index(reader)
    ai:info(reader)

    return ai.attrs
end

function attribute_info:attribute_name_index(reader)
    self.attrs.attribute_name_index= reader:read_int16()
end

function attribute_info:info(reader)
    local length= reader:read_int32()

    self.attrs.info= reader:read(length)
end

return attribute_info
