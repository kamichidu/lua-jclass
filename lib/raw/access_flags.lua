local prototype= require 'prototype'
local bitwise=   require 'util.bitwise'

local constants= {
    public=     0x0001, -- Declared public; may be accessed from outside its package.
    private=    0x0002, -- Declared private; usable only within the defining class.
    protected=  0x0004, -- Declared protected; may be accessed within subclasses.
    static=     0x0008, -- Declared static.
    final=      0x0010, -- Declared final; never directly assigned to after object construction (JLS §17.5).
    super=      0x0020, -- Treat superclass methods specially when invoked by the invokespecial instruction.
    volatile=   0x0040, -- Declared volatile; cannot be cached.
    transient=  0x0080, -- Declared transient; not written or read by a persistent object manager.
    synthetic=  0x1000, -- Declared synthetic; not present in the source code.
    interface=  0x0200, -- Is an interface, not a class.
    abstract=   0x0400, -- Declared abstract; must not be instantiated.
    annotation= 0x2000, -- Declared as an annotation type.
    enum=       0x4000, -- Declared as an enum type. 
}

local access_flags= prototype {
    default= prototype.assignment_copy,
}

access_flags.access_flags= 0x0000

function access_flags:is_public()
    return bitwise.band(self.access_flags, constants.public) == constants.public
end

function access_flags:is_protected()
    return bitwise.band(self.access_flags, constants.protected) == constants.protected
end

function access_flags:is_private()
    return bitwise.band(self.access_flags, constants.private) == constants.private
end

function access_flags:is_static()
    return bitwise.band(self.access_flags, constants.static) == constants.static
end

function access_flags:is_final()
    return bitwise.band(self.access_flags, constants.final) == constants.final
end

function access_flags:is_super()
    return bitwise.band(self.access_flags, constants.super) == constants.super
end

function access_flags:is_volatile()
    return bitwise.band(self.access_flags, constants.volatile) == constants.volatile
end

function access_flags:is_transient()
    return bitwise.band(self.access_flags, constants.transient) == constants.transient
end

function access_flags:is_synthetic()
    return bitwise.band(self.access_flags, constants.synthetic) == constants.synthetic
end

function access_flags:is_interface()
    return bitwise.band(self.access_flags, constants.interface) == constants.interface
end

function access_flags:is_abstract()
    return bitwise.band(self.access_flags, constants.abstract) == constants.abstract
end

function access_flags:is_annotation()
    return bitwise.band(self.access_flags, constants.annotation) == constants.annotation
end

function access_flags:is_enum()
    return bitwise.band(self.access_flags, constants.enum) == constants.enum
end

return access_flags
