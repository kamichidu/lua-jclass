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

function class_file.parse(file)
    assert(file, 'cannot parse from nil')

    local cf= class_file:clone()

    cf:magic(file)
    cf:minor_version(file)
    cf:major_version(file)
    cf:constant_pools(file)
    cf:access_flags(file)
    cf:this_class(file)
    cf:super_class(file)
    cf:interfaces(file)
    cf:fields(file)
    cf:methods(file)
    cf:attributes(file)

    return cf.attrs
end

function class_file:magic(file)
    local magic= file:read('u4')

    assert(magic == 0xcafebabe, 'it is NOT java class file')

    self.attrs.magic= magic
end

function class_file:minor_version(file)
    self.attrs.minor_version= file:read('u2')
end

function class_file:major_version(file)
    self.attrs.major_version= file:read('u2')
end

function class_file:constant_pools(file)
    local count= file:read('u2')

    self.attrs.constant_pools= {}

    while #(self.attrs.constant_pools) < count - 1 do
        local info= cp_info.parse(file)

        table.insert(self.attrs.constant_pools, info)

        if info.kind == 'Long' or info.kind == 'Double' then
            table.insert(self.attrs.constant_pools, {})
        end
    end
end

function class_file:access_flags(file)
    self.attrs.access_flags= file:read('u2')
end

function class_file:this_class(file)
    self.attrs.this_class= file:read('u2')
end

function class_file:super_class(file)
    self.attrs.super_class= file:read('u2')
end

function class_file:interfaces(file)
    local count= file:read('u2')

    self.attrs.interfaces= {}

    while #(self.attrs.interfaces) < count do
        table.insert(self.attrs.interfaces, file:read('u2'))
    end
end

function class_file:fields(file)
    local count= file:read('u2')

    self.attrs.fields= {}

    while #(self.attrs.fields) < count do
        table.insert(self.attrs.fields, field_info.parse(self.attrs.constant_pools, file))
    end
end

function class_file:methods(file)
    local count= file:read('u2')

    self.attrs.methods= {}

    while #(self.attrs.methods) < count do
        table.insert(self.attrs.methods, method_info.parse(self.attrs.constant_pools, file))
    end
end

function class_file:attributes(file)
    local count= file:read('u2')

    self.attrs.attributes= {}

    while #(self.attrs.attributes) < count do
        table.insert(self.attrs.attributes, attribute_info.parse(self.attrs.constant_pools, file))
    end
end

return class_file
