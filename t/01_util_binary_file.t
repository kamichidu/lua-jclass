#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'

local binary_file= require 'util.binary_file'

function s2b(s)
    local b= {}
    for c in s:gmatch('.') do
        table.insert(b, c:byte())
    end
    return b
end

plan 'no_plan'

subtest('read(1)', function()
    local file= binary_file.open('t/fixture/bytes_00')

    ok(file, 'try to open')

    local expects= 'abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789'

    for expect_char in expects:gmatch('.') do
        is_deeply(file:read(1), {expect_char:byte()})
    end

    file:close()
end)

subtest('read(5)', function()
    local file= binary_file.open('t/fixture/bytes_00')

    ok(file, 'try to open')

    local expects= 'abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789'

    for expect_chars in expects:gmatch('.....') do
        is_deeply(file:read(5), s2b(expect_chars))
    end

    file:close()
end)

subtest("read('u1')", function()
    local file= binary_file.open('t/fixture/bytes_00')

    ok(file, 'try to open')

    local expects= 'abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789'

    for expect_char in expects:gmatch('.') do
        is(file:read('u1'), expect_char:byte())
    end

    file:close()
end)

subtest("read('u2')", function()
    local bitwise= require 'util.bitwise'

    local file= binary_file.open('t/fixture/bytes_00')

    ok(file, 'try to open')

    local expects= 'abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789'

    for expect_chars in expects:gmatch('..') do
        local high= expect_chars:sub(1, 1)
        local low=  expect_chars:sub(2, 2)

        is(file:read('u2'), bitwise.bor(bitwise.lshift(high:byte(), 8), low:byte()))
    end

    file:close()
end)

subtest("read('u4')", function()
    local bitwise= require 'util.bitwise'

    local file= binary_file.open('t/fixture/bytes_00')

    ok(file, 'try to open')

    local expects= 'abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ 0123456789'

    for expect_chars in expects:gmatch('....') do
        local b0= expect_chars:sub(1, 1)
        local b1= expect_chars:sub(2, 2)
        local b2= expect_chars:sub(3, 3)
        local b3= expect_chars:sub(4, 4)

        is(file:read('u4'), bitwise.bor(
            bitwise.lshift(b0:byte(), 24),
            bitwise.lshift(b1:byte(), 16),
            bitwise.lshift(b2:byte(), 8),
            bitwise.lshift(b3:byte(), 0)
        ))
    end

    file:close()
end)

done_testing()
