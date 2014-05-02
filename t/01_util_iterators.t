#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'

local iterators= require 'util.iterators'

plan 'no_plan'

subtest('iterators.make_iterator', function()
    local iterator= iterators.make_iterator({1, 2, 3})

    type_ok(iterator, 'function', 'iterator is a function')
    is(iterator(), 1, 'sequencial access')
    is(iterator(), 2, 'sequencial access')
    is(iterator(), 3, 'sequencial access')
    nok(iterator(), 'terminate')
end)

subtest('iterators.filter', function()
    local iterator= iterators.make_iterator({1, 2, 3, 4})
    local filtered= iterators.filter(iterator, function(e)
        return e % 2 == 0
    end)

    type_ok(filtered, 'function', 'always function')
    is(filtered(), 2, 'even number only')
    is(filtered(), 4, 'even number only')
    nok(filtered(), 'terminate')
end)

subtest('iterators.transform', function()
    local iterator= iterators.make_iterator({1, 2, 3})
    local transformed= iterators.transform(iterator, function(e)
        return e * 2
    end)

    type_ok(transformed, 'function', 'always function')
    is(transformed(), 2, 'twiced')
    is(transformed(), 4, 'twiced')
    is(transformed(), 6, 'twiced')
    nok(transformed(), 'terminate')
end)

subtest('iterators.find', function()
    local iterator= iterators.make_iterator({1, 2, 3})

    local function find_2(input)
        return input == 2
    end
    local function find_4(input)
        return input == 4
    end

    is(iterators.find(iterator, find_2), 2, 'found')
    nok(iterators.find(iterator, find_4), 'not found')
end)

done_testing()
