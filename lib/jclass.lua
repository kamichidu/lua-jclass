local prototype=         require 'prototype'
local jfield=            require 'jfield'
local jmethod=           require 'jmethod'
local accessible_object= require 'raw.accessible_object'
local class_file=        require 'raw.class_file'
local bitwise=           require 'util.bitwise'
local byte_reader=       require 'util.byte_reader'
local parser=            require 'util.parser'
local youjo=             require 'util.youjo'

local jclass= prototype {
    default= prototype.assignment_copy,
}

function jclass.parse_file(filename)
    return self:new(byte_reader.new(filename))
end

function jclass.for_name(reader)
    local class_file= class_file.new(reader)

    local obj= setmetatable({}, {__index= accessible_object:new(class_file._access_flags)})

    function obj.version()
        return tonumber(class_file._major_version .. '.' .. class_file._minor_version)
    end

    function obj.classname()
        local class_info= class_file._constant_pools[class_file._this_class]
        local name_info= class_file._constant_pools[class_info._name_index]

        local s, c= youjo:decode_utf8(name_info._bytes):gsub('/', '.')

        return s
    end

    function obj.super_classname()
        local class_info= class_file._constant_pools[class_file._super_class]

        if not class_info then
            return nil
        end

        local name_info= class_file._constant_pools[class_info._name_index]

        local s, c= youjo:decode_utf8(name_info._bytes):gsub('/', '.')

        return s
    end

    function obj.super_class(path_resolver)
        local class_info= class_file._constant_pools[class_file._super_class]
        local name_info= class_file._constant_pools[class_info._name_index]
        local relative_path= youjo:decode_utf8(name_info._bytes) .. '.class'

        local path= path_resolver(relative_path)

        return self:new(byte_reader.new(path))
    end

    function obj.fields()
        local fields= {}

        for i, field_info in ipairs(class_file._fields) do
            fields[#fields + 1]= jfield:new(class_file._constant_pools, field_info)
        end

        return fields
    end

    function obj.methods()
        local methods= {}

        for i, method_info in ipairs(class_file._methods) do
            methods[#methods + 1]= jmethod:new(class_file._constant_pools, method_info)
        end

        return methods
    end

    return obj
end

return jclass

--[[
=pod

=head1 NAME

jclass - java class representation object

=head1 VERSION

still alpha ver.

=head1 SYSNOPSIS

    local jclass= require 'jclass'

    local clazz= jclass:parse_file('path/to/java/util/List.class')

    -- display 'java.util.List'
    print(clazz:canonical_name())

    for jfield_object in clazz:fields() do
        -- see `jfield'
    end

    for jmethod_object in clazz:methods() do
        -- see `jmethod'
    end

=head1 DESCRIPTION

jclass is a representation of the java class object.

TODO

=head2 PROVIDED OBJECT

jclass provides a L<prototype> object.

=head2 PROVIDED FUNCTIONS

=over 4

=item B<jclass.parse_file(filename)>

this method will create a new jclass object from file.

=item B<jclass.for_name(canonical_name)>

TODO

=item B<jclass.classpath()>

get current classpath string.

=item B<jclass.classpath(classpath)>

set new classpath string.

=back

=head2 PROVIDED METHODS

=over 4

=item B<jclass:package_name()>

=item B<jclass:canonical_name()>

=item B<jclass:simple_name()>

=item B<jclass:classes()>

=item B<jclass:declared_classes()>

=item B<jclass:constructors()>

=item B<jclass:declared_constructors()>

=item B<jclass:fields()>

=item B<jclass:declared_fields()>

=item B<jclass:methods()>

=item B<jclass:declared_methods()>

=item B<jclass:annotations()>

returns all annotations present on this class.
this method will return a empty table if no annotations presented.

=item B<jclass:declared_annotations()>

=item B<jclass:component_type()>

=item B<jclass:declaring_class()>

=item B<jclass:enclosing_class()>

=item B<jclass:enclosing_constructor()>

=item B<jclass:enclosing_method()>

=item B<jclass:enum_constants()>

=item B<jclass:interfaces()>

=item B<jclass:superclass()>

=item B<jclass:type_parameters()>

=item B<jclass:is_annotation()>

=item B<jclass:is_anonymouse_class()>

=item B<jclass:is_array()>

=item B<jclass:is_assignable_from(jclass)>

=item B<jclass:is_enum()>

=item B<jclass:is_interface()>

=item B<jclass:is_local_class()>

=item B<jclass:is_member_class()>

=item B<jclass:is_primitive()>

=item B<jclass:is_synthetic()>

=item B<jclass:is_public()>

=item B<jclass:is_protected()>

=item B<jclass:is_private()>

=back

=head1 AUTHOR

kamichidu - L<c.kamunagi@gmail.com>

=head1 LICENSE

see LICENSE file.

=cut
--]]
