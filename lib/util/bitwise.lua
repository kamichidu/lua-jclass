if bit32 then
    return bit32
end

-- emulate bitwise operation
-- http://ricilake.blogspot.jp/2007/10/iterating-bits-in-lua.html
local bitwise= {}

function bitwise.bit(x)
    return 2 ^ (x - 1)
end

function bitwise.hasbit(x, y)
    return x % (y + y) >= y
end

function bitwise.bnot(x)
    return (-1 - x) % 2 ^ 32
end

function bitwise.band(...)
    local args= {...}
    local z= 0

    for i, arg in ipairs(args) do
        z= bitwise.band2(z, arg)
    end

    return z
end

function bitwise.band2(x, y)
    local p= 1
    local z= 0
    local limit= x > y and x or y

    while p <= limit do
        if bitwise.hasbit(x, p) and bitwise.hasbit(y, p) then
            z= z + p
        end
        p= p + p
    end

    return z
end

function bitwise.bor(...)
    local args= {...}
    local z= 0

    for i, arg in ipairs(args) do
        z= bitwise.bor2(z, arg)
    end

    return z
end

function bitwise.bor2(x, y)
    local p= 1

    while p < x do
        p= p + p
    end
    while p < y do
        p= p + p
    end

    local z= 0

    repeat
        if p <= x or p <= y then
            z= z + p
            if p <= x then
                x= x - p
            end
            if p <= y then
                y= y - p
            end
        end
        p= p * 0.5
    until p < 1

    return z
end

function bitwise.lshift(x, disp)
    if disp == 0 then
        return x
    end

    assert(disp > 0, 'cannot emulate 0 or negative disp')

    return x * 2 ^ disp % 2 ^ 32
end

return bitwise;
