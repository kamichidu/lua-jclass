#!/usr/bin/env lua
-- vim: ft=lua
package.path= './lib/?.lua;' .. package.path

require 'Test.More'

local zip= require 'io.zip'

plan 'no_plan'

subtest('basic', function()
    local zfile, err= zip.open('./t/fixture/pack-only.jar')

    if not zfile then
        fail(err)
    end
end)

done_testing()
