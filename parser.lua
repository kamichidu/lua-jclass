parser= {}

local
function parse_error(s, p)
    error('parse error: text="' .. s .. '", index=' .. p)
end

local
function char(s, i)
    if not (i >= 1 and i <= string.len(s)) then
        error('overflow: text="' .. s .. '", index=' .. i)
    end
    return string.sub(s, i, i)
end

local base_type_dictionary= {
    B= 'byte',
    C= 'char',
    D= 'double',
    F= 'float',
    I= 'int',
    J= 'long',
    S= 'short',
    Z= 'boolean',
}
local
function base_type(s, p)
    local c= char(s, p)

    return base_type_dictionary[c], p + 1
end

local
function object_type(s, p)
    local c= char(s, p)

    if not (c == 'L') then
        parse_error(s, p)
    end

    local buf= ''
    while 1 do
        p= p + 1
        c= char(s, p)

        if c == ';' then
            break
        end

        if c == '/' then
            buf= buf .. '.'
        else
            buf= buf .. c
        end
    end

    return buf, p + 1
end

local field_type

local
function array_type(s, p)
    local c= char(s, p)

    if not (c == '[') then
        parse_error(s, p)
    end

    local t, pp= field_type(s, p + 1)

    return t .. '[]', pp
end

local
function component_type(s, p)
    return field_type(s, p)
end

function field_type(s, p)
    local c= char(s, p)

    if c == 'L' then
        return object_type(s, p)
    elseif c == '[' then
        return array_type(s, p)
    else
        return base_type(s, p)
    end
end

local
function field_descriptor(s, p)
    return field_type(s, p)
end

local
function parameter_type(s, p)
    return field_type(s, p)
end

local
function parameter_descriptor(s, p)
    return parameter_type(s, p)
end

local
function void_descriptor(s, p)
    local c= char(s, p)

    if not (c == 'V') then
        parse_error(s, p)
    end

    return 'void', p + 1
end

local
function return_descriptor(s, p)
    local c= char(s, p)

    if c == 'V' then
        return void_descriptor(s, p)
    else
        return field_type(s, p)
    end
end

function parser.parse_field_descriptor(s)
    local t, p= field_type(s, 1)

    return {
        type= t,
    }
end

function parser.parse_method_descriptor(s)
    local p= 1
    local c= char(s, p)

    if not (c == '(') then
        parse_error(s, p)
    end

    local param_types, len= {}, 0
    p= p + 1

    while 1 do
        c= char(s, p)

        if c == ')' then
            p= p + 1
            break
        end

        param_types[#param_types + 1], p= parameter_descriptor(s, p)
    end

    local ret_type, p= return_descriptor(s, p)

    return {
        parameter_types= param_types,
        return_type= ret_type,
    }
end
