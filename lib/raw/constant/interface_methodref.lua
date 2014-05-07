local cp_info= require 'raw.cp_info'

local interface_methodref= cp_info:clone()

interface_methodref.kind= 'InterfaceMethodref'

function interface_methodref.new(tag, file)
    assert(tag == 11, 'illegal argument')

    local info= interface_methodref:clone()

    info.tag=                 tag
    info.class_index=         file:read('u2')
    info.name_and_type_index= file:read('u2')

    return info
end

return interface_methodref
