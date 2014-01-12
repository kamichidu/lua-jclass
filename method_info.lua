require 'attribute_info'

method_info= {}

function method_info.new(reader)
    local access_flag=      reader.int16()
    local name_index=       reader.int16()
    local descriptor_index= reader.int16()
    local attributes_count= reader.int16()
    local attributes= {}

    while #(attributes) < attributes_count do
        local size= #(attributes)

        attributes[size + 1]= attribute_info.new(reader)
    end

    return {
        _access_flag=      access_flag,
        _name_index=       name_index,
        _descriptor_index= descriptor_index,
        _attributes_count= attributes_count,
        _attributes=       attributes,
    }
end
