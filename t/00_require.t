#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'

local modules= {
    'jannotation',
    'jclass',
    'jfield',
    'jmethod',
    'raw.access_flags',
    'raw.attribute.code',
    'raw.attribute.constant_value',
    'raw.attribute.deprecated',
    'raw.attribute.enclosing_method',
    'raw.attribute.exceptions',
    'raw.attribute.inner_classes',
    'raw.attribute.local_variable_table',
    'raw.attribute.local_variable_type_table',
    'raw.attribute.signature',
    'raw.attribute_info',
    'raw.class_file',
    'raw.constant.class',
    'raw.constant.double',
    'raw.constant.fieldref',
    'raw.constant.float',
    'raw.constant.integer',
    'raw.constant.interface_methodref',
    'raw.constant.invoke_dynamic',
    'raw.constant.long',
    'raw.constant.method_handle',
    'raw.constant.method_type',
    'raw.constant.methodref',
    'raw.constant.name_and_type',
    'raw.constant.string',
    'raw.constant.utf8',
    'raw.cp_info',
    'raw.field_info',
    'raw.method_info',
    'util.bitwise',
    'util.byte_reader',
    'util.iterators',
    'util.lookahead_queue',
    'util.parser.class_type_signature',
    'util.parser.field_descriptor',
    'util.parser.field_type_signature',
    'util.parser.method_descriptor',
    'util.parser.method_type_signature',
    'util.parser_factory',
    'util.utf8',
}

plan('no_plan')

for i, module in ipairs(modules) do
    require_ok(module)
    type_ok(require(module), 'table', 'require(' .. module .. ') should return table')
end

done_testing()
