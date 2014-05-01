local attribute_info= require 'raw.attribute_info'

local code= attribute_info:clone()

code.kind= 'Code'

function code.new(constant_pools, reader)
    local info= code:clone()

    info.attribute_length=       reader:read_int32()
    info.max_stack=              reader:read_int16()
    info.max_locals=             reader:read_int16()
    info.code_length=            reader:read_int32()
    info.code=                   reader:read(info.code_length)
    info.exception_table_length= reader:read_int16()

    info.exception_table= {}

    while #(info.exception_table) < info.exception_table_length do
        table.insert(info.exception_table, {
            start_pc=   reader:read_int16(),
            end_pc=     reader:read_int16(),
            handler_pc= reader:read_int16(),
            catch_type= reader:read_int16(),
        })
    end

    info.attributes_count= reader:read_int16()

    info.attributes= {}

    while #(info.attributes) < info.attributes_count do
        table.insert(info.attributes, attribute_info.parse(constant_pools, reader))
    end

    return info
end

return code
