local constant_pool_info= {}

local tag_kind= {
    class=                7,
    fieldref=             9,
    methodref=           10,
    interface_methodref= 11,
    string=               8,
    integer=              3,
    float=                4,
    long=                 5,
    double=               6,
    name_and_type=       12,
    utf8=                 1,
    method_handle=       15,
    method_type=         16,
    invoke_dynamic=      18,
}

local factories= {
    [tag_kind.class]= function(tag, reader)
        local name_index= reader.int16()

        return {
            kind= 'class',
            _tag= tag,
            _name_index= name_index,
        }
    end,
    [tag_kind.fieldref]= function(tag, reader)
        local class_index, name_and_type_index= reader.int16(), reader.int16()

        return {
            kind= 'fieldref',
            _tag= tag,
            _class_index= class_index,
            _name_and_type_index= name_and_type_index,
        }
    end,
    [tag_kind.methodref]= function(tag, reader)
        local class_index, name_and_type_index= reader.int16(), reader.int16()

        return {
            kind= 'methodref',
            _tag= tag,
            _class_index= class_index,
            _name_and_type_index= name_and_type_index,
        }
    end,
    [tag_kind.interface_methodref]= function(tag, reader)
        local class_index, name_and_type_index= reader.int16(), reader.int16()

        return {
            kind= 'methodref',
            _tag= tag,
            _class_index= class_index,
            _name_and_type_index= name_and_type_index,
        }
    end,
    [tag_kind.string]= function(tag, reader)
        local string_index= reader.int16()

        return {
            kind= 'string',
            _tag= tag,
            _string_index= string_index,
        }
    end,
    [tag_kind.integer]= function(tag, reader)
        local bytes= reader.int32()

        return {
            kind= 'integer',
            _tag= tag,
            _bytes= bytes,
        }
    end,
    [tag_kind.float]= function(tag, reader)
        local bytes= reader.int32()

        return {
            kind= 'float',
            _tag= tag,
            _bytes= bytes,
        }
    end,
    [tag_kind.long]= function(tag, reader)
        local high_bytes, low_bytes= reader.int32(), reader.int32()

        return {
            kind= 'long',
            _tag= tag,
            _high_bytes= high_bytes,
            _low_bytes= low_bytes,
        }
    end,
    [tag_kind.double]= function(tag, reader)
        local high_bytes, low_bytes= reader.int32(), reader.int32()

        return {
            kind= 'double',
            _tag= tag,
            _high_bytes= high_bytes,
            _low_bytes= low_bytes,
        }
    end,
    [tag_kind.name_and_type]= function(tag, reader)
        local name_index, descriptor_index= reader.int16(), reader.int16()

        return {
            kind= 'name_and_type',
            _tag= tag,
            _name_index= name_index,
            _descriptor_index= descriptor_index,
        }
    end,
    [tag_kind.utf8]= function(tag, reader)
        local length= reader.int16()
        local bytes=  reader.bytes(length)

        return {
            kind= 'utf8',
            _tag= tag,
            _length= length,
            _bytes= bytes,
        }
    end,
    [tag_kind.method_handle]= function(tag, reader)
        local reference_kind, reference_index= reader.int8(), reader.int16()

        return {
            kind= 'method_handle',
            _tag= tag,
            _reference_kind= reference_kind,
            _reference_index= reference_index,
        }
    end,
    [tag_kind.method_type]= function(tag, reader)
        local descriptor_index= reader.int16()

        return {
            kind= 'method_type',
            _tag= tag,
            _descriptor_index= descriptor_index,
        }
    end,
    [tag_kind.invoke_dynamic]= function(tag, reader)
        local bootstrap_method_attr_index, name_and_type_index= reader.int16(), reader.int16()

        return {
            kind= 'invoke_dynamic',
            _tag= tag,
            _bootstrap_method_attr_index= bootstrap_method_attr_index,
            _name_and_type_index= name_and_type_index,
        }
    end,
}

function constant_pool_info.new(reader)
    local tag= reader.int8()

    return factories[tag](tag, reader)
end

return constant_pool_info
