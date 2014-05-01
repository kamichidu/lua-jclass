#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'

local bitwise= require 'util.bitwise'

plan 'no_plan'

subtest('bitwise.band', function()
    is(bitwise.band(0xffffffff, 0x00000000), 0x00000000, '0xffffffff & 0x00000000 = 0x00000000')
    is(bitwise.band(0x00000000, 0xffffffff), 0x00000000, '0x00000000 & 0xffffffff = 0x00000000')
    is(bitwise.band(0xffffffff, 0xffffffff), 0xffffffff, '0xffffffff & 0xffffffff = 0xffffffff')
    is(bitwise.band(0x00000000, 0x00000000), 0x00000000, '0x00000000 & 0x00000000 = 0x00000000')
    is(bitwise.band(0x80000000, 0x80000000), 0x80000000, '0x80000000 & 0x80000000 = 0x80000000')
end)

subtest('bitwise.bnot', function()
    is(bitwise.bnot(0xffffffff), 0x00000000, '~0xffffffff = 0x00000000')
    is(bitwise.bnot(0x00000000), 0xffffffff, '~0x00000000 = 0xffffffff')
end)

subtest('bitwise.bor', function()
    is(bitwise.bor(0xff00ff00, 0x00ff00ff), 0xffffffff, '0xff00ff00 | 0x00ff00ff = 0xffffffff')
    is(bitwise.bor(0xffffffff, 0x00000000), 0xffffffff, '0xffffffff | 0x00000000 = 0xffffffff')
    is(bitwise.bor(0xffffffff, 0xffffffff), 0xffffffff, '0xffffffff | 0xffffffff = 0xffffffff')
    is(bitwise.bor(0x00000000, 0x00000000), 0x00000000, '0x00000000 | 0x00000000 = 0x00000000')
    is(bitwise.bor(0x80000000, 0x00000000), 0x80000000, '0x80000000 | 0x00000000 = 0x80000000')
end)

subtest('bitwise.lshift', function()
    is(bitwise.lshift(0x00000001,  8), 0x00000100, '0x00000001 <<  8 = 0x00000100')
    is(bitwise.lshift(0x00000001, 16), 0x00010000, '0x00000001 << 16 = 0x00010000')
    is(bitwise.lshift(0x00000001, 24), 0x01000000, '0x00000001 << 24 = 0x01000000')
    is(bitwise.lshift(0x00000080, 24), 0x80000000, '0x00000080 << 24 = 0x80000000')
end)

done_testing()
