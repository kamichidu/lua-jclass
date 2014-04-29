local cp_info= require 'raw.cp_info'

local method_handle= cp_info:clone()

method_handle.kind= 'MethodHandle'

function method_handle.new(tag, reader)
    assert(tag == 15, 'illegal argument')

    local info= method_handle:clone()

    info.tag= tag
    info.reference_kind= reader:reader:read_int8()
    info.reference_index= reader:read_int16()

    return info
end

return method_handle
