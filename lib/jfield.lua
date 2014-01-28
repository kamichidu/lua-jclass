require 'accessible_object'
require 'parser'
require 'youjo'

jfield= {}

function jfield.new(constant_pools, field_info)
    local descriptor_info= constant_pools[field_info._descriptor_index]
    local descriptor= parser.parse_field_descriptor(youjo.decode_utf8(descriptor_info._bytes))

    local obj= setmetatable({}, {__index= accessible_object.new(field_info._access_flags)})

    function obj.name()
        local name_info= constant_pools[field_info._name_index]
        local s, c= youjo.decode_utf8(name_info._bytes)

        return s
    end

    function obj.type()
        return descriptor.type
    end

    return obj
end
