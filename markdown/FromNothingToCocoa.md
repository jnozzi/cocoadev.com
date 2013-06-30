A book being written by General/CharlieMiller, which will help people with no former programming experience become proficiant with cocoa.  It will teach people the Obj-C way of doing things (why teach malloc() and free() when you never use them in Obj-C?).  If anyone wants to help with it, contact General/CharlieMiller.

----

malloc() and free() (and friends) can be useful in Objective-C, I've used them occasionally when doing pure-Cocoa stuff would have either been convoluted, or inefficient due to object proliferation.  No need to artificially limit the tools you can use.  ++General/MarkDalrymple

Agreed. If your program is too slow because you use objects where they're inappropriate, you probably haven't met your users' requirements. -- General/RobRix

----

Someone is trying to start the object-oriented-is-slow-lets-use-assembler debate again, way to go! People should realise that OO is just too slow and complex for hello world, lw, sw, addi and the others are your friends. --General/ThoHultberg/Iconara (and for those who have a hard time spotting irony, this is it guys, the real thing)

Would you use a General/NSArray of General/NSNumber<nowiki/>s to store a million integers? The overhead of objects can be ludicrous if used ineptly. By all means use an object - but use it to wrap efficient code that stores those million numbers in a C array. And probably one allocated with malloc. -- General/KritTer, who would like to add that sarcasm is a very effective way of convincing people they're wrong, but can't because his lying circuits are all out of commission :)

----

Ah, you're right.  Didn't think about it that way.  That example was pretty bad.  However, I'm sure there are some things that C programmers need to use (I guess I could resort to #import VS #include) which cocoa programmers don't need to know, which omitting could speed up the learning process for.

--General/CharlieMiller

----

Well, there are definatly advanced topics in C that probably don't need to be covered.  Your book is will be designed around beginning Cocoa anyway.  While it is true that malloc() can be used in Cocoa, a person who is just learning probably won't use it.  If they do need to, they can look it up.

--Derek Cramer

That's true.  A basic cocoa / programming book wouldn't need to talk about malloc() and friends. I think what folks were objecting to *why teach malloc() and free() when you never use them in Obj-C*, which is a naive statement. ++General/MarkDalrymple

Bingo :) -- General/RobRix

----

Writing Good Cocoa Code (by General/AndrewStone) may be of interest:
http://www.stone.com/The_Cocoa_Files/Writing_Good_Cocoa_Code.html

----

So how is the book going?

----

Ok you can use malloc and free, but don't you think that confers a bit of a hack somewhere else? I mean, I use it because I have to, but I feel maybe if the objects were up to scratch, I wouldn't have to. There should already be an array that is designed for holding a million integers efficiently. -- General/MikeAmy

Uh, no.  This is objective *C*, (notice the C there).  In C, holding a million integers is done with malloc and free.  In Java I don't think you'd want to make a vector of a million Integers, unless you had a lot of time to kill waiting for object allocation and initialization.  Objective-C and Cocoa are not the pure academic everything is idologically perfect system you seem to be wanting.  It's very a pragmatic system.  You can be high-level when you want, and dig down when you need.

Well, why not? Apple could provide one of those encapsulating objects for C arrays, making  a nice class cluster just like it did for General/NSNumber, and have efficient General/NSCoding for them. Then all you want is a method that gives you the buffer. Of course, then it is dangerous and encapsulation is gone, and maybe his is why they don't want to do it, but there could be some big warnings in the doc to tell you to be VERY careful (and there are already methods with buffers). I would like to have an object like that in Cocoa, and not have to do it myself (which I did anyway, but no class cluster, no efficient General/NSCoding, because I all cared about was fast code). General/CharlesParnot

If you're not afraid of a bit of casting and some sizeof(), then Cocoa already has a class ready-made for holding a million integers. It's called General/NSData.
--General/MikeAsh