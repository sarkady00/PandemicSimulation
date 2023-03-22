function out = SetStructure(struct,a,b,c,d,e,f)
    struct = arrayfun(@(s,v) setfield(s,'x',v), struct, a);
    struct = arrayfun(@(s,v) setfield(s,'y',v), struct, b);
    struct = arrayfun(@(s,v) setfield(s,'state',v), struct, c);
    struct = arrayfun(@(s,v) setfield(s,'timer',v), struct, d);
    struct = arrayfun(@(s,v) setfield(s,'death',v), struct, e);
    struct = arrayfun(@(s,v) setfield(s,'deathTimer',v), struct, f);
    
    out = struct;
end