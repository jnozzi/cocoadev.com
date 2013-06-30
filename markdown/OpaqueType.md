

General/CoreFoundation's "objects" are all instances of some General/OpaqueType or other. And that's the limit of my knowledge. Does it just use a pointer-abstracted structure? -- General/RobRix

Hardly matters, but I guess so. I doubt they're General/ObjC things, which only leaves structures. -- General/KritTer

I don't think they're objects; I only added the entry because it deals with General/FoundationKit's cousin General/CoreFoundation and therefore is likely to come into the life of some Cocoa developer somewhere (it already has, actually). But you're right, their implementation doesn't matter because they're Opaque with a capital O for a reason. Encapsulation and all that. -- General/RobRix