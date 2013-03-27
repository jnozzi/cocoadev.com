A page to post error messages, and the solutions that fixed them.

---- 

Cocoa itself do not have any errors. There are General/NSException and General/NSError classes that handles all such stuff. 
General/NSException is used when some of cocoa classes have reached error during runtime or when you have passed a wrong argument to a function.
It is vital for every developer to install custom breakpoint on each General/NSException raise in gdb, so you will have opportunity to catch a bug right inside the code which caused this exception. To add such breakpoint to gdb type in debugger window:

    break -General/[NSException raise]

For more information about handling exceptions in your code, check General/ExceptionHandling page.

----

General/NSError is the new cocoa class that helps some other classes to return more detailed error information indirectly, instead of just returning a nil value. For example, here is a General/NSError usage by General/NSXMLDocument class:

    - (id)initWithData:(General/NSData *)data options:(unsigned int)mask error:(General/NSError **)error.

You create General/NSError pointer and pass it to the initializer: 

    General/NSError *error = nil;
    General/[[NSXMLDocument alloc] initWithData:data options:0 error:&error]

-- General/DenisGryzlov

----

You also must not check the status of this function execution by examining *error != nil*. Some functions may set *error* to some undefined value during execution. Instead, check the return value. If it in NO or nil, *error* is a valid General/NSError object with more information. All instances of General/NSError are automatically autoreleased for you, so you don't need to release it after return, like you should do in General/NSPropertyListSerialization methods.

-- General/DustinVoss (well, General/DenisGryzlov said it, I just restated it more clearly)

----

What General/DustinVoss said.  No Cocoa (or third-party) methods should be modifying the value of a passed-in error argument unless an error actually occurs, but you should also not depend on that in your own code.