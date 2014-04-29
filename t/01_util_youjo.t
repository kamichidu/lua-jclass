#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'

local youjo= require 'util.youjo'

plan 'no_plan'

subtest('make_iterator(list)', function()
    local list= {1, 2, 3, 4, 5}
    local itr= youjo:make_iterator(list)

    is_deeply(list, {1, 2, 3, 4, 5})
    type_ok(itr, 'function')

    for e in itr do
        is(e, table.remove(list, 1))
    end
end)

done_testing()
