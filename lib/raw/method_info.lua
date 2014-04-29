local prototype=      require 'prototype'
local attribute_info= require 'raw.attribute_info'

local method_info= prototype {
    default=  prototype.assignment_copy,
    table=    prototype.deep_copy,
    userdata= prototype.clone_copy,
}

method_info.attrs= {}

function method_info.parse(reader)
    local mi= method_info:clone()

    mi:access_flags(reader)
    mi:name_index(reader)
    mi:descriptor_index(reader)
    mi:attributes(reader)

    return mi.attrs
end

function method_info:access_flags(reader)
    self.attrs.access_flags= reader:read_int16()
end

function method_info:name_index(reader)
    self.attrs.name_index= reader:read_int16()
end

function method_info:descriptor_index(reader)
    self.attrs.descriptor_index= reader:read_int16()
end

function method_info:attributes(reader)
    local count= reader:read_int16()

    self.attrs.attributes= {}

    while #(self.attrs.attributes) < count do
        table.insert(self.attrs.attributes, attribute_info.parse(reader))
    end
end

return method_info
