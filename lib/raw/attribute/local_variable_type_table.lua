local attribute_info= require 'raw.attribute_info'

local local_variable_type_table= attribute_info:clone()

local_variable_type_table.kind= 'LocalVariableTypeTable'

function local_variable_type_table.new(constant_pools, reader)
    local info= local_variable_type_table:clone()

    info.attribute_length=                 reader:read_int32()
    info.local_variable_type_table_length= reader:read_int16()

    info.local_variable_type_table= {}

    while #(info.local_variable_type_table) < info.local_variable_type_table_length do
        table.insert(info.local_variable_type_table, {
            start_pc=        reader:read_int16(),
            length=          reader:read_int16(),
            name_index=      reader:read_int16(),
            signature_index= reader:read_int16(),
            index=           reader:read_int16(),
        })
    end

    return info
end

return local_variable_type_table