#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'

local class_file=  require 'raw.class_file'
local binary_file= require 'util.binary_file'

plan 'no_plan'

subtest('parse A.class', function()
    local file= binary_file.open('t/fixture/A.class')
    local cf= class_file.parse(file)

    ok(cf, 'can parse')

    file:close()
end)

done_testing()
