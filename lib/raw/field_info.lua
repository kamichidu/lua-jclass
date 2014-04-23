require 'raw.attribute_info'

field_info= {
}

function field_info.new(reader)
    local access_flags= reader.int16()
    local name_index=   reader.int16()
    local descriptor_index= reader.int16()
    local attributes_count= reader.int16()
    local attributes= {}

    while #(attributes) < attributes_count do
        attributes[#attributes + 1]= attribute_info.new(reader)
    end

    return {
        _access_flags=     access_flags,
        _name_index=       name_index,
        _descriptor_index= descriptor_index,
        _attributes_count= attributes_count,
        _attributes=       attributes,
    }
end
