local attribute_info= require 'raw.attribute_info'

local local_variable_table= attribute_info:clone()

local_variable_table.kind= 'LocalVariableTable'

function local_variable_table.new(constant_pools, file)
    local info= local_variable_table:clone()

    info.attribute_length=            file:read('u4')
    info.local_variable_table_length= file:read('u2')

    info.local_variable_table= {}

    while #(info.local_variable_table) < info.local_variable_table_length do
        table.insert(info.local_variable_table, {
            start_pc=         file:read('u2'),
            length=           file:read('u2'),
            name_index=       file:read('u2'),
            descriptor_index= file:read('u2'),
            index=            file:read('u2'),
        })
    end

    return info
end

return local_variable_table
