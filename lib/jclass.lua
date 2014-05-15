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

function jclass.parse_file(filename) -- {{{
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
-- }}}

function jclass.parse(file) -- {{{
    local jc= jclass:clone()

    jc.attrs.raw= class_file.parse(file)

    local flags= access_flags:clone()

    flags.access_flags= jc.attrs.raw.access_flags

    return jc:mixin(flags,
        'is_public',
        'is_protected',
        'is_private',
        'is_final',
        'is_super',
        'is_interface',
        'is_abstract',
        'is_synthetic',
        'is_annotation',
        'is_enum'
    )
end
-- }}}

function jclass.for_name(canonical_name) -- {{{
    local _, zip= pcall(function()
        require 'zip'
    end)

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
-- }}}

-- TODO: modulize
local function flatten(list) -- {{{
    local flat= {}

    for _, e in ipairs(list) do
        if type(e) == 'table' then
            for _, ie in ipairs(flatten(e)) do
                table.insert(flat, ie)
            end
        else
            table.insert(flat, e)
        end
    end

    return flat
end
-- }}}

function jclass.classpath(...) -- {{{
    local classpaths= {...}

    if #(classpaths) == 0 then
        return jclass.attrs.classpaths or {}
    end

    jclass.attrs.classpaths= flatten(classpaths)
end
-- }}}

function jclass:package_name() -- {{{
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
-- }}}

function jclass:canonical_name() -- {{{
    local const_class= self:constant_pools()[self:raw().this_class]
    local name= self:index2string(const_class.name_index)
    local canonical_name= name:gsub('[/$]', '.')

    return canonical_name
end
-- }}}

function jclass:simple_name() -- {{{
    return self:canonical_name():match('%w+$')
end
-- }}}

function jclass:classes() -- {{{
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
-- }}}

function jclass:constructors() -- {{{
    local methods= iterators.make_iterator(self:raw().methods)
    local methods= iterators.transform(methods, function(input)
        return jmethod.new(self:constant_pools(), input)
    end)
    return iterators.filter(methods, function(input)
        return input:name() == '<init>' or input:name() == '<cinit>' or input:name() == '<clinit>'
    end)
end
-- }}}

function jclass:fields() -- {{{
    local fields= iterators.make_iterator(self:raw().fields)
    local fields= iterators.transform(fields, function(input)
        return jfield.new(self:constant_pools(), input)
    end)
    return fields
end
-- }}}

function jclass:methods() -- {{{
    local methods= iterators.make_iterator(self:raw().methods)
    local methods= iterators.transform(methods, function(input)
        return jmethod.new(self:constant_pools(), input)
    end)
    return iterators.filter(methods, function(input)
        return input:name() ~= '<init>' and input:name() ~= '<cinit>' and input:name() ~= '<clinit>'
    end)
end
-- }}}

function jclass:interfaces() -- {{{
    local interfaces= iterators.make_iterator(self:raw().interfaces)

    return iterators.transform(interfaces, function(input)
        local const_class= self:constant_pools()[input]

        return self:index2string(const_class.name_index)
    end)
end
-- }}}

function jclass:superclass() -- {{{
    if self:raw().super_class ~= 0 then
        local const_class= self:constant_pools()[self:raw().super_class]

        return self:index2string(const_class.name_index)
    else
        -- this_class == 'java.lang.Object'
        return nil
    end
end
-- }}}

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

this method will create a new jclass object from given filename.

=item B<jclass.for_name(canonical_name)>

TODO

=item B<jclass.classpath(...)>

get current classpath string of list.
or set new classpath string of list.

=back

=head2 PROVIDED METHODS

=over 4

=item B<jclass:package_name()>

returns package name for this class.
e.g. java.lang.Object => java.lang

=item B<jclass:canonical_name()>

returns canonical name for this class.
e.g. java.lang.Object => java.lang.Object

=item B<jclass:simple_name()>

returns simple name for this class.
e.g. java.lang.Object => Object

=item B<jclass:constructors()>

returns all constructors as jmethod this class has.

=item B<jclass:fields()>

returns all fields as jfield object this class has.

=item B<jclass:methods()>

returns all methods as jmethod object this class has.

=item B<jclass:classes()>

returns all innter classes as jclass object this class has.

=item B<jclass:interfaces()>

returns all implemented interface names.

=item B<jclass:superclass()>

returns super class name.

=item B<jclass:is_public()>

returns true if this class is public, otherwise false.

=item B<jclass:is_protected()>

returns true if this class is protected, otherwise false.

=item B<jclass:is_private()>

returns true if this class is private, otherwise false.

=item B<jclass:is_final()>

returns true if this class is final, otherwise false.

=item B<jclass:is_super()>

TODO

=item B<jclass:is_interface()>

returns true if this class is interface, otherwise false.

=item B<jclass:is_abstract()>

returns true if this class is abstract, otherwise false.

=item B<jclass:is_annotation()>

returns true if this class is annotation, otherwise false.

=item B<jclass:is_enum()>

returns true if this class is enum, otherwise false.

=back

=head1 AUTHOR

kamichidu - L<c.kamunagi@gmail.com>

=head1 LICENSE

see LICENSE file.

=cut
--]]
-- vim: fen: fdm=marker
