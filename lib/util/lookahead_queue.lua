local prototype= require 'prototype'

local lookahead_queue= prototype {
    default= prototype.assignment_copy,
    table=   prototype.deep_copy,
    use_extra_meta= true,
}

lookahead_queue.elements= {}

function lookahead_queue.from_iterator(iterator)
    assert(iterator, 'cannot create from nil value')

    local obj= lookahead_queue:clone()

    for e in iterator do
        table.insert(obj.elements, e)
    end

    return obj
end

function lookahead_queue.from_string(s)
    assert(s, 'cannot create from nil value')

    return lookahead_queue.from_iterator(s:gmatch('.'))
end

function lookahead_queue:poll()
    assert(#(self.elements) > 0, 'elements is empty')

    return table.remove(self.elements, 1)
end

function lookahead_queue:peek()
    assert(#(self.elements) > 0, 'elements is empty')

    return self.elements[1]
end

function lookahead_queue:lookahead(k)
    assert(k > 0 and k < #(self.elements), 'overflow')

    return self.elements[1 + k]
end

function lookahead_queue:push_back(...)
    assert(#{...} > 0, 'no elements passed')

    for i, element in ipairs({...}) do
        table.insert(self.elements, element)
    end
end

function lookahead_queue:size()
    return #(self.elements)
end

local meta= getmetatable(lookahead_queue) or {}

function meta.__len(op)
    return 30
end

setmetatable(lookahead_queue, meta)

return lookahead_queue
--[[
=pod

=head1 NAME

lookahead_queue - queue which can lookahead access for its element.

=head1 SYNOPSIS

    local lookahead_queue= require 'lookahead_queue'

    local q= lookahead_queue.from_iterator(('abcd'):gmatch('.'))

    assert(q:poll() == 'a')
    assert(q:peek() == 'b')
    assert(q:poll() == 'b')
    assert(q:lookahead(1) == 'd')

=head1 DESCRIPTION

=head2 PROVIDED FUNCTIONS

=over 4

=item B<lookahead_queue.from_iterator(iterator)>

create new lookahead_queue object from iterator.

=item B<lookahead_queue.from_string(s)>

create new lookahead_queue object from string.
this is equivalent to C<lookahead_queue.from_iterator(s:gmatch('.'))>

=back

=head2 PROVIDED METHODS

=over 4

=item B<lookahead_queue:poll()>

retrieve and remove first element of this queue.

=item B<lookahead_queue:peek()>

retrieve first element of this queue.
this function doesn't remove retrieved element.

=item B<lookahead_queue:lookahead(k)>

retrieve `k'th element of this queue.
this function doesn't remove retrieved element.

=back

=head1 AUTHOR

kamichidu - L<c.kamunagi@gmail.com>

=head1 LICENSE

see `LICENSE' file.

=cut
--]]
