local prototype= require 'prototype'

local iterators= prototype {
    default= prototype.no_copy,
}

function iterators.make_iterator(list)
    assert(type(list) == 'table')

    local curidx= 1
    return function(state, var)
        local v= list[curidx]

        curidx= curidx + 1

        return v
    end
end

function iterators.filter(iterator, predicate)
    assert(type(iterator) == 'function')

    return function(state, var)
        for v in iterator do
            if v == nil then
                return nil
            elseif predicate(v) then
                return v
            end
        end
    end
end

function iterators.transform(iterator, transformer)
    assert(type(iterator) == 'function')

    return function(state, var)
        for v in iterator do
            if v == nil then
                return nil
            else
                return transformer(v)
            end
        end
    end
end

function iterators.find(iterator, predicate)
    assert(type(iterator) == 'function')

    for v in iterator do
        if predicate(v) then
            return v
        end
    end
    return nil
end

return iterators
