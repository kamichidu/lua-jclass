require 'bitwise'

local access_flag= {
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

accessible_object= {}

function accessible_object.new(flag)
    local obj= {}

    function obj.is_public()
        return bit32.band(flag, access_flag.public) == access_flag.public
    end

    function obj.is_protected()
        return bit32.band(flag, access_flag.protected) == access_flag.protected
    end

    function obj.is_private()
        return bit32.band(flag, access_flag.private) == access_flag.private
    end

    function obj.is_static()
        return bit32.band(flag, access_flag.static) == access_flag.static
    end

    function obj.is_final()
        return bit32.band(flag, access_flag.final) == access_flag.final
    end

    function obj.is_super()
        return bit32.band(flag, access_flag.super) == access_flag.super
    end

    function obj.is_volatile()
        return bit32.band(flag, access_flag.volatile) == access_flag.volatile
    end

    function obj.is_transient()
        return bit32.band(flag, access_flag.transient) == access_flag.transient
    end

    function obj.is_synthetic()
        return bit32.band(flag, access_flag.synthetic) == access_flag.synthetic
    end

    function obj.is_interface()
        return bit32.band(flag, access_flag.interface) == access_flag.interface
    end

    function obj.is_abstract()
        return bit32.band(flag, access_flag.abstract) == access_flag.abstract
    end

    function obj.is_annotation()
        return bit32.band(flag, access_flag.annotation) == access_flag.annotation
    end

    function obj.is_enum()
        return bit32.band(flag, access_flag.enum) == access_flag.enum
    end

    return obj
end
