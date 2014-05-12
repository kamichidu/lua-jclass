local prototype=    require 'prototype'
local jfield=       require 'jfield'
local jmethod=      require 'jmethod'
local access_flags= require 'raw.access_flags'
local class_file=   require 'raw.class_file'
local binary_file=  require 'util.binary_file'
local parser=       require 'util.parser_factory'
local utf8=         require 'util.utf8'
local iterators=    require 'util.iterators'

local jclass= prototype {
    default=  prototype.assignment_copy,
    table=    prototype.deep_copy,
    userdata= prototype.clone_copy,
}

jclass.attrs= {}

function jclass.parse_file(filename)
    local file
    local ok, ret= pcall(function()
        local err

        file, err= binary_file.open(filename)

        if not file then
            error(err)
        end

        return jclass.parse(file)
    end)
    if file then
        file:close()
    end

    if not ok then
        error(ret)
    end

    return ret
end

function jclass.parse(file)
    local jc= jclass:clone()

    jc.attrs.raw= class_file.parse(file)

    local flags= access_flags:clone()

    flags.access_flags= jc.attrs.raw.access_flags

    return jc:mixin(flags,
        'is_public',
        'is_final',
        'is_super',
        'is_interface',
        'is_abstract',
        'is_synthetic',
        'is_annotation',
        'is_enum'
    )
end

function jclass.for_name(canonical_name)
    local zip= require 'zip'

    for _, classpath in ipairs(jclass.classpath()) do
        local ok, file= pcall(function()
            return zip.open(classpath)
        end)

        if ok and file then
            local classfile= jclass.open_inside(file, canonical_name)

            if classfile then
                local ok, ret= pcall(function()
                    return jclass.parse(classfile)
                end)

                classfile:close()

                if not ok then
                    error(ret)
                end

                return ret
            end

            file:close()
        end
    end

    return nil
end

function jclass.classpath(...)
    local arguments= {...}

    if #(arguments) > 0 then
        local classpaths= {}

        local append
        append= function(container, elements)
            for _, classpath in ipairs(elements) do
                if type(classpath) == 'string' then
                    table.insert(classpaths, classpath)
                elseif type(classpath) == 'table' then
                    append(container, classpath)
                end
            end
        end
        append(classpaths, arguments)

        jclass.attrs.classpaths= classpaths
    else
        return jclass.attrs.classpaths or {}
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
    local const_class= self:constant_pools()[self:raw().this_class]
    local name= self:index2string(const_class.name_index)
    local canonical_name= name:gsub('[/$]', '.')

    return canonical_name
end

function jclass:simple_name()
    return self:canonical_name():match('%w+$')
end

function jclass:classes()
    return iterators.filter(self:declared_classes(), function(input)
        return input:is_public()
    end)
end

function jclass:declared_classes()
    local attr_inner_classes= iterators.find(
        iterators.make_iterator(self:attributes()),
        function(input)
            return input.kind == 'InnerClass'
        end
    )

    if not attr_inner_classes then
        return iterators.make_iterator({})
    end

    local classes= iterators.make_iterator(attr_inner_classes.classes)
    return iterators.transform(classes, function(input)
            local class_info= self:constant_pools()[input.inner_class_info_index]
            local resource_name= self:index2string(class_info.name_index)
            local classname= resource_name:gsub('[/$]', '.')

            return jclass.for_name(classname)
        end
    )
end

function jclass:constructors()
    return iterators.filter(self:declared_constructors(), function(input)
        return input:is_public()
    end)
end

function jclass:declared_constructors()
    local methods= iterators.make_iterator(self:raw().methods)
    local methods= iterators.transform(methods, function(input)
        return jmethod.new(self:constant_pools(), input)
    end)
    return iterators.filter(methods, function(input)
        return input:name() == '<init>' or input:name() == '<cinit>' or input:name() == '<clinit>'
    end)
end

function jclass:fields()
    return iterators.filter(self:declared_fields(), function(input)
        -- return input:is_public()
        return input:is_private()
    end)
end

function jclass:declared_fields()
    local fields= iterators.make_iterator(self:raw().fields)
    local fields= iterators.transform(fields, function(input)
        return jfield.new(self:constant_pools(), input)
    end)
    return fields
end

function jclass:methods()
    return iterators.filter(self:declared_methods(), function(input)
        return input:is_public()
    end)
end

function jclass:declared_methods()
    local methods= iterators.make_iterator(self:raw().methods)
    local methods= iterators.transform(methods, function(input)
        return jmethod.new(self:constant_pools(), input)
    end)
    return iterators.filter(methods, function(input)
        return input:name() ~= '<init>' and input:name() ~= '<cinit>' and input:name() ~= '<clinit>'
    end)
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

function jclass:attributes()
    return self:raw().attributes or {}
end

function jclass:index2string(idx)
    local const_utf8= self:constant_pools()[idx]

    if const_utf8 then
        return utf8.decode(const_utf8.bytes)
    else
        return nil
    end
end

function jclass.open_inside(jarfile, classname)
    local filename= classname:gsub('%.', '/') .. '.class'

    local file= jarfile:open(filename)

    if file then
        local bfile= binary_file:clone()

        bfile.fh= file

        return bfile
    end

    if classname:find('%.') then
        return jclass.open_inside(jarfile, classname:gsub('%.([a-zA-Z0-9$_]+)$', '$%1'))
    else
        return nil
    end
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

get current classpath string of list.

=item B<jclass.classpath(classpaths)>

set new classpath string of list.

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
