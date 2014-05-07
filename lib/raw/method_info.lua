local prototype=      require 'prototype'
local attribute_info= require 'raw.attribute_info'

local method_info= prototype {
    default=  prototype.assignment_copy,
    table=    prototype.deep_copy,
    userdata= prototype.clone_copy,
}

method_info.attrs= {}

function method_info.parse(constant_pools, file)
    local mi= method_info:clone()

    mi:access_flags(file)
    mi:name_index(file)
    mi:descriptor_index(file)
    mi:attributes(constant_pools, file)

    return mi.attrs
end

function method_info:access_flags(file)
    self.attrs.access_flags= file:read('u2')
end

function method_info:name_index(file)
    self.attrs.name_index= file:read('u2')
end

function method_info:descriptor_index(file)
    self.attrs.descriptor_index= file:read('u2')
end

function method_info:attributes(constant_pools, file)
    local count= file:read('u2')

    self.attrs.attributes= {}

    while #(self.attrs.attributes) < count do
        table.insert(self.attrs.attributes, attribute_info.parse(constant_pools, file))
    end
end

return method_info
