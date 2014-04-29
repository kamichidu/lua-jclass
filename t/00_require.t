#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'

local modules= {
    'jclass',
    'jfield',
    'jmethod',
    'raw.access_flags',
    'raw.attribute_info',
    'raw.class_file',
    'raw.cp_info',
    'raw.field_info',
    'raw.method_info',
    'util.bitwise',
    'util.byte_reader',
    'util.lookahead_queue',
    'util.parser_factory',
    'util.parser.field_descriptor',
    'util.parser.method_descriptor',
    'util.parser.signature',
    'util.youjo',
}

plan('no_plan')

for i, module in ipairs(modules) do
    require_ok(module)
    type_ok(require(module), 'table', 'require(' .. module .. ') should return table')
end

done_testing()
