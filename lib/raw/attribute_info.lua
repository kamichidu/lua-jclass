local attribute_info= {}

function attribute_info.new(reader)
    local attribute_name_index= reader.int16()
    local attribute_length=     reader.int32()
    local info= {}

    while #(info) < attribute_length do
        local size= #(info)

        info[size + 1]= reader.int8()
    end

    return {
        _attribute_name_index= attribute_name_index,
        _attribute_length=     attribute_length,
        _info=                 info,
    }
end

return attribute_info
