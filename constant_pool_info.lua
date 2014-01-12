require 'youjo'

constant_pool_info= {
    _tag_kind= {
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
    },
}

function constant_pool_info.new(reader)
    -- local cp_info= {
    --     _tag= nil, -- 1 byte
    --     -- other attributes decided by _tag value
    -- }
    local tag= reader.int8()
    youjo.say('read tag is ' .. tag)

    if tag == constant_pool_info._tag_kind.class then
        youjo.say('tag is class')
        local name_index= reader.int16()
        youjo.say('name_index is ' .. name_index)

        return {
            _tag= tag,
            _name_index= name_index,
        }
    end
    if tag == constant_pool_info._tag_kind.fieldref then
        local class_index, name_and_type_index= reader.int16(), reader.int16()

        return {
            _tag= tag,
            _class_index= class_index,
            _name_and_type_index= name_and_type_index,
        }
    end
    if tag == constant_pool_info._tag_kind.methodref then
        local class_index, name_and_type_index= reader.int16(), reader.int16()

        return {
            _tag= tag,
            _class_index= class_index,
            _name_and_type_index= name_and_type_index,
        }
    end
    if tag == constant_pool_info._tag_kind.interface_methodref then
        local class_index, name_and_type_index= reader.int16(), reader.int16()

        return {
            _tag= tag,
            _class_index= class_index,
            _name_and_type_index= name_and_type_index,
        }
    end
    if tag == constant_pool_info._tag_kind.string then
        local string_index= reader.int16()

        return {
            _tag= tag,
            _string_index= string_index,
        }
    end
    if tag == constant_pool_info._tag_kind.integer then
        local bytes= reader.int32()

        return {
            _tag= tag,
            _bytes= bytes,
        }
    end
    if tag == constant_pool_info._tag_kind.float then
        local bytes= reader.int32()

        return {
            _tag= tag,
            _bytes= bytes,
        }
    end
    if tag == constant_pool_info._tag_kind.long then
        local high_bytes, low_bytes= reader.int32(), reader.int32()

        return {
            _tag= tag,
            _high_bytes= high_bytes,
            _low_bytes= low_bytes,
        }
    end
    if tag == constant_pool_info._tag_kind.double then
        local high_bytes, low_bytes= reader.int32(), reader.int32()

        return {
            _tag= tag,
            _high_bytes= high_bytes,
            _low_bytes= low_bytes,
        }
    end
    if tag == constant_pool_info._tag_kind.name_and_type then
        local name_index, descriptor_index= reader.int16(), reader.int16()

        return {
            _tag= tag,
            _name_index= name_index,
            _descriptor_index= descriptor_index,
        }
    end
    if tag == constant_pool_info._tag_kind.utf8 then
        youjo.say('tag is utf8')
        local length= reader.int16()
        youjo.say('length is ' .. length)
        local bytes=  reader.bytes(length)
        youjo.say_utf8('bytes are ', bytes)

        return {
            _tag= tag,
            _length= length,
            _bytes= bytes,
        }
    end
    if tag == constant_pool_info._tag_kind.method_handle then
        local reference_kind, reference_index= reader.int8(), reader.int16()

        return {
            _tag= tag,
            _reference_kind= reference_kind,
            _reference_index= reference_index,
        }
    end
    if tag == constant_pool_info._tag_kind.method_type then
        local descriptor_index= reader.int16()

        return {
            _tag= tag,
            _descriptor_index= descriptor_index,
        }
    end
    if tag == constant_pool_info._tag_kind.invoke_dynamic then
        local bootstrap_method_attr_index, name_and_type_index= reader.int16(), reader.int16()

        return {
            _tag= tag,
            _bootstrap_method_attr_index= bootstrap_method_attr_index,
            _name_and_type_index= name_and_type_index,
        }
    end

    error(string.format('got a unknown cp_info tag: %d', tag))
end
