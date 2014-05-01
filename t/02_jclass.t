#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'

local jclass= require 'jclass'

plan('no_plan')

subtest('class', function()
    local jc= jclass.parse_file('t/fixture/java/util/Map.class')

    is(jc:package_name()   , 'java.util'     , 'package name')
    is(jc:canonical_name() , 'java.util.Map' , 'canonical name')
    is(jc:simple_name()    , 'Map'           , 'simple name')

    local classes= jc:declared_classes()
    type_ok(classes, 'table')
    for i, class in ipairs(classes) do
        print(class)
    end
end)

done_testing()