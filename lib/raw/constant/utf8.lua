local cp_info= require 'raw.cp_info'

local utf8= cp_info:clone()

utf8.kind= 'Utf8'

function utf8.new(tag, reader)
    assert(tag == 1, 'illegal argument')

    local info= utf8:clone()

    info.tag= tag
    info.length= reader:read_int16()

    if info.length > 0 then
        info.bytes= reader:read(info.length)
    else
        info.bytes= {}
    end

    return info
end

return utf8
