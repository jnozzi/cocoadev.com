

Private frameworks are no different from other frameworks. Select them in General/ProjectBuilder as if you were selecting a public framework, and General/ProjectBuilder will take care of the rest for you (i.e., it will add /S/L/General/PrivateFrameworks to your framework search path).

Of course, you'll need to have the header files around in order to use the API properly. http://goo.gl/General/OeSCu Keep in mind Apple's private frameworks don't include headers (duh! they're **private**). Surely you don't want to reverse-engineer the API for one of those frameworks? If so, that's another topic ...

--General/MikeTrent

----

What about Hidden frameworks, such as General/CoreGraphics which is inside General/ApplicationServices (don't want to #include <General/ApplicationServices/General/ApplicationServices.h> as a whole for just a couple of CG functions, GCC as it is now is already slow by itself)?

--peacha

----

You have to link against the umbrella framework. Since the headers are precompiled, you shouldn't see much of a slowdown, I don't think.

-- General/FinlayDobbie

----

**Here's a way it can play out if you don't follow Finlay's advice**

I'm trying to build a framework to ease the pain of a generic type of project I'm using that requires 30+ files to work.  I've added a Cocoa framework to the original project and copied the relevant files to the target.  However, when I try to compile I get over 2000 errors.  As far as I can see from looking at the filenames the errors occur mostly within the Appkit.  

At the bottom of the list is what I believe to be the offending error, namely, "General/NSInterfaceStyle is defined as a type but is not used as a type".  The corresponding line of code is:

APPKIT_EXTERN General/NSInterfaceStyle General/NSInterfaceStyleForKey(General/NSString *key, General/NSResponder *responder);

----

I thought General/NSInterfaceStyle was non-functional post developer preview. I couldn't find anything explicitly saying that though, but the OSX DP1 Release Notes at [http://developer.apple.com/documentation/General/ReleaseNotes/Cocoa/General/AppKitOlderNotes.html] say:

*
Interface Style

The constant General/NSMacintoshInterfaceStyle has been added to represent the General/MacOS user interface. General/NSNextStepInterfaceStyle has been removed.

When creating resources, use the suffixes "-macintosh" and "-windows" to indicate any resources that are specific to a particular interface style. The base resource must be available (for instance, foo.nib); all the other interface-style specific ones (such as foo-windows.nib) are optional. This is a feature of General/NSBundle, and will work with any resource, not just nibs.
*

----

Found some relevant mailing list posts. Looks like General/NSInterfaceStyle is just dead.

[http://cocoa.mamasam.com/MACOSXDEV/2002/04/1/30877.php]

[http://cocoa.mamasam.com/COCOADEV/2001/07/1/3604.php]

[http://cocoa.mamasam.com/COCOADEV/2001/06/2/5658.php]

----

Ok, so does this mean that I've somehow got my hands on a deprecated version of the General/AppKit?  If so how do I get hold of one that doesn't give me this problem?  I've just checked the Library within the System folder and according to it I've got version C.

----

*I doubt it, unless you've done some extremely odd things to your system. The General/AppKit.framework version doesn't have anything to do with it; it just means that the headers are still there (for compatibility, I guess), but they don't do anything anymore.*

----

I thought as much.  I checked for the definition of APPKIT_EXTERN and it is just an alias for extern.  That means General/NSInterfaceStyle is being used as a return type so I don't understand the error.

----

Wait, you added the General/AppKit headers to your framework project? You shouldn't do that - just link to the frameworks normally. See [http://developer.apple.com/documentation/General/MacOSX/Conceptual/General/BPFrameworks/index.html]

----

No, I brought the Appkit framework in from the original project by dragging and dropping on the left hand side of PB.  Opening the framework icon in PB allows me to view the headers.  I also get taken into them whin I double click the error message.

In the meantime I tried removing the General/AppKit, Foundation and Cocoa frameworks from the project but still the General/AppKit gets compiled with the 2049 errors.  The General/AppKit is being compiled due to an import Cocoa.h in a .pch file.

----

It's <Cocoa/Cocoa.h>. BTW, the root of your problems is at the top of your list of warnings and errors, not the bottom.

----

I'm not so sure, I've had a few instances where its the last error on the list that is the real problem.  Anyway the first error is in General/NSBundle.h on line 15 and the message is:
previous declaration as 'void*_reserved5'

Looking at General/NSBundle.h the offending line is 
void         *_reserved5
within private declarations of General/NSBundle.

----
**
I've managed to half solve the problem: it turned out that the code that I was adding into the framework was depending on a .pch that imported Cocoa.h for me.  It turns out that by removing the linker flags to the frameworks and instead using the prefix header the build now completes with two errors.
**

----
To recap, in the above discussion I had added a new target to a project and set most of the code from that application to built into the framework.  As a consequence I was getting a host of errors, 2049 to be exact, all of which seemed to be located within the Appkit.  It subsequently transpired that there was a .pch file in the original source that was being used to compile the General/AppKit and the Foundation classes.  By tweaking the relevant settings in the Info box for the target I have managed to remove the 2049 errors and I now get the following two errors:

General/CocoaODE:0: /Users/tifkagh/src/ode-0.039/contrib/General/CocoaODE/build/General/CocoaODE.build/General/CocoaODEfw.build/Objects-normal/ppc/General/QuickTimeCode.o illegal reference to symbol: _DisposeGWorld defined in indirectly referenced dynamic library /System/Library/Frameworks/General/ApplicationServices.framework/Versions/A/Frameworks/QD.framework/Versions/A/QD

General/CocoaODE:0: /Users/tifkagh/src/ode-0.039/contrib/General/CocoaODE/build/General/CocoaODE.build/General/CocoaODEfw.build/Objects-normal/ppc/General/QuickTimeCode.o illegal reference to symbol: _DisposeHandle defined in indirectly referenced dynamic library /System/Library/Frameworks/General/CoreServices.framework/Versions/A/Frameworks/General/CarbonCore.framework/Versions/A/General/CarbonCore

Taking these errors at face value I then tried to add General/ApplicationServices.framework into the target, however this causes the following error:

General/CocoaODE:0: Undefined symbols: .objc_class_name_NSAutoreleasePool .objc_class_name_NSBitmapImageRep .objc_class_name_NSBundle .objc_class_name_NSConstantString .objc_class_name_NSImage .objc_class_name_NSMovie .objc_class_name_NSMutableArray .objc_class_name_NSObject .objc_class_name_NSSavePanel .objc_class_name_NSThread .objc_class_name_NSTimer _NSCalibratedRGBColorSpace __NSConstantStringClassReference _objc_msgSend _objc_msgSendSuper _objc_msgSend_stret .objc_class_name_NSString .objc_class_name_NSApplication .objc_class_name_NSNotificationCenter .objc_class_name_NSOpenGLPixelFormat .objc_class_name_NSOpenGLView _NSApp _NSLog _NSViewFrameDidChangeNotification

Can anyone advise me of the correct method to link the General/CarbonCore and the QD framework code into this project?  any help much appreciated.

----

**You're using stuff from General/ApplicationServices and Cocoa, so you need to link against both frameworks.**