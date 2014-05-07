local prototype= require 'prototype'
local attribute_info= require 'raw.attribute_info'

local field_info= prototype {
    default=  prototype.assignment_copy,
    table=    prototype.deep_copy,
    userdata= prototype.clone_copy,
}

field_info.attrs= {}

function field_info.parse(constant_pools, file)
    local fi= field_info:clone()

    fi:access_flags(file)
    fi:name_index(file)
    fi:descriptor_index(file)
    fi:attributes(constant_pools, file)

    return fi.attrs
end

function field_info:access_flags(file)
    self.attrs.access_flags= file:read('u2')
end

function field_info:name_index(file)
    self.attrs.name_index= file:read('u2')
end

function field_info:descriptor_index(file)
    self.attrs.descriptor_index= file:read('u2')
end

function field_info:attributes(constant_pools, file)
    local count= file:read('u2')

    self.attrs.attributes= {}

    while #(self.attrs.attributes) < count do
        table.insert(self.attrs.attributes, attribute_info.parse(constant_pools, file))
    end
end

return field_info
