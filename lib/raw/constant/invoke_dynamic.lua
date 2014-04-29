local cp_info= require 'raw.cp_info'

local invoke_dynamic= cp_info:clone()

invoke_dynamic.kind= 'InvokeDynamic'

function invoke_dynamic.new(tag, reader)
    assert(tag == 18, 'illegal argument')

    local info= invoke_dynamic:clone()

    info.tag= tag
    info.bootstrap_method_attr_index= reader:read_int16()
    info.name_and_type_index= reader:read_int16()

    return info
end

return invoke_dynamic
