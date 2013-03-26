I am looking at the QTCoreImage101 example and tried to cut and paste some code from that project into a test Cocoa project created in Xcode 2.2 set to SDKROOT=/Developer/[[SDKs]]/MacOSX10.4u.sdk

When I try to compile the class [[MyOpenGLView]] I get warnings that I have never run across before. The problem seems to be in the coding style for casting types.

<code>
// Apple's QTCoreImage101 coding style
[[CGLContextObj]]([[self openGLContext] [[CGLContextObj]]])

// Common C coding style
([[CGLContextObj]])[[self openGLContext] [[CGLContextObj]]]

</code> 

In the QTCoreImage101 project <code>[[CGLContextObj]]([[self openGLContext] [[CGLContextObj]]])</code> compiles OK, but this type cast doesn't work in a generic default Cocoa Application project.

''Looks like C++-style casting to me.''

----

Never programmed much in C++, and I even read Schaum's C++ outline a long time ago. I guess I'm a true Objective-C/C programmer then. Funny how I never ran into this before since I've played with a bunch of Apple's sample code over the years. The file extensions are <code>.m</code> and not <code>.mm</code> so how does the QTCoreImage101 project know about the C++ coding style? What build settings will let this fly?

----

Warnings are only warnings. Then again, nobody here can tell you because you haven't elaborated. :-) How about telling us exactly what warnings you're receiving? They may be entirely safe to ignore.

----

I try to keep my code void of warnings so when ones do pop up they are easy to detect. The warning I get is:

<code>
error: parse error before '[[CGLContextObj]]'
</code>

----
What the first snippet is doing is calling the [[CGLContextObj]] constructor with the result of [[self openGLContext] [[CGLContextObj]]] as the argument. If this is not C++ code, this should not compile at all, barring some macro magic, which I have seen used in C code before. You should be able to safely switch the code to a standard C cast, just make sure that [[CGLContextObj]] is a type. Like I already said, I have seen instances where [[CGLContextObj]] would be a Macro for creating [[CGLContext]] objects. -JJJ

----

Yeah, I already figured out that all I needed to do was change to C style casting, but I was mainly interested in how to get the C++ style cast to compile without having to manually change all of the places where this is an issue.

----

Since you stated that the original files are .m, not .mm, and yet they compile fine, it's probably related to the language dialect. Try switching your dialect to C99 or GNU99 (available in your target settings).

----

I'll try that. Thanks.