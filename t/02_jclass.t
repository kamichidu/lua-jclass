#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'

local jclass= require 'jclass'

plan('no_plan')

subtest('jclass.parse_file', function()
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

subtest('jclass.classpath', function()
    jclass.classpath(nil)
    is_deeply(jclass.classpath(), {})

    jclass.classpath({})
    is_deeply(jclass.classpath(), {})

    jclass.classpath('hoge', 'fuga')
    is_deeply(jclass.classpath(), {'hoge', 'fuga'})

    jclass.classpath({'hoge', 'fuga'})
    is_deeply(jclass.classpath(), {'hoge', 'fuga'})
end)

subtest('jclass.for_name', function()
    jclass.classpath('./t/fixture/compress.jar')

    local jc= jclass.for_name('java.util.Map')

    ok(jc)

    is(jc:package_name()   , 'java.util')
    is(jc:canonical_name() , 'java.util.Map')
    is(jc:simple_name()    , 'Map')

    type_ok(jc:constructors() , 'function')
    type_ok(jc:fields()       , 'function')
    type_ok(jc:methods()      , 'function')
    type_ok(jc:classes()      , 'function')
    type_ok(jc:interfaces()   , 'function')

    ok(jc:is_public())
    nok(jc:is_protected())
    nok(jc:is_private())
    nok(jc:is_final())
    nok(jc:is_super())
    ok(jc:is_interface())
    ok(jc:is_abstract())
    nok(jc:is_annotation())
    nok(jc:is_enum())
end)

done_testing()
