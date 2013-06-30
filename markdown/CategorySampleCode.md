**Implementing General/ClassCategories**

This sample code comes from a mailing list post by Uli Zappe and shows how to implement General/ClassCategories:


**General/MySillyStringAddition.h**
----
    
 #import <Foundation/NSString.h>
 
 @interface NSString (MySillyStringAddition)
 
 - (NSString *)sillyMethodThatReturnHello;
 
 @end



**General/MySillyStringAddition.m**
----
    
 #import "MySillyStringAddition.h"
 
 @implementation NSString (MySillyStringAddition)
 
 - (NSString *)sillyMethodThatReturnHello
 	{
 		return @"Hello";
 	}
 
 @end


----

See also General/KissyFaceView for an example of hiding private API using General/ClassCategories.  You may also want to see General/CocoaDevUsersAdditions for more keen categories.
----
I'm not sure of the value of this example but it was meant to serve as an example of what could usefully? be done, it's based on some General/SmallTalk code I once saw.

**General/URLString.h**

Add a Category so that a General/NSString can return the contents of a Web page as General/NSString.

    
 #import <Foundation/NSString.h>
 
 @interface NSString (asURL)
 - (NSString *)asURL;
 @end

 
**General/URLString.m**
    
 #import <Foundation/Foundation.h>
 #import "URLString.h"
 @implementation NSString (asURL)
 - (NSString *)asURL
 {
   NSURL *url = [NSURL URLWithString: self ];
   NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL: url
                                                          cachePolicy: NSURLRequestReloadIgnoringCacheData
                                                      timeoutInterval: 10];
   
   NSURLResponse *response;
   NSError *error;
   NSData *data = [NSURLConnection
                    sendSynchronousRequest: request
                    returningResponse: &response
                    error: &error];
   
   NSString *output = [NSString stringWithCString:[data bytes] length:[data length]];
   
   if (error) {
     NSLog(@"%@", error);
   }
   
   return [output autorelease];
 }
 @end

**main.m**

Example of silly use.

    
 #import <Foundation/Foundation.h>
 #import "URLString.h"
 int main (int argc, const char * argv[]) {
   NSAutoreleasePool * pool = General/NSAutoreleasePool alloc] init];
   
   NSString *page = [@"http://www.google.com" asURL];
   NSLog(@"Page = %@", page);
   
   [pool release];
   return 0;
 }

*Ahh, [[StringWithCString strikes again! Please don't use it, it is evil.*


General/Category:CocoaDevUsersAdditions