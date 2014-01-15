require 'byte_reader'
require 'jclass'

if not (#arg >= 1) then
    error('usage: lua {script name} {java class file}')
end

-- local br= byte_reader.new('../../c++/cpp-jclass/PublicClass.class')
local br= byte_reader.new(arg[1])
local jc= jclass.new(br)

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

br.close()

print('version', jc.version())
print('public', jc.is_public())
print('super', jc.is_super())
print('classname', jc.classname())
print('superclassname', jc.super_classname())

for i, field in ipairs(jc.fields()) do
    local mod= ''
    if field.is_public() then
        mod= '+'
    elseif field.is_private() then
        mod= '-'
    elseif field.is_protected() then
        mod= '#'
    else
        mod= '&'
    end
    print('', mod, field.name(), field.type())
end

for i, method in ipairs(jc.methods()) do
    local mod= ''
    if method.is_public() then
        mod= '+'
    elseif method.is_private() then
        mod= '-'
    elseif method.is_protected() then
        mod= '#'
    else
        mod= '&'
    end

    local params= {}
    for i, param in ipairs(method.parameter_types()) do
        params[#params + 1]= param
    end

    print('', mod .. ' ' .. method.name() .. '(' .. table.concat(method.parameter_types(), ', ') .. ')' .. ' : ' .. method.return_type())
end
