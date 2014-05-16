local prototype=    require 'prototype'
local access_flags= require 'raw.access_flags'
local parser=       require 'util.parser_factory'
local utf8=         require 'util.utf8'

local jfield= prototype {
    default= prototype.assignment_copy,
    table=   prototype.deep_copy,
}

jfield.attrs= {}

function jfield.new(constant_pools, field_info) -- {{{
    assert(constant_pools, 'ensure non-nil')
    assert(field_info, 'ensure non-nil')

    local obj= jfield:clone()

    obj.attrs.constant_pools= constant_pools
    obj.attrs.field_info=     field_info

    local flags= access_flags:clone()

    flags.access_flags= field_info.access_flags

    return obj:mixin(flags,
        'is_public',
        'is_private',
        'is_protected',
        'is_static',
        'is_final',
        'is_volatile',
        'is_transient',
        'is_synthetic',
        'is_enum'
    )
end
-- }}}

function jfield:name() -- {{{
    local const_utf8= self:constant_pools()[self:field_info().name_index]

    return utf8.decode(const_utf8.bytes)
end
-- }}}

function jfield:type() -- {{{
    local fdparser= parser.for_field_descriptor()

    local descriptor_info= self:constant_pools()[self:field_info().descriptor_index]
    local descriptor= fdparser:parse(utf8.decode(descriptor_info.bytes))

    return descriptor.type
end
-- }}}

-- utilities {{{
function jfield:constant_pools()
    return self.attrs.constant_pools
end

function jfield:field_info()
    return self.attrs.field_info
end
-- }}}

return jfield
--[[
=pod

=head1 NAME

jfield - java class or instance field representation.

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 PROVIDED METHODS

=over 4

=item B<jfield:name()>

returns this field name.

=item B<jfield:type()>

returns this field type.

=item B<jfield:is_public()>

returns true if this is public, otherwise false.

=item B<jfield:is_private()>

returns true if this is private, otherwise false.

=item B<jfield:is_protected()>

returns true if this is protected, otherwise false.

=item B<jfield:is_static()>

returns true if this is static, otherwise false.

=item B<jfield:is_final()>

returns true if this is final, otherwise false.

=item B<jfield:is_volatile()>

returns true if this is volatile, otherwise false.

=item B<jfield:is_transient()>

returns true if this is transient, otherwise false.

=item B<jfield:is_enum()>

returns true if this is enum type, otherwise false.

=back

=head1 AUTHOR

kamichidu - <c.kamunagi@gmail.com>

=head1 LICENSE

see `LICENSE' file.

=cut
--]]
-- vim:fen:fdm=marker
