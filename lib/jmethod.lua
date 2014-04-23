require 'raw.accessible_object'
require 'util.parser'
require 'util.youjo'

jmethod= {}

function jmethod.new(constant_pools, method_info)
    -- descriptor_info must be utf8_info
    local descriptor_info= constant_pools[method_info._descriptor_index]
    local descriptor= parser.parse_method_descriptor(youjo.decode_utf8(descriptor_info._bytes))

    local obj= setmetatable({}, {__index= accessible_object.new(method_info._access_flags)})

    function obj.name()
        local name_info= constant_pools[method_info._name_index]
        local s, c= youjo.decode_utf8(name_info._bytes)

        return s
    end

    function obj.return_type()
        return descriptor.return_type
    end

    function obj.parameter_types()
        return descriptor.parameter_types
    end

    return obj
end
