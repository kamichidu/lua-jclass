local prototype=    require 'prototype'
local access_flags= require 'raw.access_flags'
local parser=       require 'util.parser_factory'
local utf8=        require 'util.utf8'

local jmethod= prototype {
    default= prototype.assignment_copy,
    table=   prototype.deep_copy,
}

jmethod.attrs= {}

function jmethod.new(constant_pools, method_info)
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

function jmethod:name()
    local const_utf8= self:constant_pools()[self:method_info().name_index]

    return utf8.decode(const_utf8.bytes)
end

function jmethod:annotations()
end

function jmethod:declaring_class()
end

function jmethod:exception_types()
end

function jmethod:parameter_types()
    local mdparser= parser.for_method_descriptor()

    local descriptor_info= self:constant_pools()[self:method_info().descriptor_index]
    local descriptor= mdparser:parse(utf8.decode(descriptor_info.bytes))

    return descriptor.parameter_types
end

function jmethod:return_type()
    local mdparser= parser.for_method_descriptor()

    local descriptor_info= self:constant_pools()[self:method_info().descriptor_index]
    local descriptor= mdparser:parse(utf8.decode(descriptor_info.bytes))

    return descriptor.return_type
end

function jmethod:type_parameters()
end

function jmethod:is_bridge()
end

function jmethod:is_var_args()
end

function jmethod:constant_pools()
    return self.attrs.constant_pools
end

function jmethod:method_info()
    return self.attrs.method_info
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

=item B<jmethod:annotations()>

=item B<jmethod:declaring_class()>

=item B<jmethod:exception_types()>

=item B<jmethod:parameter_types()>

=item B<jmethod:return_type()>

=item B<jmethod:type_parameters()>

=item B<jmethod:is_bridge()>

=item B<jmethod:is_var_args()>

default_value() XXX: annotation only

=back

=head1 AUTHOR

kamichidu - <c.kamunagi@gmail.com>

=head1 LICENSE

see `LICENSE' file.

=cut
--]]
