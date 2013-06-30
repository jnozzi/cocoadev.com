

General/LaunchServices is responsible for binding documents to applications and the system-level functionality of launching applications.

It is part of the General/ApplicationServices umbrella framework.

Documentation:

*Conceptual docs at http://developer.apple.com/documentation/Carbon/Conceptual/General/LaunchServicesConcepts/index.html
*Reference docs at http://developer.apple.com/documentation/Carbon/Reference/General/LaunchServicesReference/index.html
*A technote at http://developer.apple.com/technotes/tn/tn2017.html
*The header file at file:///System/Library/Frameworks/General/ApplicationServices.framework/Frameworks/General/LaunchServices.framework/Headers/General/LaunchServices.h


See also General/HowToRegisterURLHandler.

----



Courtesy of Charles Srstka, on Apple's cocoa-dev mailing list:

These two lines of code will get you an General/NSArray filled with an NSURL for each application on the system, wherever it may be stored.
    
General/NSArray *urls;
_LSCopyAllApplicationURLs(&urls);


Unfortunately, the _LSCopyAllApplicationURLs() function is private and undocumented. But it does work, and since it's usually reading cached information out of the General/LaunchServices database, it's much faster than a file search.

There is more discussion of this under General/AllApplications

----

Well, the good news is that it is not totally undocumented. Tech Note 2029 does mention it. ;-)

http://developer.apple.com/technotes/tn/tn2029.html

----

New in Mac OS X 10.3 is a promising concept called General/UniformTypeIdentifiers (General/UTIs), which serve much the same purpose as MIME types and appear to be designed to replace General/OSTypes.

See General/LaunchServices/General/UTType.h for more information. *--boredzo*

----

I would like to associate my document type (.score) with my Application.  That means I would like the documents created by my application to have my Application Icon.  I would also like to launch my Application when a .score document is double clicked in the finder and open that  document.
Thanks for any input

----

To associate your document and application, modify the application's Info.plist file. You need to add a 'General/CFBundleDocumentTypes' entry. The link below will get you started. Also, look at the Sketch General/AppKit example.

http://developer.apple.com/documentation/General/MacOSX/Conceptual/General/BPRuntimeConfig/Articles/General/PListKeys.html#//apple_ref/doc/uid/20001431-101685

file:///Developer/Examples/General/AppKit/Sketch/Info.plist

-- General/GrahamMiln
----
Thank you for your reply. The 'General/CFBundleDocumentTypes' entry was quickly added in the active target configuration.
What about launching a document that's associated with my application from the finder?  Do I need to implement a certain message signature somewhere in my app to take arguments from the finder?
Thanks again