#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'

local bitwise= require 'util.bitwise'

plan 'no_plan'

subtest('bitwise.band', function()
    is(bitwise.band(0xff, 0x00), 0x00)
    is(bitwise.band(0xff, 0xf0), 0xf0)
end)

subtest('bitwise.bnot', function()
    is(bitwise.bnot(0xffffffff), 0x00000000)
    is(bitwise.bnot(0x00000000), 0xffffffff)
end)

subtest('bitwise.bor', function()
    is(bitwise.bor(0xff, 0x00), 0xff)
    is(bitwise.bor(0xf0, 0x0f), 0xff)
end)

subtest('bitwise.bxor', function()
    is(bitwise.bxor(0xff, 0xff), 0x00)
    is(bitwise.bxor(0xf0, 0x00), 0xf0)
end)

subtest('bitwise.lshift', function()
    is(bitwise.lshift(0x01, 4), 0x10)
end)

subtest('bitwise.rshift', function()
    is(bitwise.rshift(0x10, 4), 0x01)
end)

done_testing()
