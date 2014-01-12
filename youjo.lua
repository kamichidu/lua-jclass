youjo= {}

function youjo.say(message, ...)
    -- print(message .. ': ' .. table.concat(... or {}, ', '))
end

function youjo.say_utf8(message, ...)
    local s= ''
    for i, b in ipairs(... or {}) do
        s= s .. string.char(b)
    end
    print(message .. ': ' .. s)
end
