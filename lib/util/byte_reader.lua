local prototype=       require 'prototype'
local bitwise=         require 'util.bitwise'
local lookahead_queue= require 'util.lookahead_queue'

local byte_reader= prototype {
    default= prototype.assignment_copy,
    table=   prototype.deep_copy,
}

-- associated file handle
byte_reader.fh= nil
-- buffer for read
byte_reader.buffer= lookahead_queue:clone()
-- buffer size
byte_reader.bufsize= 4 * 1024

function byte_reader.open(filename)
    local fh= io.open(filename, 'rb')

    if not fh then
        return nil
    end

    local obj= byte_reader:clone()

    obj.fh= fh

    return obj
end

function byte_reader:read(nbytes)
    assert(nbytes > 0, 'expects positive integer')

    -- consume buffer
    if self.buffer:size() >= nbytes then
        local bytes= {}

        while #(bytes) < nbytes do
            table.insert(bytes, self.buffer:poll())
        end

        return bytes
    end

    -- http://stackoverflow.com/questions/16506683/in-lua-how-should-i-read-a-file-into-an-array-of-bytes
    local str= self.fh:read(self.bufsize)

    assert(str, 'read failed')

    for c in str:gmatch('.') do
        self.buffer:push_back(c:byte())
    end

    return self:read(nbytes)
end

function byte_reader:read_int32()
    local bytes= self:read(4)

    assert(#(bytes) == 4, 'cannot read 4 bytes')

    return bitwise.bor(
        bitwise.lshift(bytes[1], 24),
        bitwise.lshift(bytes[2], 16),
        bitwise.lshift(bytes[3], 8),
        bitwise.lshift(bytes[4], 0)
    )
end

function byte_reader:read_int16()
    local bytes= self:read(2)

    assert(#(bytes) == 2, 'cannot read 2 bytes')

    return bitwise.bor(
        bitwise.lshift(bytes[1], 8),
        bitwise.lshift(bytes[2], 0)
    )
end

function byte_reader:read_int8()
    local bytes= self:read(1)

    assert(#(bytes) == 1, 'cannot read 1 bytes')

    return bytes[1]
end

function byte_reader:close()
    assert(self.fh)

    self.fh:close()
    self.fh= nil
end

return byte_reader
--[[
=pod

=head1 NAME

byte_reader - byte based file reader

=head1 SYNOPSIS

    local byte_reader= require 'util.byte_reader'

    local reader= byte_reader.open('path/to/file')

    print('read 1 byte', reader:read(1))
    print('read 2 bytes', reader:read(2))
    print('read 4 bytes', reader:read(4))

=head1 DESCRIPTION

=head2 PROVIDED FUNCTIONS

=over 4

=item B<byte_reader.open(filename)>

=back

=head2 PROVIDED METHODS

=over 4

=item B<reader:read(nbytes)>

=item B<reader:close()>

=back

=cut
--]]
-- vim:fen:fdm=marker
