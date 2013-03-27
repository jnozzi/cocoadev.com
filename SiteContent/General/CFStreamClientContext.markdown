Defined as:

    
struct General/CFStreamClientContext {
   General/CFIndex version;
   void *info;
   void *(*retain)(void *info);
   void (*release)(void *info);
   General/CFStringRef (*copyDescription)(void *info);
} General/CFStreamClientContext;
 

In the "Working with Streams" section of the General/CFNetwork guide, the example uses custom function pointers as listed below:

    
General/CFStreamClientContext myContext = {0, myPtr, myRetain, myRelease, myCopyDesc};
 

It's much easier, and just as valid to use the built in General/CoreFoundation functions:

    
General/CFStreamClientContext myContext = {
    0,
    self,
    (void *(*)(void *info))General/CFRetain,
    (void (*)(void *info))General/CFRelease,
    (General/CFStringRef (*)(void *info))General/CFCopyDescription
};
