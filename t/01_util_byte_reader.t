#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'

local byte_reader= require 'util.byte_reader'

function s2b(s)
    local b= {}
    for c in s:gmatch('.') do
        table.insert(b, c:byte())
    end
    return b
end

plan 'no_plan'

subtest('read(1)', function()
    local reader= byte_reader.open('t/fixture/bytes_00')

    ok(reader, 'try to open')

    local expects= 'abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789'

    for expect_char in expects:gmatch('.') do
        is_deeply(reader:read(1), {expect_char:byte()})
    end

    reader:close()
end)

subtest('read(5)', function()
    local reader= byte_reader.open('t/fixture/bytes_00')

    ok(reader, 'try to open')

    local expects= 'abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789'

    for expect_chars in expects:gmatch('.....') do
        is_deeply(reader:read(5), s2b(expect_chars))
    end

    reader:close()
end)

done_testing()
