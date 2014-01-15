require 'attribute_info'

field_info= {
    access_flag= {
        public=    0x0001, -- Declared public; may be accessed from outside its package.
        private=   0x0002, -- Declared private; usable only within the defining class.
        protected= 0x0004, -- Declared protected; may be accessed within subclasses.
        static=    0x0008, -- Declared static.
        final=     0x0010, -- Declared final; never directly assigned to after object construction (JLS §17.5).
        volatile=  0x0040, -- Declared volatile; cannot be cached.
        transient= 0x0080, -- Declared transient; not written or read by a persistent object manager.
        synthetic= 0x1000, -- Declared synthetic; not present in the source code.
        enum=      0x4000, -- Declared as an element of an enum.
    },
}

function field_info.new(reader)
    local access_flags= reader.int16()
    local name_index=   reader.int16()
    local descriptor_index= reader.int16()
    local attributes_count= reader.int16()
    local attributes= {}

    while #(attributes) < attributes_count do
        attributes[#attributes + 1]= attribute_info.new(reader)
    end

    return {
        _access_flags=     access_flags,
        _name_index=       name_index,
        _descriptor_index= descriptor_index,
        _attributes_count= attributes_count,
        _attributes=       attributes,
    }
end
