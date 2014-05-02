local prototype= require 'prototype'

local youjo= prototype {
    default= prototype.no_copy,
}

function youjo:decode_utf8(bytes)
    local utf8= ''

    for i, byte in ipairs(bytes) do
        utf8= utf8 .. string.char(byte)
    end

    return utf8
end

return youjo
