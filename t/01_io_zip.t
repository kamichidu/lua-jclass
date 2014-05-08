#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'

local zip= require 'io.zip'

plan 'no_plan'

subtest('basic', function()
    local zfile= zip.open('./t/fixture/pack-only.jar')

    ok(zfile, 'open')
end)

done_testing()
