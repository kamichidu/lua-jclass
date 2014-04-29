local prototype= require 'prototype'

local signature= prototype {
    default= prototype.no_copy,
    table=   prototype.deep_copy,
}

--
-- FormalTypeParameters:
--   < FormalTypeParameter+ >
--
function signature:formal_type_parameters(s)
    s:next()
    assert(s:current() == '<')

    self:formal_type_parameter(s)

    s:next()
    assert(s:current() == '>')
end

--
-- FormalTypeParameter:
--   Identifier ClassBound InterfaceBound*
--
function signature:formal_type_parameter(s)
    self:identifier(s)
    self:class_bound(s)
    self:interface_bound(s)
end

--
--
--
function signature:identifier(s)
    local identifier= {}

    while string.find(s:current(), '[a-zA-Z_$]') do
        identifier[#(identifier) + 1]= s:current()
    end
end

--
-- ClassBound:
--   : FieldTypeSignature?
--
function signature:class_bound(s)
end

--
-- InterfaceBound:
--   : FieldTypeSignature
--
function signature:interface_bound(s)
end

--
-- SuperclassSignature:
--   ClassTypeSignature
--
function signature:superclass_signature(s)
end

--
-- SuperinterfaceSignature:
--   ClassTypeSignature
--
function signature:superinterface_signature(s)
end

return signature
--[[
=pod

=head1 NAME

signature - signature string parser

=head1 VERSION

still alpha ver.

=head1 SYSNOPSIS

    local parser= require 'util.parser.signature'

    parser:parse('')

=head1 DESCRIPTION

signature is a parser to parse basic java signature.

=head2 PROVIDED OBJECT

signature provides a L<prototype> object.

=head2 PROVIDED FUNCTIONS

=over 4

=item B<signature.parse(string)>

=back

=head1 AUTHOR

kamichidu - L<c.kamunagi@gmail.com>

=head1 LICENSE

see LICENSE file.

=cut
--]]
