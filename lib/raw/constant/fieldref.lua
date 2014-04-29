local cp_info= require 'raw.cp_info'

local fieldref= cp_info:clone()

fieldref.kind= 'Fieldref'

function fieldref.new(tag, reader)
    assert(tag == 9, 'illegal argument')

    local info= fieldref:clone()

    info.tag= tag
    info.class_index= reader:read_int16()
    info.name_and_type_index= reader:read_int16()

    return info
end

return fieldref
