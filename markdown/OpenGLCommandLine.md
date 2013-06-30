I'm trying to run a General/OpenGL program from the command line with:

    
cc -o hello -framework General/OpenGL -framework GLUT hello.c


It's one of the first programs from General/TheOpenGLRedBook.  I know I must be missing something because I keep getting:

    
ld: /usr/lib/crt1.o illegal reference to symbol: __objcInit defined in indirectly referenced dynamic library /usr/lib/libobjc.A.dylib


from the linker.  Any suggestions?
----
I'm not sure, but I think GLUT on General/MacOS X is implemented on top of Cocoa. So perhaps you need to add "-framework Cocoa" to your command line?

Out of curiosity, is there a reason why you're not just building and running from General/XCode or General/ProjectBuilder or whatever?

--Tom

----

Well it's partly an attempt to improve my understand of OS X's underpinnings.  I'm reading Core Mac OS X and UNIX Programming by Dalrymple and Hillegass.  Great book, so I decided I'd tackle it w/ only the command line and emacs.  Call me crazy.

Anyways I solved the problem by sniffing around Apple's porting from UNIX docs.

The source code should be compiled with:

    
cc -o hello -framework General/OpenGL -framework GLUT hello.c -flat_namespace


The program can then be launched just like any other command line program.

I hope somebody else finds this useful.

----

command line and emacs - that totally warms my heart!  Glad you're liking the book.  ++General/MarkDalrymple

----

You can ditch the -flat_namespace flag (which I personally try to avoid) by adding     -lobjc to your list of library flags.