local prototype= require 'prototype'
local attribute_info= require 'raw.attribute_info'

local field_info= prototype {
    default=  prototype.assignment_copy,
    table=    prototype.deep_copy,
    userdata= prototype.clone_copy,
}

field_info.attrs= {}

function field_info.parse(reader)
    local fi= field_info:clone()

    fi:access_flags(reader)
    fi:name_index(reader)
    fi:descriptor_index(reader)
    fi:attributes(reader)

    return fi.attrs
end

function field_info:access_flags(reader)
    self.attrs.access_flags= reader:read_int16()
end

function field_info:name_index(reader)
    self.attrs.name_index= reader:read_int16()
end

function field_info:descriptor_index(reader)
    self.attrs.descriptor_index= reader:read_int16()
end

function field_info:attributes(reader)
    local count= reader:read_int16()

    self.attrs.attributes= {}

    while #(self.attrs.attributes) < count do
        table.insert(self.attrs.attributes, attribute_info.parse(reader))
    end
end

return field_info
