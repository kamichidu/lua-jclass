local cp_info= require 'raw.cp_info'

local methodref= cp_info:clone()

methodref.kind= 'Methodref'

function methodref.new(tag, file)
    assert(tag == 10, 'illegal argument')

    local info= methodref:clone()

    info.tag=                 tag
    info.class_index=         file:read('u2')
    info.name_and_type_index= file:read('u2')

    return info
end

return methodref
