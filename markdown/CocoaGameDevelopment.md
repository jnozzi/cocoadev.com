

Hi everyone.

I'm new here.  I'm just trying to learn Cocoa, and for my first project I want to make a game (I'm a real game freak).  The thing is, I don't want to use General/OpenGL and I don't want it to be 3D -- I want to make an old, simple, 2D sprite based game, and I want to do it in Cocoa + General/ObjC.  Thing is, I don't really know where to start.  I can use Quartz with General/NSView and the likes (I think) but I get the impression this could well be really slow.  I've seen an example 'asteroids' game from http://idevgames.com, and it was *really* slow using this method.

Can anyone out there lend any insight on which classes I could use to get a fast 2D canvas of some sort?

Thanks...

-- General/NeilHoughton

----

I have a story for you, Neil. It has to do with General/MacZoop (a C++ framework on the Mac), and my desire to make an old-style arcade game, complete with explosions, et cetera.

Well, I've still got the code I came up with around. It's a small set of classes for sprite animation.
Gradually, I've been trying to port it to Cocoa, but I kind of lost interest (when I made it in General/MacZoop, I was on an *old* Mac, and it ran slow which may account for my displeasure with it).

Anyhow, if you want the code, I'll send it to you. I have some ideas on what should be done to port it to Cocoa, too.

You can contact me at the address on my General/CocoaDevUsers page.

-- General/RobRix

----

I thought I read somewhere someone ported Xox to X or X Server. Xox was a 2d game-kit environment written by Sam Streeper (of General/BackSpace fame) and had a small following in the NS 3.3 days ... 

-- General/MikeTrent

----

You are not getting that confused with the xonx project? [http://sourceforge.net/projects/xonx/]  It is a port of Xfree86 to Darwin.
         -General/DerekCramer

----

What about the General/CocoaSpriteKit?

Ittpoi (Infinity-to-the-Power-of-Infinity) has ported a 2D Cocoa game, **Aquatomic**. Source & binary is to be found at http://www.ittpoi.com

----

Why not just use General/OpenGL in 2D?  You don't have to use 3D features of General/OpenGL...just keep the camera perpendicular to the "world" and forget about the z coord.