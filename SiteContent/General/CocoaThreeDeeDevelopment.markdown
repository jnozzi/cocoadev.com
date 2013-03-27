3D development in Cocoa is mosly about working with General/OpenGL, but General/OpenGL is very low-level and not at all General/ObjectOriented.

I'm looking for a framework that does away with the, in my view, tedious low-level coding of General/OpenGL programming. What I'm looking for is something that replaces the General/OpenGL     glBegin(...); ...; glEnd(); code with an General/ObjectOriented interface, something like:

    
id cube = General/[GLCube cube];

[cube setLocationX:0.0 y:0.0 z:-6.0];
[cube setWidth:10.0 height:10.0 depth:3.0];
[cube setColor:General/[NSColor redColor]];

[graphicsContext add:cube];


Does anyone know of any framework that provides this level of abstraction, or any level of abstraction? I have programmed Processing (http://www.processing.org) which has a 3D environment which is somewhat abstract, although not as much as the example above, but I haven't really found any for General/ObjC. I can't be bothered with writing low-level code when all I want to do is draw some spheres and some lines. With Processing (for example) I'm up and running in 30 minutes, it shouldn't be harder than that.

And just to be clear: yes, I know that the low level interface provided by General/OpenGL is so much more efficient, but efficiency is not what I'm after in this case. The thing I want to program runs fine in Java (using Processing/JOGL), so I think some abstraction levels in General/OpenGL won't hurt.

--General/TheoHultberg/Iconara

----
General/QuartzComposer?

----
It's not a bad suggestion, but perhaps a little too abstract, I'm more looking for a framework. --Theo

----
3DKit GNU? General/GeometryKit?

----
3DKit/General/GeometryKit looks nice, although I'm a little bit worried about this statement: *The sources for the new General/RenderKit are not yet available, since it is not yet ready. We will release it as soon as we think it is the right time.*

Also, from another version of the page, from 2003: *The GNU 3DKit is currently not available and won't be for some time. The project is being redesigned and reimplemented completely as the focus for the framework changed radically over the last few years*, that's three years ago, and I think it's unlikely we will see a new version anytime soon.

Does anyone know of a more current project?

--Theo

----

My General/StarLight project ( http://www.spectralclass.com/starlight.html ) works along those lines.  It is more focussed on some of the slightly higher-level concerns but the framework itself could be used to contain these artifacts since I am already using it to do that with some serialized 3D model support for the next release.  The reason why you probably won't see too many libraries providing these low-level abstractions is that it is hard to do anything useful with them.  That is to say that it is easier to render a model by encoding a bunch of triangles in a data file you can load into a display list, at runtime, than it is to cobble together a bunch of cubes to represent the same thing.  However, it may be useful as a learning aid or to enable rapid prototyping of 3D software.

--General/JeffDisher

----

I've had luck with Quesa ( http://www.quesa.org ) when porting some old toolbox/General/QuickDraw 3D -based school projects of mine to Cocoa.
I'm only using it to basic stuff (draw a mesh and a couple of std shapes (boxes, spheres) with solid colours), but it seems to work well enough.

-- General/PeterMaddox