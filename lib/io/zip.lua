local prototype=   require 'prototype'
local binary_file= require 'util.binary_file'
local utf8=        require 'util.utf8'

local zfile= prototype {
    default= prototype.assignment_copy,
}

zfile.files= {}

function zfile:files()
end

function zfile:close()
end

local zip= prototype {
    default= prototype.assignment_copy,
}

zip.compression_method= {}

zip.compression_method.no_compression= 0 -- The file is stored (no compression)
zip.compression_method.XXX= 1 -- The file is Shrunk
zip.compression_method.XXX= 2 -- The file is Reduced with compression factor 1
zip.compression_method.XXX= 3 -- The file is Reduced with compression factor 2
zip.compression_method.XXX= 4 -- The file is Reduced with compression factor 3
zip.compression_method.XXX= 5 -- The file is Reduced with compression factor 4
zip.compression_method.XXX= 6 -- The file is Imploded
zip.compression_method.XXX= 7 -- Reserved for Tokenizing compression algorithm
zip.compression_method.XXX= 8 -- The file is Deflated

local pretty= function(tbl)
    local left_margin= 0
    for k, _ in pairs(tbl) do
        left_margin= math.max(left_margin, k:len())
    end

    left_margin= left_margin + 1

    local keys= {}

    for k, _ in pairs(tbl) do
        table.insert(keys, k)
    end

    table.sort(keys)

    for _, k in ipairs(keys) do
        local left= k

        while (left:len()) < left_margin do
            left= left .. ' '
        end

        print(left, tbl[k])
    end
end

function zip.open(filename)
    local file, err= binary_file.open(filename)

    if not file then
        return nil, err
    end

    file.endian= binary_file.little_endian

    -- [Local file header + Compressed data [+ Extended local header]?]*
    -- [Central directory]*
    -- [End of central directory record]

    zip.find_signature(file, {0x50, 0x4b, 0x05, 0x06})

    local end_header= zip.parse_central_directory_record(file)

    file:seek('set', end_header.central_directory_offset)

    print('------------------------------')
    pretty(end_header)

    local central_directories= {}

    while #(central_directories) < end_header.number_of_entries do
        local header= zip.parse_central_directory(file)

        table.insert(central_directories, header)

        print('------------------------------')
        pretty(header)
    end

    return file
end

function zip.find_signature(file, signature)
    local last_pos= file:seek()

    while not (file:read('u1') == signature[1] and
               file:read('u1') == signature[2] and
               file:read('u1') == signature[3] and
               file:read('u1') == signature[4]) do
        local cur_pos= file:seek()

        if last_pos < cur_pos then
            last_pos= cur_pos
        else
            error('eof')
        end
    end

    file:seek('set', file:seek() - 4)
end

function zip.parse_local_file_header(file)
    local info= {}

    info.signature=             file:read('u4')
    info.version=               file:read('u2')
    info.flags=                 file:read('u2')
    info.compression_method=    file:read('u2')
    info.last_modify_file_time= file:read('u2')
    info.last_modify_file_date= file:read('u2')
    info.crc32=                 file:read('u4')
    info.compressed_size=       file:read('u4')
    info.uncompressed_size=     file:read('u4')
    info.filename_length=       file:read('u2')
    info.extra_field_length=    file:read('u2')

    info.filename=        utf8.decode(file:read(info.filename_length))
    info.extra_field=     utf8.decode(file:read(info.extra_field_length))
    info.compressed_data= utf8.decode(file:read(info.compressed_size))

    assert(info.signature == 0x04034b50, 'signature must to be PK34')

    return info
end

function zip.parse_extended_local_header(file)
    local info= {}

    info.signature=         file:read('u4')
    info.crc32=             file:read('u4')
    info.compressed_size=   file:read('u4')
    info.uncompressed_size= file:read('u4')

    assert(info.signature == 0x08074b50, 'signature must to be PK78')

    return info
end

function zip.parse_central_directory(file)
    local info= {}

    info.signature=                       file:read('u4')
    info.version_made_by=                 file:read('u2')
    info.version=                         file:read('u2')
    info.flags=                           file:read('u2')
    info.compression_method=              file:read('u2')
    info.last_modify_file_time=           file:read('u2')
    info.last_modify_file_date=           file:read('u2')
    info.crc32=                           file:read('u4')
    info.compressed_size=                 file:read('u4')
    info.uncompressed_size=               file:read('u4')
    info.filename_length=                 file:read('u2')
    info.extra_field_length=              file:read('u2')
    info.file_comment_length=             file:read('u2')
    info.disk_number_start=               file:read('u2')
    info.internal_file_attributes=        file:read('u2')
    info.external_file_attributes=        file:read('u4')
    info.relative_offset_of_local_header= file:read('u4')

    info.filename=     utf8.decode(file:read(info.filename_length))
    info.extra_field=  utf8.decode(file:read(info.extra_field_length))
    info.file_comment= utf8.decode(file:read(info.file_comment_length))

    assert(info.signature == 0x02014b50, 'signature must to be PK12')

    return info
end

function zip.parse_central_directory_record(file)
    local info= {}

    info.signature=                file:read('u4')
    info.number_of_disks=          file:read('u2')
    info.disk_number_start=        file:read('u2')
    info.number_of_disk_entries=   file:read('u2')
    info.number_of_entries=        file:read('u2')
    info.central_directory_size=   file:read('u4')
    info.central_directory_offset= file:read('u4')
    info.zipfile_comment_length=   file:read('u2')

    info.zipfile_comment= utf8.decode(file:read(info.zipfile_comment_length))

    assert(info.signature == 0x06054b50, 'signature must to be PK56')

    return info
end

return zip
