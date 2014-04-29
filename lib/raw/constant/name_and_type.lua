local cp_info= require 'raw.cp_info'

local name_and_type= cp_info:clone()

name_and_type.kind= 'NameAndType'

function name_and_type.new(tag, reader)
    assert(tag == 12, 'illegal argument')

    local info= name_and_type:clone()

    info.tag= tag
    info.name_index= reader:read_int16()
    info.descriptor_index= reader:read_int16()

    return info
end

return name_and_type
