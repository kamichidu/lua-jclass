local prototype= require 'prototype'

local lookahead_queue= require 'util.lookahead_queue'

local field_descriptor= prototype {
    default= prototype.assignment_copy,
}

function field_descriptor:parse(s)
    assert(s, 'cannot parse nil value')

    local input= lookahead_queue.from_string(s)
    local t= self:field_descriptor(input)

    return {
        type= t,
    }
end

-- FieldDescriptor:
--     FieldType
function field_descriptor:field_descriptor(input)
    return self:field_type(input)
end

-- FieldType:
--     BaseType
--     ObjectType
--     ArrayType
function field_descriptor:field_type(input)
    local c= input:peek()

    if c == 'L' then
        return self:object_type(input)
    elseif c == '[' then
        return self:array_type(input)
    else
        return self:base_type(input)
    end
end

-- BaseType:
--     B
--     C
--     D
--     F
--     I
--     J
--     S
--     Z
function field_descriptor:base_type(input)
    local c= input:poll()

    if c == 'B' then return 'byte' end
    if c == 'C' then return 'char' end
    if c == 'D' then return 'double' end
    if c == 'F' then return 'float' end
    if c == 'I' then return 'int' end
    if c == 'J' then return 'long' end
    if c == 'S' then return 'short' end
    if c == 'Z' then return 'boolean' end

    error('no base type definition.')
end

-- ObjectType:
--     L ClassName ;
function field_descriptor:object_type(input)
    local c= input:poll()

    assert(c == 'L', "`ObjectType' starts with `L'")

    local buf= ''
    while 1 do
        c= input:poll()

        if c == ';' then
            break
        end

        if c == '/' then
            buf= buf .. '.'
        else
            buf= buf .. c
        end
    end

    return buf
end

-- ArrayType:
--     [ ComponentType
function field_descriptor:array_type(input)
    local c= input:poll()

    assert(c == '[', "`ArrayType' starts with `['")

    return self:component_type(input) .. '[]'
end

-- ComponentType:
--     FieldType
function field_descriptor:component_type(input)
    return self:field_type(input)
end

return field_descriptor
