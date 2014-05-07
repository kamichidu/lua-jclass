local cp_info= require 'raw.cp_info'

local fieldref= cp_info:clone()

fieldref.kind= 'Fieldref'

function fieldref.new(tag, file)
    assert(tag == 9, 'illegal argument')

    local info= fieldref:clone()

    info.tag=                 tag
    info.class_index=         file:read('u2')
    info.name_and_type_index= file:read('u2')

    return info
end

return fieldref
