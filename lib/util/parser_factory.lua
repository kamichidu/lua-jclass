local prototype= require 'prototype'

local parser_factory= prototype {
    default= prototype.assignment_copy,
}

function parser_factory.for_field_descriptor()
    return require('util.parser.field_descriptor')
end

function parser_factory.for_method_descriptor()
    return require('util.parser.method_descriptor')
end

function parser_factory.for_signature()
    return require('util.parser.signature')
end

return parser_factory
