local prototype=      require 'prototype'
local cp_info=        require 'raw.cp_info'
local field_info=     require 'raw.field_info'
local method_info=    require 'raw.method_info'
local attribute_info= require 'raw.attribute_info'

local class_file= prototype {
    default=  prototype.assignment_copy,
    table=    prototype.deep_copy,
    userdata= prototype.clone_copy,
}

class_file.visitor= nil
class_file.attrs= {}

function class_file.parse(reader)
    assert(reader, 'cannot parse from nil')

    local cf= class_file:clone()

    cf:magic(reader)
    cf:minor_version(reader)
    cf:major_version(reader)
    cf:constant_pools(reader)
    cf:access_flags(reader)
    cf:this_class(reader)
    cf:super_class(reader)
    cf:interfaces(reader)
    cf:fields(reader)
    cf:methods(reader)
    cf:attributes(reader)

    return cf.attrs
end

function class_file:magic(reader)
    local magic= reader:read_int32()

    assert(magic == 0xcafebabe, 'it is NOT java class file')

    self.attrs.magic= magic
end

function class_file:minor_version(reader)
    self.attrs.minor_version= reader:read_int16()
end

function class_file:major_version(reader)
    self.attrs.major_version= reader:read_int16()
end

function class_file:constant_pools(reader)
    local count= reader:read_int16()

    self.attrs.constant_pools= {}

    while #(self.attrs.constant_pools) < count - 1 do
        local info= cp_info.parse(reader)

        table.insert(self.attrs.constant_pools, info)

        if info.kind == 'Long' or info.kind == 'Double' then
            table.insert(self.attrs.constant_pools, {})
        end
    end
end

function class_file:access_flags(reader)
    self.attrs.access_flags= reader:read_int16()
end

function class_file:this_class(reader)
    self.attrs.this_class= reader:read_int16()
end

function class_file:super_class(reader)
    self.attrs.super_class= reader:read_int16()
end

function class_file:interfaces(reader)
    local count= reader:read_int16()

    self.attrs.interfaces= {}

    while #(self.attrs.interfaces) < count do
        table.insert(self.attrs.interfaces, reader:read_int16())
    end
end

function class_file:fields(reader)
    local count= reader:read_int16()

    self.attrs.fields= {}

    while #(self.attrs.fields) < count do
        table.insert(self.attrs.fields, field_info.parse(self.attrs.constant_pools, reader))
    end
end

function class_file:methods(reader)
    local count= reader:read_int16()

    self.attrs.methods= {}

    while #(self.attrs.methods) < count do
        table.insert(self.attrs.methods, method_info.parse(self.attrs.constant_pools, reader))
    end
end

function class_file:attributes(reader)
    local count= reader:read_int16()

    self.attrs.attributes= {}

    while #(self.attrs.attributes) < count do
        table.insert(self.attrs.attributes, attribute_info.parse(self.attrs.constant_pools, reader))
    end
end

return class_file
