package.path= package.path .. ';./lib/?.lua'

local byte_reader= require 'util.byte_reader'
local class_file=  require 'raw.class_file'
local youjo=       require 'util.youjo'
local json=        require 'json'

if not (#arg >= 1) then
    error('usage: lua {script name} {java class file}')
end

local br= byte_reader.open(arg[1])
local attrs= class_file.parse(br)
br:close()

for i, e in pairs(attrs.attributes) do
    print(e.kind)
end
