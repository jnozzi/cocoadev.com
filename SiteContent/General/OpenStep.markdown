

General/OpenStep is the set of libraries that eventually became the General/YellowBox in General/AppleRhapsody, and finally, Cocoa.

A cadre of dedicated users have implemented an open source version of the General/OpenStep standard known as General/GNUStep.

General/OpenStep was also an operating system for a few different architectures, sold by General/NeXT. In time, it became General/AppleRhapsody, and eventually General/MacOSX. General/OpenStep was sometimes thought of as General/NeXTSTEP 4.

----

Not to nit-pick, but I thought the OS was called OPENSTEP, not General/OpenStep.

Also I don't see much similarity between Mac OS X and OPENSTEP. The only thing they have in common is the higher level General/OpenStep API aka Cocoa and General/NetInfo, everything else is different. The driver architecture is different, the low level General/APIs are different, the display server is different, the kernel has been totally rewritten, etc. If the only similarity is one API then Mac OS X doesn't derive it's lineage to any greater degree from OPENSTEP than General/MacOS.

The most important aspect, in my opinion, was derived from General/MacOS: the human interface guidelines.

-- General/PaulBayley

----

Well,  I would call that nit-picking  ;)  but you're correct anyway;  I have an General/OpenStep 4.0 box on a shelf here, and it is indeed labelled OPENSTEP on the outside as well as in the manuals, fwiw.  I think that the Objective-C development API was called General/OpenStep however.  Anyway, most people just write General/OpenStep (maybe we don't want it to look like we're SHOUTING).

As for the lineage from General/NeXTSTEP to General/OpenStep to Mac OS X, let me just say that if you had used General/NeXTSTEP or General/OpenStep extensively, you would certainly "feel" the relationship with Mac OS X.  You're right that huge chunks of the guts have been ripped out and replaced, but to a large extent they've been replaced with upgraded versions of the same parts.  The low-level General/APIs are actually about the same; the BSD kernal was "just" upgraded to a newer version;  The display server is actually quite similar to DPS in terms of capabilities and even, in many cases, General/APIs (some have likened it to a re-write and extension of DPS, minus the General/PostScript language interpreter).

-- General/JackNutting

----

General/NeXT had some real strange naming for it.
Here's the General/ObjectFarm info on OPENSTEP/General/OpenStep:

General/OpenStep

... was born as part of the deal with Sun. General/OpenStep stands for an API specifications which was based on an evolution of the existing NEXTSTEP General/APIs. Most of the new technology already was available inside General/NeXT's labs but needed a renewed system to get integrated. General/OpenStep does not refer to any "real" implementation. It stands for the abstract API definitions which a vendor has to support in order to call his system "General/OpenStep compliant". General/OpenStep consists of the General/AppKit, General/FoundationKit and the Display General/PostScript layer.

OPENSTEP

... is General/NeXT's specific implementation of the General/OpenStep specification, and basically represents General/NeXTSTEP 4.0. This was yet another marketing move to get rid of the old name. OPENSTEP is a dual personality which still provides the General/NeXTSTEP compatibility libraries to run applications which are based on the old General/APIs. Additionally it has the new General/OpenStep compliant frameworks. The look & feel remained the same, and so users hardly can tell the difference between both worlds.
The full naming is OPENSTEP for General/MachOS/General/[NeXT Computers, Intel, SPARC].

there's also more.. OPENSTEP for Windows, and General/OpenStep for Solaris... confused? :)

http://www.objectfarm.org/Activities/Publications/General/TheMerger/General/OpenstepConfusion.html

-- Anonymous General/OpenStep user :)