local attribute_info= require 'raw.attribute_info'

local exceptions= attribute_info:clone()

exceptions.kind= 'Exceptions'

function exceptions.new(constant_pools, reader)
    local info= exceptions:clone()

    info.attribute_length=     reader:read_int32()
    info.number_of_exceptions= reader:read_int16()

    info.exception_index_table= {}

    while #(info.exception_index_table) < info.number_of_exceptions do
        table.insert(info.exception_index_table, reader:read_int16())
    end

    return info
end

return exceptions
