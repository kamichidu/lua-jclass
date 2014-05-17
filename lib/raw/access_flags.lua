local prototype= require 'prototype'
local bitwise=   require 'util.bitwise'

local constants= {
    public=       0x0001,
    private=      0x0002,
    protected=    0x0004,
    static=       0x0008,
    final=        0x0010,
    synchronized= 0x0020,
    super=        0x0020,
    bridge=       0x0040,
    volatile=     0x0040,
    transient=    0x0080,
    varargs=      0x0080,
    native=       0x0100,
    interface=    0x0200,
    abstract=     0x0400,
    strict=       0x0800,
    synthetic=    0x1000,
    annotation=   0x2000,
    enum=         0x4000,
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

function access_flags:is_synchronized()
    return bitwise.band(self.access_flags, constants.synchronized) == constants.synchronized
end

function access_flags:is_bridge()
    return bitwise.band(self.access_flags, constants.bridge) == constants.bridge
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

function access_flags:is_varargs()
    return bitwise.band(self.access_flags, constants.varargs) == constants.varargs
end

function access_flags:is_native()
    return bitwise.band(self.access_flags, constants.native) == constants.native
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

function access_flags:is_strict()
    return bitwise.band(self.access_flags, constants.strict) == constants.strict
end

function access_flags:is_annotation()
    return bitwise.band(self.access_flags, constants.annotation) == constants.annotation
end

function access_flags:is_enum()
    return bitwise.band(self.access_flags, constants.enum) == constants.enum
end

return access_flags
