local jfield=            require 'jfield'
local jmethod=           require 'jmethod'
local accessible_object= require 'raw.accessible_object'
local class_file=        require 'raw.class_file'
local bitwise=           require 'util.bitwise'
local byte_reader=       require 'util.byte_reader'
local parser=            require 'util.parser'
local youjo=             require 'util.youjo'

local jclass= {}

function jclass.from_file(filename)
    return jclass.new(byte_reader.new(filename))
end

function jclass.new(reader)
    local class_file= class_file.new(reader)

    local obj= setmetatable({}, {__index= accessible_object.new(class_file._access_flags)})

    function obj.version()
        return tonumber(class_file._major_version .. '.' .. class_file._minor_version)
    end

    function obj.classname()
        local class_info= class_file._constant_pools[class_file._this_class]
        local name_info= class_file._constant_pools[class_info._name_index]

        local s, c= youjo.decode_utf8(name_info._bytes):gsub('/', '.')

        return s
    end

    function obj.super_classname()
        local class_info= class_file._constant_pools[class_file._super_class]

        if not class_info then
            return nil
        end

        local name_info= class_file._constant_pools[class_info._name_index]

        local s, c= youjo.decode_utf8(name_info._bytes):gsub('/', '.')

        return s
    end

    function obj.super_class(path_resolver)
        local class_info= class_file._constant_pools[class_file._super_class]
        local name_info= class_file._constant_pools[class_info._name_index]
        local relative_path= youjo.decode_utf8(name_info._bytes) .. '.class'

        local path= path_resolver(relative_path)

        return jclass.new(byte_reader.new(path))
    end

    function obj.fields()
        local fields= {}

        for i, field_info in ipairs(class_file._fields) do
            fields[#fields + 1]= jfield.new(class_file._constant_pools, field_info)
        end

        return fields
    end

    function obj.methods()
        local methods= {}

        for i, method_info in ipairs(class_file._methods) do
            methods[#methods + 1]= jmethod.new(class_file._constant_pools, method_info)
        end

        return methods
    end

    return obj
end

return jclass
