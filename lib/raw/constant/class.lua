local cp_info= require 'raw.cp_info'

local class= cp_info:clone()

class.kind= 'Class'

function class.new(tag, reader)
    assert(tag == 7, 'illegal argument')

    local info= class:clone()

    info.tag= tag
    info.name_index= reader:read_int16()

    return info
end

return class
