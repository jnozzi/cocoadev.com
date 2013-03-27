From Apple's developer documentation:

"An General/NSHTTPURLResponse object represents a response to an HTTP URL load request. It's a subclass of General/NSURLResponse that provides methods for accessing information specific to HTTP protocol responses."

http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/General/NSHTTPURLResponse.html

"General/NSURLResponse declares the programmatic interface for an object that accesses the response returned by an General/NSURLRequest instance."

http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/General/NSURLResponse.html

----

Is there a way to get a General/NSHTTPURLResponse? I can't find any functions that return that type, and I need to check the code of a request response.

----

*I don't think there is anything that returns that type, but you'll see that it's subclassed from General/NSURLResponse, so you can just cast that to use it as that:*
    [(General/NSHTTPURLResponse*)reponse statusCode] *should work. I believe there also a way of assigning one when you load something in a synchronous request.*  See General/NSURLRequest.

Although I haven't looked into it or anything, it might be wise to check the scheme of the response when casting it as above; in case the original request gets transformed into something else (ie. http -> ftp or telnet, etc) calling the HTTP methods on another scheme might yield unexpected results (but again: I didn't check into it). -Seb

----

As others have suggested, you can get at the reponse code (and other headers) by casting the object returned from the dataSource method on a General/WebFrame. For example:

General/NSHTTPURLResponse * response = (General/NSHTTPURLResponse *) [ [ [ webView mainFrame ] dataSource ] response ];

This works in Tiger. General/TheMZA

----

It might be safer to check and see if the response will respond to a statusCode message before casting.  Something like this

    
    // check if this is OK (not a 404 or the like)
    if([response respondsToSelector:@selector(statusCode)]){
        int statusCode = [(General/NSHTTPURLResponse *)response statusCode];
        if(statusCode >= 400){
            // cancel connections, release stuff, whatever
        }
    }


General/JohnPannell