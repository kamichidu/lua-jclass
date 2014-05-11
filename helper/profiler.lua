local prototype= require 'prototype'

-- stack (helper module) {{{
local stack= prototype {
    default= prototype.assignment_copy,
    table=   prototype.deep_copy,
}

stack.elements= {}

function stack:push(e)
    assert(e, 'ensure non-nil')

    table.insert(self.elements, e)
end

function stack:pop()
    assert(#(self.elements) > 0, 'ensure to have elements')

    return table.remove(self.elements)
end

function stack:peek()
    assert(#(self.elements) > 0, 'ensure to have elements')

    return self.elements[#(self.elements)]
end

function stack:clear()
    self.elements= {}
end

function stack:size()
    return #(self.elements)
end
-- }}}

-- helper function {{{
local function make_comparator(comparators)
    return function(lhs, rhs)
        for _, comparator in pairs(comparators) do
            if comparator(lhs, rhs) then
                return true
            end
        end

        return false
    end
end
-- }}}

local profiler= prototype {
    default= prototype.no_copy,
}

profiler.call_stack= stack:clone()
profiler.func_info= {}
profiler.tracer= {
    on_call=      {},
    on_tail_call= {},
    on_return=    {},
    on_line=      {},
    on_count=     {},
}
profiler.sorter= {}
profiler.reporter= {}

if socket then
    profiler.clock= socket.gettime
else
    profiler.clock= os.clock
end

function profiler.start()
    profiler.call_stack:clear()
    profiler.func_info= {}

    debug.sethook(profiler.trace, 'cr', 0)
end

function profiler.stop()
    debug.sethook()

    local prof_results= {}
    for k, t in pairs(profiler.func_info) do
        table.insert(prof_results, {
            func_name= k,
            call_count= (t.call_count or 0),
            spent_time= (t.spent_time or 0),
        })
    end

    table.sort(prof_results, make_comparator(profiler.sorter))

    -- report using reporter module
    for _, report in pairs(profiler.reporter) do
        report(prof_results)
    end

    profiler.call_stack:clear()
    profiler.func_info= {}
end

function profiler.trace(event)
    for _, tracer in pairs(profiler.tracer['on_' .. event:gsub('%s', '_')]) do
        tracer()
    end
end

-- tracer module {{{
function profiler.tracer.on_call.standard()
    local info= debug.getinfo(3)
    local func_name= info.name or '<<unknown>>'

    profiler.call_stack:push({
        func_name= func_name,
        call_at=   profiler.clock(),
    })

    local func_info= profiler.func_info[func_name] or {}

    func_info.call_count= (func_info.call_count or 0) + 1

    profiler.func_info[func_name]= func_info
end

function profiler.tracer.on_return.standard()
    if not (profiler.call_stack:size() > 0) then
        return
    end

    local top= profiler.call_stack:pop()

    local func_info= profiler.func_info[top.func_name]

    func_info.spent_time= (func_info.spent_time or 0) + profiler.clock() - top.call_at

    profiler.func_info[top.func_name]= func_info
end
-- }}}

-- sorter module {{{
function profiler.sorter.spent_time(lhs, rhs)
    return (lhs.spent_time or 0) < (rhs.spent_time or 0)
end
-- }}}

-- reporter module {{{
function profiler.reporter.tsv(prof_info)
    assert(prof_info, 'ensure non-nil')

    print(table.concat({'CALL COUNT', 'SPENT TIME', 'FUNC NAME'}, '\t'))
    for rank, info in ipairs(prof_info) do
        print(table.concat({info.call_count, info.spent_time, info.func_name}, '\t'))
    end
end
-- }}}

return profiler
--[[
=pod

=head1 NAME

profiler - profiler for lua

=head1 SYNOPSIS

    local profiler= require 'profiler'

    profiler.start()

    ... do something ...

    profiler.stop()

=head1 DESCRIPTION

=head2 PROVIDED FUNCTIONS

=over 4

=item B<profiler.start()>

start profiling.

=item B<profiler.stop()>

stop profiling and report result.

=back

=head2 CUSTOMIZATION

this section describe how to custom this profiler's behaviour.
this module has 3 main sub-modules.

=over 4

=item B<profiler.reporter>

reporter sub-module is used for reporting profiling results.
you can write some function for customization.

e.g.
    -- clear old reporters
    profiler.reporter= {}

    -- regist your custom reporter
    -- it takes a table which has profiling results
    -- keys are 'func_name', 'spent_time', 'call_count'
    function profiler.reporter.custom_reporter(profile_info)
    end

=item B<profiler.tracer>

=item B<profiler.sorter>

=back

=head1 AUTHOR

kamichidu - <c.kamunagi@gmail.com>

=head1 LICENSE

The MIT License (MIT)

Copyright (c) 2014 kamichidu

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=cut
--]]
-- vim:ft=lua:et:ts=4:fen:fdm=marker
