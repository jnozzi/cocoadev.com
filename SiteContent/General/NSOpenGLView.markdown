

[Topic]

A view that displays graphics using General/OpenGL. Behind the scenes, it uses an General/NSOpenGLContext. You can call General/OpenGL functions in the -drawRect: function. Don't use any General/OpenGL commands before this method is called, because the General/NSOpenGLContext won't be set up yet.

General/NSOpenGLView is a convenience class which is not strictly required. You are free to create your own context instance and set it's view to a generic General/NSView -- ideally your own subclass of General/NSView. You may choose to do this if, for example, you wish to maintain multiple contexts and use them in the same view, or if you are not going to do your General/OpenGL drawing in the -drawRect: method (which has a lot of extra overhead). This requires a good understanding of General/NSOpenGLContext, because General/NSOpenGLView manages the context for you (things like issuing -update when the frame rectangle changes). Drawing outside of the -drawRect: method requires locking the focus (I recommend calling [myGLView lockFocusIfCanDraw]) and unlocking it when done. When using a custom General/NSView for General/OpenGL drawing, consider overriding -isOpaque to return YES -- this will speed up drawing. -- General/BrentGulanowski

----

When creating a subclass of General/NSOpenGLView, which init-method should I override? I've tried to override both initWithFrame:pixelFormat: and initWithFrame: but none of those gets called. Am I missing something obvious? -- Gabriel

----

This took me a while to figure out. initWithFrame:General/PixelFormat: will not be called, so you are left with using either 'awakeFromNib' or  'initWithCoder'. One problem you might face with awakeFromNib is that if another class is dependent on the General/NSOpenGLView, and also uses awakeFromNib, which once is loaded first can cause your program to crash. I had to settle on using initWithCoder for my General/NSOpenGLView, and awakeFromNib for my controller class. The right thing would most likely to manually write the main function, and make sure things are initialized in the correct order.

**AFAIK, this is actually something with General/InterfaceBuilder... if you drag an General/NSOpenGLView into the window and set its custom class to General/MyGLView, it won't work; you have to drag in a custom view and set it to General/MyGLView. You lose the General/NSOpenGLView inspector, sadly, but it actually *works*.**

----

In Panther, you don't need to initialize an General/NSOpenGLView if you're using a document-based architecture. There's a function call "prepareOpenGL" which gets called in place of any "init" or "awake" functions. In fact, the creaton of context and pixel format also happens for you, which is Very Cool, since it makes your subclass of General/NSOpenGLView incredibly easy to write.

If you have a number of items that you need to setup (maybe a timer? yeah, that might be useful... =- ), you do need to initWithCoder to get the job done. This page might be of interest: http://developer.apple.com/documentation/General/GraphicsImaging/Conceptual/General/OpenGL/chap4/chapter_4_section_5.html

----

I use an General/NSOpenGLView subclass that gets updated by a different thread than the main thread.
It runs fine, but crashes as soon as the window that owns it is resized.
Any suggestions as to what notification/delegate selector I should listen to in order to set
General/NSLocks on my General/OpenGL code ?

thanks ^_^

    - (void)update

*Called if the view�s context needs to be updated because the window moves, or if the view moves or is resized. This method simply calls General/NSOpenGLContext�s update. Override this method if you need to add locks for multithreaded access to multiple contexts.*

----

I've had a lot of trouble with this dastardly class, and so I finally wrote my own.  It's a much more solid, easily-subclassed class that doesn't run as fast.  There are plenty of optimisations to be made, but it works so much better for me, it makes everything easy.

    
 #import <Cocoa/Cocoa.h>
   
 @interface General/DSOpenGLView : General/NSView {
    General/NSOpenGLContext *m_context;
 }
 
 - (void)draw; // subclasses implement this to do drawing
  
 @end

 #import <General/OpenGL/gl.h>
 #import <General/OpenGL/glu.h>
 #import <GLUT/glut.h>
 
 @implementation General/DSOpenGLView
 
 - (id)initWithFrame:(General/NSRect)frame {
 
   General/NSOpenGLPixelFormatAttribute attrs[] = {
      General/NSOpenGLPFADoubleBuffer,
      General/NSOpenGLPFADepthSize, 32,
      0
    };
 
    General/NSOpenGLPixelFormat *format = General/[[NSOpenGLPixelFormat alloc] initWithAttributes:attrs];
 
    self = [super initWithFrame:frame];
    if (self) {
       m_context = General/[[NSOpenGLContext alloc] initWithFormat:format shareContext:nil];
    }
    return self;
 }
 
 - (void)dealloc {
    [m_context release];
 }
 
 - (void)drawRect:(General/NSRect)rect {
 
    [m_context clearDrawable];
    [m_context setView:self];
    [m_context makeCurrentContext];
 
    glClearColor(0,0,0,0);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
 
    glViewport( 0,0,[self frame].size.width,[self frame].size.height );  
    glMatrixMode(GL_PROJECTION);   glLoadIdentity();
    glMatrixMode(GL_MODELVIEW);    glLoadIdentity();
    
    [self draw];
 
    [m_context flushBuffer];
    [ General/NSOpenGLContext clearCurrentContext];
 }
 
 - (void)draw {
 
    glMatrixMode(GL_PROJECTION);
    gluPerspective(25,[self frame].size.width / [self frame].size.height,1,100);
    glTranslatef(0,0,-10);
  
    glColor3f(1,1,1);
    glutWireTeapot(1);
 }
 
 @end


----

No offense, but that code posted above is exceptionally crappy. There are memory leaks (General/NSOpenGLPixelFormat in -initWithFrame:), and you are calling functions in drawRect: that are not needed. You can call glClearColor and it's accompanying glClear once in an initialization function.

----
You can call glClear*Color* when you init, but if you fail to glClear your buffer every time before you start drawing, you'll have some "interesting" problems.

----
Just in case anyone is still wondering about the initalisation thing, there is an Apple example called General/GLImageWall, in there they are using this method:

    

 - (id)initWithFrame:(General/NSRect)frameRect display:(General/CGDirectDisplayID)displayID scene:(Scene*)newScene;



I set a break point at the start of the function and it seems to get called as expected unlinke the standard initWithFrame... The comment on the code also implies that the standard initWithFrame will only get called by interface builder if the control is inherits directly from General/NSView!

Hope this helps...

----
All you have to do is to provide a valid pixel format like so...

    
 - (id)initWithFrame:(General/NSRect)frame {
 
    General/NSOpenGLPixelFormatAttribute att[] = 
    {
      General/NSOpenGLPFAWindow,
      General/NSOpenGLPFADoubleBuffer,
      General/NSOpenGLPFAColorSize, 24,
      General/NSOpenGLPFAAlphaSize, 8,
      General/NSOpenGLPFADepthSize, 24,
      General/NSOpenGLPFANoRecovery,
      General/NSOpenGLPFAAccelerated,
      0
    };
 
    General/NSOpenGLPixelFormat *pixelFormat = General/[[NSOpenGLPixelFormat alloc] initWithAttributes:att]; 
 
    if(self = [super initWithFrame:frame pixelFormat:pixelFormat]) {
         /* Do init stuff here... */
    }
 
    [pixelFormat release];
 
    return self;
 }
