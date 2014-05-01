local cp_info= require 'raw.cp_info'

local interface_methodref= cp_info:clone()

interface_methodref.kind= 'InterfaceMethodref'

function interface_methodref.new(tag, reader)
    assert(tag == 11, 'illegal argument')

    local info= interface_methodref:clone()

    info.tag= tag
    info.class_index=         reader:read_int16()
    info.name_and_type_index= reader:read_int16()

    return info
end

return interface_methodref
