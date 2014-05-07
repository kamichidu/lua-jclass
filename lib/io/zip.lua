local prototype=   require 'prototype'
local binary_file= require 'util.binary_file'

local zip= prototype {
    default= prototype.assignment_copy,
}

function zip.open(filename)
    local file, err= binary_file.open(filename)

    if not file then
        return nil, err
    end

    local end_header= zip.parse_end_header(file)

    for k, v in pairs(end_header) do
        print(k, v)
    end

    return file
end

function zip.parse_header(file)
    local structure= {}

	structure.signature=          file:read('u4')
	structure.version=            file:read('u2')
	structure.flags=              file:read('u2')
	structure.compression=        file:read('u2')
	structure.dos_time=           file:read('u2')
	structure.dos_date=           file:read('u2')
	structure.crc32=              file:read('u4')
	structure.compressed_size=    file:read('u4')
	structure.uncompressed_size=  file:read('u4')
	structure.file_name_length=   file:read('u2')
	structure.extra_field_length= file:read('u2')

    assert(structure.signature == 0x504b0304, "header's signature is must be PK34")

    return structure
end

function zip.parse_central_header(file)
    local structure= {}

    structure.signature=                file:read('u4')
    structure.version_made=             file:read('u2')
    structure.version=                  file:read('u2')
    structure.flags=                    file:read('u2')
    structure.compression=              file:read('u2')
    structure.dos_time=                 file:read('u2')
    structure.dos_date=                 file:read('u2')
    structure.crc32=                    file:read('u4')
    structure.compressed_size=          file:read('u4')
    structure.uncompressed_size=        file:read('u4')
    structure.file_name_length=         file:read('u2')
    structure.extra_field_length=       file:read('u2')
    structure.file_comment_length=      file:read('u2')
    structure.disk_number_start=        file:read('u2')
    structure.internal_file_attributes= file:read('u2')
    structure.external_file_attributes= file:read('u4')
    structure.position=                 file:read('u4')

    assert(structure.signature == 0x504b0102, "central header's signature is must be PK12")

    return structure
end

function zip.parse_end_header(file)
    local structure= {}

    -- 50 4B 05 06 (PK56)
    while not (file:read('u1') == 0x50 and file:read('u1') == 0x4b and file:read('u1') == 0x05 and file:read('u1') == 0x06) do end

    structure.signature=              0x504b0506
    structure.number_of_disks=        file:read('u2')
    structure.disk_numer_start=       file:read('u2')
    structure.number_of_disk_entries= file:read('u2')
    structure.number_of_entries=      file:read('u2')
    structure.central_dir_size=       file:read('u4')
    structure.central_dir_offset=     file:read('u4')
    structure.file_comment_length=    file:read('u2')

    return structure
end

return zip
