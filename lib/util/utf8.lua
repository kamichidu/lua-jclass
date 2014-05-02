local prototype= require 'prototype'

local utf8= prototype {
    default= prototype.no_copy,
}

function utf8.decode(bytes)
    assert(bytes, 'ensure non-nil')

    local s= ''

    for _, byte in ipairs(bytes) do
        s= s .. string.char(byte)
    end

    return s
end

return utf8
