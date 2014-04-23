require 'raw.attribute_info'
require 'raw.constant_pool_info'
require 'raw.field_info'
require 'raw.method_info'
require 'util.youjo'

class_file= {
    access_flag= {
        public=     0x0001, -- Declared public; may be accessed from outside its package.
        final=      0x0010, -- Declared final; no subclasses allowed.
        super=      0x0020, -- Treat superclass methods specially when invoked by the invokespecial instruction.
        interface=  0x0200, -- Is an interface, not a class.
        abstract=   0x0400, -- Declared abstract; must not be instantiated.
        synthetic=  0x1000, -- Declared synthetic; not present in the source code.
        annotation= 0x2000, -- Declared as an annotation type.
        enum=       0x4000, -- Declared as an enum type. 
    },
}

function class_file.new(reader)
    -- read datas
    local magic=         reader.int32()

    if not magic == 0xcafebabe then
        error("it's not java class file.")
    end

    local minor_version= reader.int16()
    local major_version= reader.int16()
    local constant_pool_count= reader.int16()
    local constant_pools= {}

    while #(constant_pools) < constant_pool_count - 1 do
        local size= #(constant_pools)
        local info= constant_pool_info.new(reader)

        constant_pools[size + 1]= info

        if info.kind == 'long' or info.kind == 'double' then
            constant_pools[#constant_pools + 1]= {}
        end
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

    local methods_count= reader.int16()
    local methods= {}
    while #(methods) < methods_count do
        local size= #(methods)

        methods[size + 1]= method_info.new(reader)
    end

    local attributes_count= reader.int16()
    local attributes= {}
    while #(attributes) < attributes_count do
        local size= #(attributes)

        attributes[size + 1]= attribute_info.new(reader)
    end

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
