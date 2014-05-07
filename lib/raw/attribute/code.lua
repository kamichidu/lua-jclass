local attribute_info= require 'raw.attribute_info'

local code= attribute_info:clone()

code.kind= 'Code'

function code.new(constant_pools, file)
    local info= code:clone()

    info.attribute_length=       file:read('u4')
    info.max_stack=              file:read('u2')
    info.max_locals=             file:read('u2')
    info.code_length=            file:read('u4')
    info.code=                   file:read(info.code_length)
    info.exception_table_length= file:read('u2')

    info.exception_table= {}

    while #(info.exception_table) < info.exception_table_length do
        table.insert(info.exception_table, {
            start_pc=   file:read('u2'),
            end_pc=     file:read('u2'),
            handler_pc= file:read('u2'),
            catch_type= file:read('u2'),
        })
    end

    info.attributes_count= file:read('u2')

    info.attributes= {}

    while #(info.attributes) < info.attributes_count do
        table.insert(info.attributes, attribute_info.parse(constant_pools, file))
    end

    return info
end

return code
