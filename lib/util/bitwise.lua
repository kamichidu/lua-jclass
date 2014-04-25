if bit32 then
    return bit32
elseif bit then
    -- for luajit
    return require('bit')
else
    error('bit operation not supported.')
end
