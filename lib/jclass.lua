local prototype=    require 'prototype'
local jfield=       require 'jfield'
local jmethod=      require 'jmethod'
local access_flags= require 'raw.access_flags'
local class_file=   require 'raw.class_file'
local byte_reader=  require 'util.byte_reader'
local parser=       require 'util.parser_factory'
local youjo=        require 'util.youjo'

local jclass= prototype {
    default=  prototype.assignment_copy,
    table=    prototype.deep_copy,
    userdata= prototype.clone_copy,
}

jclass.attrs= {}

function jclass.parse_file(filename)
    local reader= byte_reader.open(filename)
    local jc= jclass:clone()

    jc.attrs.raw= class_file.parse(reader)

    reader:close()

    return jc
end

function jclass.for_name(canonical_name)
    -- TODO
end

function jclass.classpath(...)
    local args= {...}

    if #args then
        jclass.attrs.classpath= args[1]
    else
        return jclass.attrs.classpath
    end
end

function jclass:package_name()
    local fully_name= self:canonical_name()

    local parts= {}
    for part in fully_name:gmatch('%w+') do
        table.insert(parts, part)
    end

    if #parts > 1 then
        return table.concat(parts, '.', 1, #parts - 1)
    else
        return parts[1]
    end
end

function jclass:canonical_name()
    local const_class= self:raw().constant_pools[self:raw().this_class]
    local const_utf8= self:raw().constant_pools[const_class.name_index]

    local name= youjo:decode_utf8(const_utf8.bytes)

    return name:gsub('/', '.')
end

function jclass:simple_name()
    return self:canonical_name():match('%w+$')
end

function jclass:classes()
end

function jclass:declared_classes()
    local const_classes= youjo:filter(self:constant_pools(), function(cp_info)
        return cp_info.kind == 'Class'
    end)

    local classes= {}

    for i, const_class in ipairs(const_classes) do
        local const_utf8= self:constant_pools()[const_class.name_index]

        table.insert(classes, youjo:decode_utf8(const_utf8.bytes))
    end

    return youjo:make_iterator(classes)
end

function jclass:constructors()
end

function jclass:declared_constructors()
end

function jclass:fields()
end

function jclass:declared_fields()
end

function jclass:methods()
end

function jclass:declared_methods()
end

function jclass:annotations()
end

function jclass:declared_annotations()
end

function jclass:component_type()
end

function jclass:declaring_class()
end

function jclass:enclosing_class()
end

function jclass:enclosing_constructor()
end

function jclass:enclosing_method()
end

function jclass:enum_constants()
end

function jclass:interfaces()
end

function jclass:superclass()
end

function jclass:type_parameters()
end

function jclass:is_annotation()
end

function jclass:is_anonymouse_class()
end

function jclass:is_array()
end

function jclass:is_enum()
end

function jclass:is_interface()
end

function jclass:is_local_class()
end

function jclass:is_member_class()
end

function jclass:is_primitive()
end

function jclass:is_synthetic()
end

function jclass:is_public()
end

function jclass:is_protected()
end

function jclass:is_private()
end

-- utilities {{{
function jclass:raw()
    return self.attrs.raw or {}
end

function jclass:constant_pools()
    return self:raw().constant_pools or {}
end
-- }}}

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
-- vim: fen: fdm=marker
