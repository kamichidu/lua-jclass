local prototype= require 'prototype'
local bitwise=   require 'util.bitwise'

local binary_file= prototype {
    default= prototype.assignment_copy,
}

-- associated file handle
binary_file.fh= nil

function binary_file.open(filename)
    local fh, err= io.open(filename, 'rb')

    if not fh then
        return nil, err
    end

    return binary_file.attach(fh)
end

function binary_file.attach(file)
    local obj= binary_file:clone()

    obj.fh= file

    return obj
end

-- `*n' delegate
-- `*a' delegate
-- `*l' delegate
-- `*L' delegate
-- {number} return {number} bytes as list
-- `u1' return next 1 byte into single number
-- `u2' return next 2 bytes into single number
-- `u4' return next 4 bytes into single number
function binary_file:read(...)
    local fmt= ({...})[1]

    if fmt == nil then
        return self.fh:read()
    elseif type(fmt) == 'string' and fmt:find('^u%d+$') then
        local _, _, nbytes= fmt:find('^u(%d+)$')

        nbytes= 0 + nbytes

        assert(nbytes == 1 or nbytes == 2 or nbytes == 4,
            "supported only `u1' or `u2' or `u4', but got " .. nbytes)

        local s= self.fh:read(nbytes)
        local shiftbits= 8 * (nbytes - 1)
        local read= 0x00000000

        for c in s:gmatch('.') do
            read= bitwise.bor(read, bitwise.lshift(c:byte(), shiftbits))

            shiftbits= shiftbits - 8
        end

        return read
    elseif type(fmt) == 'number' then
        local s= '' .. self.fh:read(fmt)
        local bytes= {}

        for c in s:gmatch('.') do
            table.insert(bytes, c:byte())
        end

        return bytes
    else
        return self.fh:read(fmt)
    end
end

function binary_file:close()
    self.fh:close()
end

function binary_file:seek(whence, offset)
    self.fh:seek(whence, offset)
end

return binary_file
--[[
=pod

=head1 NAME

binary_file - file handle object which support byte based reading

=head1 SYNOPSIS

    local binary_file= require 'util.binary_file'

    local file= binary_file.open('path/to/file')

    print('read 1 byte',  reader:read(1))
    print('read 2 bytes', reader:read(2))
    print('read 4 bytes', reader:read(4))

    print('read 1 byte',  reader:read('u1'))
    print('read 2 bytes', reader:read('u2'))
    print('read 4 bytes', reader:read('u4'))

=head1 DESCRIPTION

=head2 PROVIDED FUNCTIONS

=over 4

=item B<binary_file.open(filename)>

=item B<binary_file.attach(file)>

=back

=head2 PROVIDED METHODS

=over 4

=item B<reader:read(...)>

=item B<reader:close()>

=back

=cut
--]]
-- vim:fen:fdm=marker
