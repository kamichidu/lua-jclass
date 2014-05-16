local prototype=    require 'prototype'
local access_flags= require 'raw.access_flags'
local parser=       require 'util.parser_factory'
local utf8=         require 'util.utf8'

local jmethod= prototype {
    default= prototype.assignment_copy,
    table=   prototype.deep_copy,
}

jmethod.attrs= {}

function jmethod.new(constant_pools, method_info) -- {{{
    local obj= jmethod:clone()

    obj.attrs.constant_pools= constant_pools
    obj.attrs.method_info=    method_info

    local af= access_flags:clone()

    af.access_flags= method_info.access_flags

    return obj:mixin(af,
        'is_public',
        'is_private',
        'is_protected',
        'is_static',
        'is_final',
        'is_synchronized',
        'is_bridge',
        'is_varargs',
        'is_native',
        'is_abstract',
        'is_strict',
        'is_synthetic'
    )
end
-- }}}

function jmethod:name() -- {{{
    local const_utf8= self:constant_pools()[self:method_info().name_index]

    return utf8.decode(const_utf8.bytes)
end
-- }}}

function jmethod:return_type() -- {{{
    local mdparser= parser.for_method_descriptor()

    local descriptor_info= self:constant_pools()[self:method_info().descriptor_index]
    local descriptor= mdparser:parse(utf8.decode(descriptor_info.bytes))

    return descriptor.return_type
end
-- }}}

function jmethod:parameter_types() -- {{{
    local mdparser= parser.for_method_descriptor()

    local descriptor_info= self:constant_pools()[self:method_info().descriptor_index]
    local descriptor= mdparser:parse(utf8.decode(descriptor_info.bytes))

    return descriptor.parameter_types
end
-- }}}

function jmethod:exception_types() -- {{{
end
-- }}}

-- utilities {{{
function jmethod:constant_pools()
    return self.attrs.constant_pools
end

function jmethod:method_info()
    return self.attrs.method_info
end
-- }}}

return jmethod
--[[
=pod

=head1 NAME

jmethod - java class or instance method representation.

=head2 PROVIDED METHODS

=over 4

=item B<jmethod:name()>

returns method name.

=item B<jmethod:return_type()>

returns method return type name.

=item B<jmethod:parameter_types()>

returns parameter type names.

=item B<jmethod:exception_types()>

returns exception type names is declarated on throws clause.

=item B<jmethod:is_public()>

returns true if this is public scoped, otherwise false.

=item B<jmethod:is_protected()>

returns true if this is protected scoped, otherwise false.

=item B<jmethod:is_private()>

returns true if this is private scoped, otherwise false.

=item B<jmethod:is_static()>

returns true if this is static method, otherwise false.

=item B<jmethod:is_final()>

returns true if this is final, otherwise false.

=item B<jmethod:is_synchronized()>

returns true if this has synchronized modifier, otherwise false.

=item B<jmethod:is_varargs()>

returns true if this is variadic arguments method, otherwise false.

=item B<jmethod:is_native()>

returns true if this is native method, otherwise false.

=item B<jmethod:is_abstract()>

returns true if this is abstract method, otherwise false.

=back

=head1 AUTHOR

kamichidu - <c.kamunagi@gmail.com>

=head1 LICENSE

see `LICENSE' file.

=cut
--]]
-- vim:fen:fdm=marker
