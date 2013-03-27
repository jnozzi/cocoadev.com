


See http://www.opengl.org/ for news and information regarding General/OpenGL.

What is General/OpenGL? (from http://www.opengl.org/about/overview.html )

General/OpenGL is a cross-platform standard for 3D rendering and 3D hardware acceleration. The software runtime library ships with all General/MacOSX, Unix, Linux and Windows systems.

There is some info on General/OpenGL on various platforms at General/NeHe, including OS X (using GLUT, whatever that is) (GLUT is the General/OpenGL Utility Toolbox):

http://nehe.gamedev.net/opengl.asp

Some GLUT examples exist on the system in    /Developer/Examples/General/GLUTExamples

 ----

Apple has an General/NSOpenGLView Teapot example on their web site (he said he found it by searching Google).  Also, there is source to a set of General/OpenGL screensavers on General/EpicWare's site.

-- General/StevenFrank

----

Yeah, the General/EpicWare code isn't great example code. Eric just basically got them working and left them alone. Looking through the code is fine (that's what it's there for), but don't take it as gospel. 

Here are some tips I've developed over the past year for working with General/NSOpenGLView.


* Don't bother with locking/unlocking focus on the view to do drawing. It doesn't seem to do any good.
* When doing drawing begin with General/glView openGLContext] makeCurrentContext] and finish with [[glView openGLContext] flushBuffer]. In particular, use flushBuffer instead of glFlush(). glFlush works with single buffer only, but flushBuffer will work with both single and double buffers. I find myself caching the value of [glView openGLContext] in my screen savers for convenience.
* If you need to set a pixel format, make sure the pixel format is set before you call [glView openGLContext] the first time. 
* You cannot safely issue GL commands into the same [[NSOpenGLContext from two different threads at the same time. You must use a lock or otherwise guarantee only one thread at a time is in your relevant code.
* You can safeuly issue GL commands into separate General/NSOpenGLContexts from separate threads. You can use this to load textures into one context on one thread and display them on another context on another thread.


Here's a function I use to report errors in GL. Call it after every gl function call with some descriptive text (say the name of the function you just called).

    
__private_extern__ void General/CheckGLError(const char *note)
{
    General/GLenum error = glGetError();
    if (error) {
        General/NSLog(@"%s [%d]: %s", note, error, gluErrorString(error));
    }
}


-- General/MikeTrent

----

See also General/FadeFromBlack

-- General/MikeTrent

----

By the way, Apple's updated all of their own information regarding Cocoa and General/OpenGL...seems good so far!

http://developer.apple.com/techpubs/macosx/Cocoa/General/TasksAndConcepts/General/ProgrammingTopics/General/OpenGL/index.html

-- General/RobRix

----
GNU 3DKit  http://www.fsf.org/software/gnu3dkit/gnu3dkit.html

This little project is looking really good, but it's the work of only one man! It is an open source 3D mathematics and scene graph API moving toward alpha release 1.4. I would dearly love to see this project succeed really big.
----
Quesa http://www.quesa.org

OK, technically this is a Carbon system, but General/QuesaCocoa now works with General/NVidia cards in Jaguar, meaning it is effectively useable with your General/NSView subclass. If you programmed with QuickDraw3D in the past, you should check this out. Very mature and very powerful. Too bad it's not in Objective-C.

----

Other General/OpenGL pages on General/CocoaDev:
[Topic]