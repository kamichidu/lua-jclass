local prototype=    require 'prototype'
local access_flags= require 'raw.access_flags'
local parser=       require 'util.parser_factory'
local youjo=        require 'util.youjo'

local jfield= prototype {
    default= prototype.assignment_copy,
    table=   prototype.deep_copy,
}

function jfield:new(constant_pools, field_info)
    local descriptor_info= constant_pools[field_info._descriptor_index]
    local descriptor= parser:parse_field_descriptor(youjo:decode_utf8(descriptor_info._bytes))

    local obj= setmetatable({}, {__index= accessible_object.new(field_info._access_flags)})

    function obj.name()
        local name_info= constant_pools[field_info._name_index]
        local s, c= youjo:decode_utf8(name_info._bytes)

        return s
    end

    function obj.type()
        return descriptor.type
    end

    return obj
end

return jfield
--[[
=pod

=head1 NAME

jfield - java class or instance field representation.

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 PROVIDED METHODS

=over 4

=item B<jfield:type()>

=item B<jfield:name()>

=item B<jfield:annotations()>

=item B<jfield:declared_annotations()>

=item B<jfield:declaring_class()>

=item B<jfield:is_enum_constant()>

=item B<jfield:is_synthetic()>

=back

=head1 AUTHOR

kamichidu - <c.kamunagi@gmail.com>

=head1 LICENSE

see `LICENSE' file.

=cut
--]]
