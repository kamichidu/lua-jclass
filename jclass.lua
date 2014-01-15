require 'class_file'
require 'parser'
require 'bitwise'

jclass= {}

local decode_utf8= function(bytes)
    local utf8= ''

    for i, byte in ipairs(bytes) do
        utf8= utf8 .. string.char(byte)
    end

    return utf8
end

function jclass.new(reader)
    local obj= {
        _raw= class_file.new(reader),
    }

    function obj.version()
        return tonumber(obj._raw._major_version .. '.' .. obj._raw._minor_version)
    end

    function obj.is_public()
        return bit32.band(obj._raw._access_flags, class_file.access_flag.public) == class_file.access_flag.public
    end

    function obj.is_final()
        return bit32.band(obj._raw._access_flags, class_file.access_flag.final) == class_file.access_flag.final
    end

    function obj.is_super()
        return bit32.band(obj._raw._access_flags, class_file.access_flag.super) == class_file.access_flag.super
    end

    function obj.is_interface()
        return bit32.band(obj._raw._access_flags, class_file.access_flag.interface) == class_file.access_flag.interface
    end

    function obj.is_abstract()
        return bit32.band(obj._raw._access_flags, class_file.access_flag.abstract) == class_file.access_flag.abstract
    end

    function obj.is_synthetic()
        return bit32.band(obj._raw._access_flags, class_file.access_flag.synthetic) == class_file.access_flag.synthetic
    end

    function obj.is_annotation()
        return bit32.band(obj._raw._access_flags, class_file.access_flag.annotation) == class_file.access_flag.annotation
    end

    function obj.is_enum()
        return bit32.band(obj._raw._access_flags, class_file.access_flag.enum) == class_file.access_flag.enum
    end

    function obj.classname()
        local class_info= obj._raw._constant_pools[obj._raw._this_class]
        local name_info= obj._raw._constant_pools[class_info._name_index]

        local s, c= decode_utf8(name_info._bytes):gsub('/', '.')

        return s
    end

    function obj.super_classname()
        local class_info= obj._raw._constant_pools[obj._raw._super_class]
        local name_info= obj._raw._constant_pools[class_info._name_index]

        local s, c= decode_utf8(name_info._bytes):gsub('/', '.')

        return s
    end

    function obj.fields()
        local fields= {}

        for i, field in ipairs(obj._raw._fields) do
            -- descriptor_info must be utf8_info
            local descriptor_info= obj._raw._constant_pools[field._descriptor_index]
            local descriptor= parser.parse_field_descriptor(decode_utf8(descriptor_info._bytes))

            fields[#fields + 1]= {
                _raw= field,
                name= function()
                    local name_info= obj._raw._constant_pools[field._name_index]
                    local s, c= decode_utf8(name_info._bytes)

                    return s
                end,
                is_public= function()
                    return bit32.band(field._access_flags, field_info.access_flag.public) == field_info.access_flag.public
                end,
                is_protected= function()
                    return bit32.band(field._access_flags, field_info.access_flag.protected) == field_info.access_flag.protected
                end,
                is_private= function()
                    return bit32.band(field._access_flags, field_info.access_flag.private) == field_info.access_flag.private
                end,
                is_static= function()
                    return bit32.band(field._access_flags, field_info.access_flag.static) == field_info.access_flag.static
                end,
                is_final= function()
                    return bit32.band(field._access_flags, field_info.access_flag.final) == field_info.access_flag.final
                end,
                is_volatile= function()
                    return bit32.band(field._access_flags, field_info.access_flag.volatile) == field_info.access_flag.volatile
                end,
                is_transient= function()
                    return bit32.band(field._access_flags, field_info.access_flag.transient) == field_info.access_flag.transient
                end,
                is_synthetic= function()
                    return bit32.band(field._access_flags, field_info.access_flag.synthetic) == field_info.access_flag.synthetic
                end,
                is_enum= function()
                    return bit32.band(field._access_flags, field_info.access_flag.enum) == field_info.access_flag.enum
                end,
                type= function()
                    return descriptor.type
                end,
            }
        end

        return fields
    end

    function obj.methods()
        local methods= {}

        for i, method in ipairs(obj._raw._methods) do
            -- descriptor_info must be utf8_info
            local descriptor_info= obj._raw._constant_pools[method._descriptor_index]
            local descriptor= parser.parse_method_descriptor(decode_utf8(descriptor_info._bytes))

            methods[#methods + 1]= {
                _raw= method,
                name= function()
                    local name_info= obj._raw._constant_pools[method._name_index]
                    local s, c= decode_utf8(name_info._bytes)

                    return s
                end,
                is_public= function()
                    return bit32.band(method._access_flags, method_info.access_flag.public) == method_info.access_flag.public
                end,
                is_protected= function()
                    return bit32.band(method._access_flags, method_info.access_flag.protected) == method_info.access_flag.protected
                end,
                is_private= function()
                    return bit32.band(method._access_flags, method_info.access_flag.private) == method_info.access_flag.private
                end,
                is_static= function()
                    return bit32.band(method._access_flags, method_info.access_flag.static) == method_info.access_flag.static
                end,
                is_final= function()
                    return bit32.band(method._access_flags, method_info.access_flag.final) == method_info.access_flag.final
                end,
                is_volatile= function()
                    return bit32.band(method._access_flags, method_info.access_flag.volatile) == method_info.access_flag.volatile
                end,
                is_transient= function()
                    return bit32.band(method._access_flags, method_info.access_flag.transient) == method_info.access_flag.transient
                end,
                is_synthetic= function()
                    return bit32.band(method._access_flags, method_info.access_flag.synthetic) == method_info.access_flag.synthetic
                end,
                is_enum= function()
                    return bit32.band(method._access_flags, method_info.access_flag.enum) == method_info.access_flag.enum
                end,
                return_type= function()
                    return descriptor.return_type
                end,
                parameter_types= function()
                    return descriptor.parameter_types
                end,
            }
        end

        return methods
    end

    return obj
end
