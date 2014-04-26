#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'

local lookahead_queue= require 'util.lookahead_queue'

plan 'no_plan'

subtest('from_iterator', function()
    local q= lookahead_queue.from_iterator(('abcd'):gmatch('.'))

    is(q:poll(), 'a')
    is(q:peek(), 'b')
    is(q:poll(), 'b')
    is(q:lookahead(1), 'd')
end)

subtest('from_string', function()
    local q= lookahead_queue.from_string('abcd')

    is(q:poll(), 'a')
    is(q:peek(), 'b')
    is(q:poll(), 'b')
    is(q:lookahead(1), 'd')
end)

done_testing()
