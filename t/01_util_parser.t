#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'

local parser_factory= require 'util.parser_factory'

plan 'no_plan'

subtest('field descriptor parser', function()
    local parser= parser_factory.for_field_descriptor()

    is_deeply(parser:parse('B')                    , {type = 'byte'})
    is_deeply(parser:parse('C')                    , {type = 'char'})
    is_deeply(parser:parse('D')                    , {type = 'double'})
    is_deeply(parser:parse('F')                    , {type = 'float'})
    is_deeply(parser:parse('I')                    , {type = 'int'})
    is_deeply(parser:parse('J')                    , {type = 'long'})
    is_deeply(parser:parse('Ljava/lang/Object;')   , {type = 'java.lang.Object'})
    is_deeply(parser:parse('S')                    , {type = 'short'})
    is_deeply(parser:parse('Z')                    , {type = 'boolean'})
    is_deeply(parser:parse('[Ljava/lang/Object;')  , {type = 'java.lang.Object[]'})
    is_deeply(parser:parse('[[Ljava/lang/Object;') , {type = 'java.lang.Object[][]'})
end)

subtest('method descriptor parser', function()
    local parser= parser_factory.for_method_descriptor()

    is_deeply(parser:parse('()V')                                      , {return_type = 'void', parameter_types = {}})
    is_deeply(parser:parse('(I)V')                                     , {return_type = 'void', parameter_types = {'int'}})
    is_deeply(parser:parse('(IDLjava/lang/Thread;)Ljava/lang/Object;') , {return_type = 'java.lang.Object', parameter_types = {'int', 'double', 'java.lang.Thread'}})
end)

subtest('signature parser', function()
    skip('not implemented yet')
end)

done_testing()
