local attribute_info= require 'raw.attribute_info'

local inner_classes= attribute_info:clone()

inner_classes.kind= 'InnerClass'

function inner_classes.new(constant_pools, reader)
    local info= inner_classes:clone()

    info.attribute_length= reader:read_int32()
    info.number_of_classes= reader:read_int16()

    info.classes= {}

    while #(info.classes) < info.number_of_classes do
        table.insert(info.classes, {
            inner_class_info_index=   reader:read_int16(),
            outer_class_info_index=   reader:read_int16(),
            inner_name_index=         reader:read_int16(),
            inner_class_access_flags= reader:read_int16(),
        })
    end

    return info
end

return inner_classes
