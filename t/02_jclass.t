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

    local classes= jc:classes()
    type_ok(classes, 'function')
    for class in classes do
        print(class)
    end
end)

subtest('jclass.classpath()', function()
    jclass.classpath(nil)
    is_deeply(jclass.classpath(), {})

    jclass.classpath({})
    is_deeply(jclass.classpath(), {})

    jclass.classpath('hoge', 'fuga')
    is_deeply(jclass.classpath(), {'hoge', 'fuga'})

    jclass.classpath({'hoge', 'fuga'})
    is_deeply(jclass.classpath(), {'hoge', 'fuga'})
end)

done_testing()
