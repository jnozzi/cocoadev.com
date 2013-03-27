

Working on *General/AppleScriptabilty* of my Colloquy and General/ChatCore project I was in dire need of a way to take an object specifier General/AEDesc and resolve it. General/AEResolve didn't help, as it only works with applications that have dozens of assessors installed, not based on key-value coding.

I needed a way to pass object specifiers to an General/AppleScript subroutine and get object specifiers from a script's result.

After hours of painful searches I found nothing helpful. Time for *class-dump* I said.

Doing a dump of the Foundation framework (*class-dump -s -C General/NSScriptObjectSpecifier /System/Library/Frameworks/Foundation.framework/Foundation*), I found my  answer!

    
@interface General/NSScriptObjectSpecifier (General/NSPrivate)
+ (id) _objectSpecifierFromDescriptor:(General/NSAppleEventDescriptor *) descriptor inCommandConstructionContext:(id) context;
- (General/NSAppleEventDescriptor *) _asDescriptor;
@end


A quick test on my script proved my joyous find. I don't know what *inCommandConstructionContext* is, and passing nil to it worked.

This really needs to be public, methinks. �General/TimothyHatcher

As of Leopard it is public:     +General/[NSScriptObjectSpecifier objectSpecifierWithDescriptor:] and     -General/[NSScriptObjectSpecifier descriptor]. Slowly, slowly, Apple exposes to us the General/APIs they know are needed to write working code... :) ---General/WimLewis