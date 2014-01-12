require 'youjo'
require 'constant_pool_info'
require 'method_info'
require 'field_info'
require 'attribute_info'

class_file= {}

function class_file.new(reader)
    local magic=         reader.int32()
    local minor_version= reader.int16()
    local major_version= reader.int16()
    local constant_pool_count= reader.int16()
    local constant_pools= {}

    youjo.say('read constant_pool_count is ' .. constant_pool_count)
    while #(constant_pools) < constant_pool_count - 1 do
        local size= #(constant_pools)

        youjo.say('before cp_info.new()')
        constant_pools[size + 1]= constant_pool_info.new(reader)
        youjo.say('after read now #constant_pools is ' .. #constant_pools)
    end

    local access_flags= reader.int16()

    local this_class= reader.int16()
    local super_class= reader.int16()

    local interfaces_count= reader.int16()
    local interfaces= {}
    while #(interfaces) < interfaces_count do
        local size= #(interfaces)

        interfaces[size + 1]= reader.int16()
    end

    local fields_count= reader.int16()
    local fields= {}
    while #(fields) < fields_count do
        local size= #(fields)

        fields[size + 1]= field_info.new(reader)
    end

    -- local methods_count= reader.int16()
    -- local methods= {}
    -- while #(methods) < methods_count do
    --     local size= #(methods)

    --     methods[size + 1]= method_info.new(reader)
    -- end

    -- local attributes_count= reader.int16()
    -- local attributes= {}
    -- while #(attributes) < attributes_count do
    --     local size= #(attributes)

    --     attributes[size + 1]= attribute_info.new(reader)
    -- end

    return {
        _magic=               magic,
        _minor_version=       minor_version,
        _major_version=       major_version,
        _constant_pool_count= constant_pool_count,
        _constant_pools=      constant_pools,
        _access_flags=        access_flags,
        _this_class=          this_class,
        _super_class=         super_class,
        _interfaces_count=    interfaces_count,
        _interfaces=          interfaces,
        _fields_count=        fields_count,
        _fields=              fields,
        _methods_count=       methods_count,
        _methods=             methods,
        _attributes_count=    attributes_count,
        _attributes=          attributes,
    }
end
