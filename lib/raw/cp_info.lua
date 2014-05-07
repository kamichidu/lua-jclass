local prototype= require 'prototype'

local cp_info= prototype {
    default= prototype.assignment_copy,
    table=   prototype.deep_copy,
}

local constants= {
    class=                7,
    fieldref=             9,
    methodref=           10,
    interface_methodref= 11,
    string=               8,
    integer=              3,
    float=                4,
    long=                 5,
    double=               6,
    name_and_type=       12,
    utf8=                 1,
    method_handle=       15,
    method_type=         16,
    invoke_dynamic=      18,
}

function cp_info.parse(file)
    local tag= file:read('u1')

    if tag == constants.class               then return require('raw.constant.class').new(tag, file) end
    if tag == constants.fieldref            then return require('raw.constant.fieldref').new(tag, file) end
    if tag == constants.methodref           then return require('raw.constant.methodref').new(tag, file) end
    if tag == constants.interface_methodref then return require('raw.constant.interface_methodref').new(tag, file) end
    if tag == constants.string              then return require('raw.constant.string').new(tag, file) end
    if tag == constants.integer             then return require('raw.constant.integer').new(tag, file) end
    if tag == constants.float               then return require('raw.constant.float').new(tag, file) end
    if tag == constants.long                then return require('raw.constant.long').new(tag, file) end
    if tag == constants.double              then return require('raw.constant.double').new(tag, file) end
    if tag == constants.name_and_type       then return require('raw.constant.name_and_type').new(tag, file) end
    if tag == constants.utf8                then return require('raw.constant.utf8').new(tag, file) end
    if tag == constants.method_handle       then return require('raw.constant.method_handle').new(tag, file) end
    if tag == constants.method_type         then return require('raw.constant.method_type').new(tag, file) end
    if tag == constants.invoke_dynamic      then return require('raw.constant.invoke_dynamic').new(tag, file) end

    error(string.format("unknown tag `%d'", tag))
end

return cp_info
