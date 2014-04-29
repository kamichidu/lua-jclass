#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'

local class_file=  require 'raw.class_file'
local byte_reader= require 'util.byte_reader'

plan 'no_plan'

subtest('parse A.class', function()
    local reader= byte_reader.open('t/fixture/A.class')
    local cf= class_file.parse(reader)

    ok(cf, 'can parse')

    reader:close()
end)

done_testing()
