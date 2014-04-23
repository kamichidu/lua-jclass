#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'

local modules= {
    'jclass',
    'jfield',
    'jmethod',
    'raw.accessible_object',
    'raw.attribute_info',
    'raw.class_file',
    'raw.constant_pool_info',
    'raw.field_info',
    'raw.method_info',
    'util.bitwise',
    'util.byte_reader',
    'util.parser',
    'util.youjo',
}

plan(#modules)

for i, module in ipairs(modules) do
    require_ok(module)
end

done_testing()
