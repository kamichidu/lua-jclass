#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'

local modules= {
    'accessible_object',
    'attribute_info',
    'bitwise',
    'byte_reader',
    'class_file',
    'constant_pool_info',
    'field_info',
    'jclass',
    'jfield',
    'jmethod',
    'method_info',
    'parser',
    'youjo',
}

plan(#modules)

for i, module in ipairs(modules) do
    require_ok(module)
end

done_testing()
