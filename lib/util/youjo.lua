local prototype= require 'prototype'

local youjo= prototype {
    default= prototype.no_copy,
}

function youjo:say(message, ...)
    print(message .. ': ' .. table.concat(... or {}, ', '))
end

function youjo:say_utf8(message, ...)
    local s= ''
    for i, b in ipairs(... or {}) do
        s= s .. string.char(b)
    end
    print(message .. ': ' .. s)
end

local function pretty_table(o)
    local buf= {}

    -- for i, v in ipairs(o) do
    --     buf[#buf + 1]= youjo.pretty(v)
    -- end
    for k, v in pairs(o) do
        if type(k) == type(0) then
            buf[#buf + 1]= youjo.pretty(v)
        else
            buf[#buf + 1]= k .. '=' .. youjo.pretty(v)
        end
    end

    return "{" .. table.concat(buf, ", ") .. "}"
end
local function pretty_string(o)
    return '"' .. o .. '"'
end
function youjo:pretty(o)
    if type(o) == type({}) then
        return pretty_table(o)
    elseif type(o) == type('') then
        return pretty_string(o)
    else
        return '' .. o
    end
end

function youjo:decode_utf8(bytes)
    local utf8= ''

    for i, byte in ipairs(bytes) do
        utf8= utf8 .. string.char(byte)
    end

    return utf8
end

function youjo:filter(unfiltered, predicate)
    local filtered= {}

    for i, e in ipairs(unfiltered) do
        if predicate(e) then
            table.insert(filtered, e)
        end
    end

    return filtered
end

function youjo:make_iterator(list)
    assert(list, 'got nil')

    for i, v in ipairs(list) do
    end
end

return youjo
