Apple's documentation:
http://developer.apple.com/documentation/General/CoreFoundation/Reference/General/CFStringRef/Reference/reference.html
----

Thanks to General/TollFreeBridging a General/CFStringRef is equivalent to an General/NSString*

    
// Casting a General/CFStringRef to an General/NSString object:
General/CFStringRef cfString;
General/NSString *nsString = (General/NSString*)cfString;


    
// Casting an General/NSString object pointer to a General/CFStringRef:
General/NSString *nsString;
General/CFStringRef cfString = (General/CFStringRef)nsString;


But don't forget to call General/CFRelease on General/CFStringRef**s created using General/CoreFoundation methods when you're done with it! eg. General/CFStringCreate(...)
An example is when converting General/PascalString's to General/NSString's, as only General/CoreFoundation methods exist to do so.