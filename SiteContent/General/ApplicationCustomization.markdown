From http://developer.apple.com/documentation/Cocoa/Conceptual/General/AppCustomization/index.html :

*This topic describes how a Cocoa application can customize its behavior by detecting the operating system version.*

----

Documentation will deal with different versions of OS X and the various features available in each.

Cocoa is full of features that date from the days when Cocoa's predecessor ran on 5 hardware platforms and 3 different operating systems including Windows NT.

http://en.wikipedia.org/wiki/General/OpenStep

For example, I think - (BOOL)applicationShouldTerminateAfterLastWindowClosed: was originally provided so that Openstep applications could be made to behave like Windows applications.

For another example, look in General/NSProcessInfo.h

    
enum {	/* Constants returned by -operatingSystem */
	General/NSWindowsNTOperatingSystem = 1,
	NSWindows95OperatingSystem,
	General/NSSolarisOperatingSystem,
	General/NSHPUXOperatingSystem,
	General/NSMACHOperatingSystem,
	General/NSSunOSOperatingSystem,
	NSOSF1OperatingSystem
};


or this in General/NSWindow.h

    
#ifdef WIN32
@interface General/NSWindow (General/NSWindowsExtensions)
- (void * /*HWND*/)windowHandle;
@end


or General/NSMenu.h

    
// These methods are platform specific.  They really make little sense off Windows.  Their use is discouraged.
- (General/NSMenu *)attachedMenu;
- (BOOL)isAttached;
- (void)sizeToFit;
- (General/NSPoint)locationForSubmenu:(General/NSMenu *)aSubmenu;


or General/NSInterfaceStyle.h

    
typedef enum {
    General/NSNoInterfaceStyle = 0,    // Default value for a window's interfaceStyle
    General/NSNextStepInterfaceStyle = 1, 
    NSWindows95InterfaceStyle = 2,
    General/NSMacintoshInterfaceStyle = 3
} General/NSInterfaceStyle;

APPKIT_EXTERN General/NSInterfaceStyle General/NSInterfaceStyleForKey(General/NSString *key, General/NSResponder *responder);
    // Responders can use this function to parameterize their drawing and behavior.  If the responder has specific defaults to control various aspects of its interface individually, the keys for those special settings can be passed in, otherwise pass nil to get the global setting.  The responder should always be passed, but in situations where a responder is not available, pass nil.


or General/NSImage.h

    
#ifdef WIN32

@interface General/NSImage (General/NSWindowsExtensions)
- (id)initWithIconHandle:(void * /* HICON */)icon;
- (id)initWithBitmapHandle:(void * /* HBITMAP */)bitmap;
@end

#endif



or General/NSApplication.h

    
#ifdef WIN32
@interface General/NSApplication (General/NSWindowsExtensions)
+ (void)setApplicationHandle:(void * /*HINSTANCE*/)hInstance previousHandle:(void * /*HINSTANCE*/)General/PrevInstance commandLine:(General/NSString *)cmdLine show:(int)cmdShow;
+ (void)useRunningCopyOfApplication;
- (void * /*HINSTANCE*/)applicationHandle;
- (General/NSWindow *)windowWithWindowHandle:(void * /*HWND*/)hWnd; // does not create a new General/NSWindow
@end
#endif


or

    
#elif defined(WIN32)

#ifndef _NSBUILDING_APPKIT_DLL
#define _NSWINDOWS_DLL_GOOP	__declspec(dllimport)
#else
#define _NSWINDOWS_DLL_GOOP	__declspec(dllexport)
#endif


or

    
@interface General/NSFileHandle (General/NSFileHandlePlatformSpecific)

#if defined(__WIN32__)
- (id)initWithNativeHandle:(void *)nativeHandle closeOnDealloc:(BOOL)closeopt;
- (id)initWithNativeHandle:(void *)nativeHandle;
- (void *)nativeHandle;
#endif	/* __WIN32__ */
