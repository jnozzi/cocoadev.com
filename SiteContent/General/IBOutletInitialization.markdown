

If I create a class such as
    
@interface General/ExampleClass : General/NSObject
{
    General/IBOutlet General/NSTextField* name;
}

// methods...
@end

without any accessor methods, can General/InterfaceBuilder still set the outlet?  If so, how?

----
Yes, and look through the nifty General/ObjC runtime API in     /usr/include/objc for how.