local cp_info= require 'raw.cp_info'

local invoke_dynamic= cp_info:clone()

invoke_dynamic.kind= 'InvokeDynamic'

function invoke_dynamic.new(tag, file)
    assert(tag == 18, 'illegal argument')

    local info= invoke_dynamic:clone()

    info.tag=                         tag
    info.bootstrap_method_attr_index= file:read('u2')
    info.name_and_type_index=         file:read('u2')

    return info
end

return invoke_dynamic
