local prototype= require 'prototype'

local jannotation= prototype {
    default= prototype.assignment_copy,
    table=   prototype.deep_copy,
}

function jannotation:name()
end

return jannotation
--[[
=pod

=head1 NAME

jannotation - java annotation representation.

=head1 SYNOPSIS

=head1 DESCRIPTION

=head2 PROVIDED METHODS

=over 4

=item B<jannotation:default_value()>

=back

=head1 AUTHOR

kamichidu - <c.kamunagi@gmail.com>

=head1 LICENSE

see `LICENSE' file.

=cut
--]]
