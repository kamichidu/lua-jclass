require 'byte_reader'
require 'class_file'

if not (#arg >= 1) then
    error('usage: lua {script name} {java class file}')
end

-- local br= byte_reader.new('../../c++/cpp-jclass/PublicClass.class')
local br= byte_reader.new(arg[1])

local constants= {
    cp_info_tag= {
    },
    access_flag= {
        public=     0x0001,
        final=      0x0010,
        super=      0x0020,
        interface=  0x0200,
        abstract=   0x0400,
        synthetic=  0x1000,
        annotation= 0x2000,
        enum=       0x4000,
    },
}

local stringify= {}
function stringify.access_flag(bits)
    local directions= {'public', 'final', 'super', 'interface', 'abstract', 'synthetic', 'annotation', 'enum'}
    local identifies= {}

    for i, direction in ipairs(directions) do
        local test_bit= constants.access_flag[direction]

        if bit32.band(bits, test_bit) == test_bit then
            identifies[#identifies + 1]= direction
        end
    end

    return table.concat(identifies, ' ')
end

local class_file= class_file.new(br)

for k, v in pairs(class_file) do
    if k == '_access_flags' then
        print(stringify.access_flag(v))
    elseif type(v) == type({}) then
        print(k, #v)
    else
        print(k, v)
    end
end

br.close()
