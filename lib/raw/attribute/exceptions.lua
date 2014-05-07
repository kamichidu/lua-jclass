local attribute_info= require 'raw.attribute_info'

local exceptions= attribute_info:clone()

exceptions.kind= 'Exceptions'

function exceptions.new(constant_pools, file)
    local info= exceptions:clone()

    info.attribute_length=     file:read('u4')
    info.number_of_exceptions= file:read('u2')

    info.exception_index_table= {}

    while #(info.exception_index_table) < info.number_of_exceptions do
        table.insert(info.exception_index_table, file:read('u2'))
    end

    return info
end

return exceptions
