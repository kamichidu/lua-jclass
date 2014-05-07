local attribute_info= require 'raw.attribute_info'

local inner_classes= attribute_info:clone()

inner_classes.kind= 'InnerClass'

function inner_classes.new(constant_pools, file)
    local info= inner_classes:clone()

    info.attribute_length=  file:read('u4')
    info.number_of_classes= file:read('u2')

    info.classes= {}

    while #(info.classes) < info.number_of_classes do
        table.insert(info.classes, {
            inner_class_info_index=   file:read('u2'),
            outer_class_info_index=   file:read('u2'),
            inner_name_index=         file:read('u2'),
            inner_class_access_flags= file:read('u2'),
        })
    end

    return info
end

return inner_classes
