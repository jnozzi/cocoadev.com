I am a web developer learning Cocoa. I've been using Hillegass and recent O'Reilly books and have made progress. I wrote a simple fractal generator that I need to polish still.

I want to write a very simple game as my next learning app.  It's a port of an old Apple II game called "Sabotage," similar to a game on the 3G/mini iPods.  The game has a black field with some moving characters that you shoot from a turret.  Simplish.  But what's the best view to use?

General/NSBezierPath Quartz tools seem slow and not really what you'd need here.  Is General/OpenGL too  complex to use for this 2D work?  Need I draw offscreen then flush to main view?  Any tips in general?  I've only used Quartz drawing in the fractal app and am unfamiliar with other modes.

----

General/NSBezierpath isn't as slow as it seems. I've had good luck drawing complex graphics with no appreciable lag, even when zoomed in and scrolling around.

However, for performance, you simply aren't going to beat General/OpenGL, even when you're dealing with 2d. I recommend buying General/TheOpenGLRedBook -- it covers 2d in the first chapter or two. it's *remarkably* easy. I went from not having ever written a line of opengl to writing fast (albeit graphically simple) visualizations in a couple months. Hell, I wrote some pretty cool stuff within a week of starting on the Red Book.

For what it's worth, I'm writing a mahjong solitaire game in open gl right now. it's 3d, yes, but it wasn't very hard. And I plan on writing a 2d version using the bezier path apis.

----

I got the Red Book just now from Borders on my lunch break.  Any tips on how to get setup via Cocoa to have a blank slate to begin trying some of the C examples in this book?

----

If I were you I'd start with GLUT -- the Red Book is all GLUT demos anyway, and they compile without a hitch as mac OS X command line apps. Pick C++ tool from the new project menu and add General/OpenGL.framework, GLUT.framework, and Cocoa.framework ( Apple's GLUT is written on top of cocoa ).

The only changes you'll need to make to the source in the red book is that instead of #include <gl.h> you will have to do #include <General/OpenGl/gl.h> as well as #include <GLUT/glut.h>

GLUT's the way to go -- particularly since you can just make a Red Book.xcode project and make a new target from each example in the chapters without needing to make separate nibs or doing any hoo ha in IB. That's how I did it, at least.

Of course, when you're ready, you'll integrate with cocoa. But that's hard ( well, not hard, but not easy either), and I wouldn't bother until you've got your opengl code worked out.

----

I tried the C++ Tool approach with a bit of code and added in the includes and frameworks and build succeeded but I get an exit on the prog on run with signal 10.  Can you point to or paste an extremely bare bones main.cpp that even just sets up a blank field in General/OpenGL and just sits there, to help me get past this early startup glitch situation?

Also - a big part of this for me is becoming proficient w/ Cocoa - so I may do well to work in Cocoa from the get-go.

----

If you could post a stack trace of your crash (cut-n-paste from the crash window ) I'll look it over.

Again, I want to say that General/OpenGL + Cocoa isn't for the new or faint of heart. I spent 4 hours this morning debugging my display routines after moving my Mahjong code to Cocoa. Mind you, they worked fine in GLUT... If you're new to General/OpenGL, & you're new to Cocoa, I predict trouble. Learning two completely unrelated General/APIs simultaneously is asking for a headache. For example, your General/OpenGL code might be good but you're not setting up your pixel format in Cocoa correctly. But you think it's a mistake in your General/OpenGL so you bang your head against the wall for six hours debugging your General/OpenGL while it's all just a one-liner bit of cocoa to fix the problem.

I recommend learning General/OpenGL and Cocoa separately. Don't mix them until you feel comfortable in both.

Anyway, if you do want to learn General/OpenGL progframming in Cocoa the best way is to study the Mac OS X ports of the General/NeHE tutorials. See http://nehe.gamedev.net -- for most of the tutorials there's a Cocoa port. Very good code. Very good use of Cocoa General/OpenGL too, except the fullscreen functions are broken on all the ports. But when you look at that code, you'll probably rethink your stance, and decide to mix them later.

----

I have been playing with straight General/OpenGL as a "C++ Tool" and in Cocoa.  I see your point.  But again I am trying to code a game using Cocoa so I might stick w/ Cocoa General/OpenGL for a large part.  I am using some examples from the Red Book and would love just an example of code that moves an apparently 2D rectangle (z=0) sliding across the screen.  I can do rotations expressed in degrees, but sliding an  object seems elusive to me.  

