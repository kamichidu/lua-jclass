package.path= package.path .. ';./lib/?.lua'

local jclass=      require 'jclass'

if not (#arg >= 1) then
    error('usage: lua {script name} {java class file}')
end

local jc= jclass.parse_file(arg[1])

print('package', jc:package_name())
print('class', jc:canonical_name())
print('classes')
for class in jc:declared_classes() do
    print('', class)
    -- print('', class:canonical_name())
end
