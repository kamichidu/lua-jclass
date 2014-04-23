#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'
require 'parser'

plan 'no_plan'

is_deeply(parser.parse_field_descriptor('B')                    , {type = 'byte'})
is_deeply(parser.parse_field_descriptor('C')                    , {type = 'char'})
is_deeply(parser.parse_field_descriptor('D')                    , {type = 'double'})
is_deeply(parser.parse_field_descriptor('F')                    , {type = 'float'})
is_deeply(parser.parse_field_descriptor('I')                    , {type = 'int'})
is_deeply(parser.parse_field_descriptor('J')                    , {type = 'long'})
is_deeply(parser.parse_field_descriptor('Ljava/lang/Object;')   , {type = 'java.lang.Object'})
is_deeply(parser.parse_field_descriptor('S')                    , {type = 'short'})
is_deeply(parser.parse_field_descriptor('Z')                    , {type = 'boolean'})
is_deeply(parser.parse_field_descriptor('[Ljava/lang/Object;')  , {type = 'java.lang.Object[]'})
is_deeply(parser.parse_field_descriptor('[[Ljava/lang/Object;') , {type = 'java.lang.Object[][]'})

is_deeply(parser.parse_method_descriptor('()V')                                      , {return_type = 'void', parameter_types = {}})
is_deeply(parser.parse_method_descriptor('(I)V')                                     , {return_type = 'void', parameter_types = {'int'}})
is_deeply(parser.parse_method_descriptor('(IDLjava/lang/Thread;)Ljava/lang/Object;') , {return_type = 'java.lang.Object', parameter_types = {'int', 'double', 'java.lang.Thread'}})

done_testing()
