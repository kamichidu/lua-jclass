local prototype=    require 'prototype'
local access_flags= require 'raw.access_flags'
local parser=       require 'util.parser_factory'
local utf8=        require 'util.utf8'

local jmethod= prototype {
    default= prototype.assignment_copy,
    table=   prototype.deep_copy,
}

function jmethod:new(constant_pools, method_info)
    -- descriptor_info must be utf8_info
    local descriptor_info= constant_pools[method_info._descriptor_index]
    local descriptor= parser:parse_method_descriptor(utf8.decode(descriptor_info._bytes))

    local obj= setmetatable({}, {__index= accessible_object.new(method_info._access_flags)})

    function obj.name()
        local name_info= constant_pools[method_info._name_index]
        local s, c= utf8.decode(name_info._bytes)

        return s
    end

    function obj.return_type()
        return descriptor.return_type
    end

    function obj.parameter_types()
        return descriptor.parameter_types
    end

    return obj
end

return jmethod
--[[
=pod

=head1 NAME

jmethod - java class or instance method representation.

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 PROVIDED METHODS

=over 4

=item B<jmethod:name()>

=item B<jmethod:declared_annotations()>

=item B<jmethod:declaring_class()>

=item B<jmethod:exception_types()>

=item B<jmethod:parameter_types()>

=item B<jmethod:return_type()>

=item B<jmethod:type_parameters()>

=item B<jmethod:is_bridge()>

=item B<jmethod:is_synthetic()>

=item B<jmethod:is_var_args()>

default_value() XXX: annotation only

=back

=head1 AUTHOR

kamichidu - <c.kamunagi@gmail.com>

=head1 LICENSE

see `LICENSE' file.

=cut
--]]
