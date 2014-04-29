local prototype= require 'prototype'

local lookahead_queue= require 'util.lookahead_queue'

local method_descriptor= prototype {
    default= prototype.assignment_copy,
}

setmetatable(method_descriptor, {__index= require('util.parser.field_descriptor')})

function method_descriptor:parse(s)
    assert(s, 'cannot parse nil value')

    local input= lookahead_queue.from_string(s)

    return self:method_descriptor(input)
end

-- MethodDescriptor:
--     ( ParameterDescriptor* ) ReturnDescriptor
function method_descriptor:method_descriptor(input)
    local c= input:poll()

    assert(c == '(', "`MethodDescriptor' starts with `('")

    local param_types= {}

    while 1 do
        c= input:peek()

        if c == ')' then
            input:poll()
            break
        end

        param_types[#(param_types) + 1]= self:parameter_descriptor(input)
    end

    local ret_type= self:return_descriptor(input)

    return {
        parameter_types= param_types,
        return_type= ret_type,
    }
end

-- ParameterDescriptor:
--     FieldType
function method_descriptor:parameter_descriptor(input)
    return self:field_type(input)
end

-- ReturnDescriptor:
--     FieldType
--     VoidDescriptor
function method_descriptor:return_descriptor(input)
    local c= input:peek()

    if c == 'V' then
        return self:void_descriptor(input)
    else
        return self:field_type(input)
    end
end

-- VoidDescriptor:
--     V
function method_descriptor:void_descriptor(input)
    local c= input:poll()

    assert(c == 'V', "`VoidDescriptor' is `V'")

    return 'void'
end

return method_descriptor
