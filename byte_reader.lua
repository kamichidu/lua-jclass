require 'youjo'

byte_reader= {}

function byte_reader.new(filename)
    local obj= {
        _fh= io.open(filename, 'rb'),
        _buffer= {},
        _buf_size= 4 * 1024,
    }

    if not obj._fh then
        error(string.format('file open failed: %s', filename))
    end

    -- http://stackoverflow.com/questions/16506683/in-lua-how-should-i-read-a-file-into-an-array-of-bytes
    function obj.bytes(n)
        if n == 0 then
            return {}
        end

        local bytes= {}

        print('buffer size is ' .. #(obj._buffer))
        if #(obj._buffer) > 0 then
            while #(obj._buffer) > 0 do
                bytes[#bytes + 1]= table.remove(obj._buffer, 1)

                if #bytes == n then
                    return bytes
                end
            end
            for i, v in ipairs(obj.bytes(n - #bytes)) do
                bytes[#bytes + 1]= v
            end
            return bytes
            -- while #(bytes) < n and #(obj._buffer) > 0 do
            --     local byte= table.remove(obj._buffer, 1)

            --     bytes[#bytes + 1]= byte
            -- end

            -- if #bytes == n then
            --     youjo.say('byte_reader return', bytes)
            --     return bytes
            -- else
            --     for i, v in ipairs(obj.bytes(n - #bytes)) do
            --         bytes[#bytes + 1]= v
            --     end

            --     youjo.say('byte_reader return', bytes)
            --     return bytes
            -- end
        end

        print('read from file')
        local buf= obj._fh:read(obj._buf_size)

        for c in (buf or ''):gmatch('.') do
            obj._buffer[#(obj._buffer) + 1]= c:byte()
        end

        if #(obj._buffer) > 0 then
            youjo.say('byte_reader return', bytes)
            return obj.bytes(n)
        else
            error(string.format('L41'))
        end
    end

    function obj.int32()
        local bytes= obj.bytes(4)

        if not bytes or #bytes == 0 then
            error(string.format('L49'))
        end

        return bit32.bor(
            bit32.lshift(bytes[1], 24),
            bit32.lshift(bytes[2], 16),
            bit32.lshift(bytes[3], 8),
            bit32.lshift(bytes[4], 0)
        )
    end

    function obj.int16()
        local bytes= obj.bytes(2)

        if not bytes or #bytes == 0 then
            error(string.format('L64'))
        end

        return bit32.bor(
            bit32.lshift(bytes[1], 8),
            bit32.lshift(bytes[2], 0)
        )
    end

    function obj.int8()
        local bytes= obj.bytes(1)

        if not bytes or #bytes == 0 then
            error(string.format('L77'))
        end

        return bytes[1]
    end

    function obj.close()
        obj._fh:close()
    end

    return obj
end
