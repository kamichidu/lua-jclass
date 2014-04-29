local cp_info= require 'raw.cp_info'

local methodref= cp_info:clone()

methodref.kind= 'Methodref'

function methodref.new(tag, reader)
    assert(tag == 10, 'illegal argument')

    local info= methodref:clone()

    info.tag= tag
    info.class_index= reader:read_int16()
    info.name_and_type_index= reader:read_int16()

    return info
end

return methodref