If you have any example code...  I can see using pixels as measures to animate something across the screen but General/OpenGL's coordinate system seems such that I can't quite determine how best to scroll something across the screen.  (Eventually this would be a little simple 2D image of a helicopter, which I would presumably create out of polys - i'll start with a white rectangle tho.)

----
There are two ways to make something move around the screen. In your drawing code:

1. call glTranslate*() before you call any drawing primitives such as glVertex*(). Repeatedly doing something like this in your drawing routine should move a red 10x10 square horizontally across the screen (disclaimer: demo only, not tested!):
    
/*
ASSUME: General/GLfloat x=0;
*/

glColor4f(1,0,0,1);
glPushMatrix();
    glTranslate3f(x,0,0);
    glBegin(GL_QUADS);
        glVertex2f(0,0);
        glVertex2f(0,10);
        glVertex2f(10,10);
        glVertex2f(10,0);
    glEnd();
glPopMatrix();
x+=1.0;


2. directly alter the coordinates you pass to the drawing primitives, perhaps using glVertex2f(x,x+10) or somesuch.

I assume you're currently doing something rather like (1) to perform the rotations you spoke about.


----

Take a look at the screen below:

http://www.tgr.com/weblog/images/articles/sab-play.jpg

This is the game I am looking to rewrite using General/OpenGL for 2D gfx under Cocoa.  (The above screen is the Apple II game running in an emulator: scrolling helicpoters, dropping paratroopers, aimable turret, bullets.)  Do you feel that General/OpenGL is an appropriate tool to use in getting this done?  Quartz renderng seems not quite suited to this sort of thing.  And Carbon-style (is it still General/QuickDraw?) seems less friendly.  Or is going General/OpenGL a mistake?

----

Q: *And Carbon-style (is it still General/QuickDraw?) seems less friendly.*

A: No, New Carbon apps should be using General/CoreGraphics (Quartz) for drawing. General/QuickDraw is dying.

----

I did exactly what you are wanting to do: learned Cocoa and General/OpenGL at about the same time. I honestly had very few problems when working with 2D General/OpenGL, but later when going 3D I had several problems with depth buffering and lighting. I didn't bother learning GLUT because I knew I didn't want to go that rout (I just learned the basics so I could understand the examples). If you are creating a 2D game, I suggest jumping right in to Cocoa and General/OpenGL.

First create a 2D square that moves around when you press the arrow keys. Once you have created that basic frame for your game, you can ignore all that "frame" code which is normally where the Cocoa / General/OpenGL related bugs crop in (the initialization of the view and the input management). You can then start focusing on General/OpenGL and it is basically the same as GLUT but with only Cocoa. If you e-mail me, I can send you some General/OpenGL examples that I made. (e-mail is on my page). Also, don't forget to check Apple's sample code page for a couple nice examples. -- 

----

I mean to create a Cocoa app with code that reads keypresses in the view subclass which are then responded to by code in a controller (General/NSObject subclass).  The thing about 2D in General/OpenGL is that you're not dealing with pixels but with General/OpenGL's coordinate system - so it would seem collision detection would be tricky since you can't say just where on screen (pixelwise) anything is.  I suppose General/OpenGL has routines to detect collisions within its coordinate system - but that added abstraction, in concept anyway, seems to make things kind of strange ot work with.  I will see how it goes as I proceed.

----

Yes, in General/OpenGL you aren't directly dealing with pixels. However, General/NSBezierPath does not directly deal with pixels either. It just so happens that each point is a pixel - you can set the same thing up with General/OpenGL if you really want to.

As for collision detection, you shouldn't find many problems. Sure, you can't easily tell if two pixels are touching, but you can create a bounding box/polygon and detect if a point is inside that. There is a lot of information on the web about collision detection. I recommend you do some googling.

----

(from post someone inserted a few blocks up...)

*A: No, New Carbon apps should be using General/CoreGraphics (Quartz) for drawing. General/QuickDraw is dying.*

Q:  Ok, but Quartz' vector-based "display PDF" method of drawing is more cumbersome than pixel-oriented General/QuickDraw ops for many things - what do you do if you want to draw using non-vector, oldschool methods under OS X today and tomorrow?  Certainly the old pixel-based methods are faster at drawing bitmaps than Quartz.

----

Apple is continually optimizing Quartz, so hopefully it will be as fast or faster than General/QuickDraw in the near future. You can also disable anti-aliasing in Quartz to get some speed increase. Non-vector based drawing is fading along with General/QuickDraw, so there's no other alternative as far as non-vector based drawing goes. Vector based drawing is so much cooler anyway. :)

----

*Certainly the old pixel-based methods are faster at drawing bitmaps than Quartz*

In my current application (Carbon based using Quartz and General/HIView); I draw into a General/CGImage. With smart buffer management and minding to respect to the current clip bounding box; General/CoreGraphics can really zing!

----

Should I structure this game - where I will be controlling things in an onscreen General/OpenGL display via keypress, and having certain things animate on their own, using an MVC structure where the controller contains most of the code (what to do when key pressed, what to move on its own where, etc.) vs. the code being in the subclass of the view?

----

I'm the author of the web page you linked that image from (http://www.tgr.com/weblog/archives/000078.html).  Sabotage is one of my favorite games, so please be sure to let me know when you're done with your port, and I'll give it a little exposure.

peterb

----

I know there are others here who have much more experience coding games than I do, so please correct me if I'm giving bad advice. Also, sorry this post is not Cocoa specific. Perhaps this isn't the best place to discuss games.

Once you have a decent understanding of General/OpenGL and Cocoa you can start creating the underlying engine. I would start with making an abstract 2D object class which can scale, translate, rotate around a set anchor point, draw itself, etc. You can also make a hierarchy system where each object can have children objects which scale, rotate, etc. based off of the parent object. You may also want to add some physics and collision detection to this engine, but try to keep it small considering it's your first game.

You could also have the 2D objects themselves respond to key events. Some kind of input manager object can forward the key events onto the appropriate 2D objects.

Animation can be a little tricky. You can get the time difference since the last frame and pass that on to each object and have it animate itself based on that - this way no matter what the frame rate, the objects will always move at the same velocity. If this is undesired you could base the animation off of the frame rate and just set a low limit to the max fps so it doesn't go extremely fast on more powerful computers.

As for the view subclass, I would keep that as small as possible: have it delegate most of the work onto other objects. The view class can easily get bloated with even the smallest games, so it's best to keep the game related stuff out of the view to start with.

Also, keep all code specific to this game out of the engine so it can be flexible to use for other games. I know there are some powerful open-source game engines out there, but I think it is good experience to build your own lightweight game engine. Get some good books on game engines, AI, physics, collision detection, etc. Do a lot of google searching too.

----

*In my current application (Carbon based using Quartz and General/HIView?); I draw into a General/CGImage?. With smart buffer management and minding to respect to the current clip bounding box; General/CoreGraphics can really zing!*

Could you expand on smart buffer management?  And thanks to all for this input.

----
*Could you expand on smart buffer management?*

Well, My applications needs are probably fundamentally different than yours. In my case, I have a custom (compression scheme) graphics file format to deal with. The images they represent are commonly > ~10000 pixels in height, width, or both, so I can't just decompress the whole thing up front into a General/CGDataProviderRef/General/CGImageRef (or General/NSBitmapImageRep/General/NSImage) because that would result in ~400+ MB in memory usage per open file (ouch). The solution was to only decompress (on the fly) what was needed. "Smart buffer management" in my case (and it really does help) is to maintain the memory that the General/CGDataProviderRef (or General/NSBitmapImageRep) uses manually. Grow it if necessary, but reuse it for the life of the document as reallocations are expensive in the middle of a draw method. i.e. Smaller clipping rects can reuse a larger memory block. And of course, nothing has to be done if the clipping rect falls within the current cached image "slice". It has worked well enough that I can grab the scroller thumb on a ~10,000 pixel document and drag it wildly, with no tear and no perceivable lag on a 800MHz G4. Although, this setup has made rotation and scaling a major pain. I am working on a tiling scheme to help the performance on that. I will probably be looking at vImage in the Accelerate.framework in the near future.

----

So those that tell me General/CoreGraphics is fast enough to make this sort of game ... for animation on a black field is it a matter of drawing your image and then as you move across, erase that image (draw in black) and redraw a pixel further, etc. or does General/CoreGraphics have the ability to, on its own, "move" (sprite-like, or General/OpenGL like) a set of graphics across the screen?

----

There is NSC<nowiki/>opyBits, which is fast in the sense that it uses the graphics hardware when possible to move the pixels.

See http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Functions/General/AppKitFunctions.html

----

*So those that tell me General/CoreGraphics is fast enough to make this sort of game...*

Quite, CG/QE is double buffered, it will have no trouble with this one. Just invalidate the area where the ship is and where it should be (union the rect) and mind the clipping rect during your drawing. General/OpenGL for a such a trivial 2D game would be unnecessary overkill. To specificly answer your question, no Core Graphics does not (currently) have a method to treat your sprites indepently for you. Although your codes object model can, and it should work nicely.

----
The General/NeHE tutorials are excellent and most General/OpenGL examples at the site have Cocoa versions.
http://nehe.gamedev.net/

The particular game discussed here is easily doable using Cocoa and Quartz without direct use of General/CoreGraphics or General/OpenGL.

There is a Tetris like game with complete Cocoa source code at http://www.cocoaprogramming.net/Downloads.html
The "Cocoa Programming" book by Anguish, Buck, and Yacktman describes how and why the game is built the way it is.  There is also a "Lots of Words" example that includes animation.  The book is available very inexpensively in electronic form from Amazon and others, and you don't even need the book to download and use the example code.

There is lots of Apple sample code for using General/NSImage, the contents of General/NSView's, and many image sources as General/OpenGL textures.  A quick search with General/NSImage and texture at http://developer.apple.com will amaze!  See Texture.[hm], General/StringTexture.[hm], General/NSGLImage  and General/GLImage.[hm], General/BasicOpenGLView, the General/CIImage class, and much much more.

Finally, General/QuartzComposer actually does have sprites and the ability to load practically any image format.  It would be interesting to implement a game with General/QuartzComposer...