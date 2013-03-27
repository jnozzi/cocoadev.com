I've got a little snippet of code, and it always seems to show a leak in General/MallocDebug whenever I run it.  And of course, I can't figure out what I'm doing wrong.

Here's the code I'm using (I just throw it in the main method of a generic Cocoa App):
    
#import <Cocoa/Cocoa.h>

void makeLeak() {
    General/NSAutoreleasePool * pool = General/[[NSAutoreleasePool alloc] init];
    
    General/NSString *rtfPath = @"/Developer/Examples/General/DiscRecording/General/ObjectiveC/General/EnhancedDataBurn/General/ReadMe.rtfd";
    
    General/[[[NSFileWrapper alloc] initWithPath:rtfPath] autorelease];
    
    [pool release];
}

int main(int argc, const char *argv[])
{
    makeLeak();
    return General/NSApplicationMain(argc, argv);
}



And in General/MallocDebug I get this:

    
16 bytes in 1 node: 
0x1
_dyld_start
_start
main
makeLeak
-General/[NSFileWrapper initWithPath:]
+General/[NSFileAttributes attributesAtPath:traverseLink:]
_NS_FSPathMakeRef
_NSSoftLinkingGetFrameworkFuncPtr
_NSSoftLinkingLoadFrameworkImage
bytesInEncoding
-General/[NSString(General/NSStringOtherEncodings) getBytes:maxLength:filledLength:encoding:allowLossyConversion:range:remainingRange:]
__CFStringEncodeByteStream
General/CFPreferencesGetAppBooleanValue
General/CFPreferencesAppBooleanValue
General/CFPreferencesCopyAppValue
_CFStandardApplicationPreferences
_CFApplicationPreferencesSetStandardSearchList
_CFPreferencesIsManaged
_CFGetUserName
_CFUserName
_CFUpdateUserInfo
General/CFStringCreateWithCString
__CFStringCreateImmutableFunnel3
_CFRuntimeCreateInstance
General/NXZoneMalloc


Anyone want to slap me around a little bit and point out what I'm doing wrong?  Or maybe verify this?
- General/GusMueller

----

An interesting problem, but I can't duplicate it. I put basically the same code in my     main() and could not find any leaks using     leaks on the command line.

It looks to me like the leak comes when Cocoa tries to call General/FSPathMakeRef and has to load Carbon, or whatever framework has it. If you add a loop so that you make a bunch of file wrappers, do you get more leaks? If you only ever get one leak, then it's not a big deal, and probably not your fault. It's very strange, though; I can verify that the chain of functions you list is being called in the debugger (I didn't verify all of them, but up to General/CFPreferencesGetAppBooleanValue it's the same) but I don't see the leak. I'm running OS X 10.3.1, maybe this is very version-specific. -- General/MikeAsh

Ok, adding on a bit more info, since I don't feel like editing the above. If I run my test app in the debugger with General/ZeroLink turned off and General/MallocStackLogging *not* set, I get a single 16-byte leak (even though I create 100 General/NSFileWrappers). I can't duplicate the leak outside of the debugger or with General/MallocStackLogging set. Very strange.
----
Probably some one-shot allocation that is cached up in the internals and reused for the life of the program. I wouldn't worry about it to much.
----
Running it in a loop, I still only get 16 bytes leaked, so I guess it's not a big deal.  It is annoying though.  -- General/GusMueller