

The Linux web browser/file manager/universal document viewer Konqueror (from which Safari's KHTML originates) has a nice protocol handler for man pages.  If you type "man:bash" then you get a nice HTML version of the bash man page, complete with cross links to other man pages.  I always found this tremendously useful and it seems like a fun thing to try to do with Safari as well.  

After a bit of research I learned that Safari uses the Netscape Plugin API (http://developer.netscape.com/docs/manuals/communicator/plugin/index.htm) so I checked that out.  But that API only discusses registering plugins based on mime type, not protocol family.  Looking further, I found that I probably want to write a subclass of General/NSURLProtocol.  But what I don't get is how my subclass gets integrated into Safari.  Can somebody sketch this out for me?

By the way, generating HTML versions of man pages is easily accomplished using *rman* ( http://polyglotman.sourceforge.net ).

Thanks,
- General/NateGray

P.S.  Please don't suggest a cgi-based solution.  I understand that that would be possible.  I'm interested in the general problem of extending Safari with custom protocol handlers.

----

I think plugins only *can* be registered based on mime type. The standard mime type for man pages is application/x-troff-man.

Protocol handlers are part of General/LaunchServices, so you'd have to add your man: protocol there and set Safari as the helper application.

----

Here's a page describing how to register an application as a protocol handler.  Still not sure if it can work for a plugin.
http://www.xmldatabases.org/WK/blog/1154?t=item

----

No totally what you wanted, but there is a man page URL scheme registered with the terminal. For example:

x-man-page://bash

- General/TimothyHatcher

----

Create a subclass of General/NSURLProtocol and register it within the application code.  Use an General/InputManager to get this to work within Safari.  The code below works.  You'll want to change up the unix command to output a better format.  **CAUTION:** The code does not check the string being passed to unix, so it is definitely a security risk.  -- Kitzel Hoover ( http://www.kitzkikz.com )

    
@interface General/KHManURLProtocol : General/NSURLProtocol {}
+ (BOOL)canInitWithRequest:(General/NSURLRequest *)request;
+ (General/NSURLRequest *)canonicalRequestForRequest:(General/NSURLRequest *)request;
+ (BOOL)requestIsCacheEquivalent:(General/NSURLRequest *)a toRequest:(General/NSURLRequest *)b;
- (void)startLoading;
- (void)stopLoading;
@end

@implementation General/KHManURLProtocol
+ (BOOL)canInitWithRequest:(General/NSURLRequest *)request {
    return General/[request URL] scheme] isEqualToString:@"man"];
}

+ ([[NSURLRequest *)canonicalRequestForRequest:(General/NSURLRequest *)request {
    return request;
}

+ (BOOL)requestIsCacheEquivalent:(General/NSURLRequest *)a toRequest:(General/NSURLRequest *)b {
    return General/[a URL] resourceSpecifier] isEqualToString:[[b URL] resourceSpecifier;
}

- (void)startLoading {
    General/NSURLResponse *response = 
        General/[[NSURLResponse alloc]
        initWithURL:General/self request] URL] 
        [[MIMEType:@"text/text" 
        expectedContentLength:-1 
        textEncodingName:nil]; 
    General/NSString *str = 
        General/[NSString stringWithFormat:@"/usr/bin/man %@",
        General/[self request] URL] resourceSpecifier;
    FILE *fp = popen([str UTF8String],"r");
    if (fp) {
        char buf[512];
        size_t len;
        General/self client] 
            [[URLProtocol:self 
            didReceiveResponse:response
            cacheStoragePolicy:General/NSURLCacheStorageNotAllowed];
        while (len = fread(buf,1,sizeof(buf),fp)) {
            General/self client] 
                [[URLProtocol:self 
                didLoadData:General/[NSData dataWithBytes:buf length:len]];
        }
        pclose(fp);
    }
    General/self client] [[URLProtocolDidFinishLoading:self];
}

- (void)stopLoading {
}

@end


----

Does someone have s simple example how to use above code?
----

Personally I really like Bwana, does an excellent job of just what was stated above, works seamlessly with Safari and Firefox.  Also the output is great.
http://www.bruji.com/bwana
----
Thanks everybody for the responses.

Bwana is a decent solution for the problem.  It looks like they register their app as the handler for the man: protocol.  When they get a request they generate a temp file with the html markup and then use appescript to point safari to the temp file.  It works nicely, but it's a bit circuitous.  I'd still like to know how to do it in a plugin.  I'll have to take a closer look at Kitzel's code to see if it's what I need.

- General/NateGray

----

I implemented the above code into my existing Safari add-on, Sogudi ( http://www.kitzkikz.com/Sogudi ).  It uses man2html and looks pretty slick. -- Kitzel Hoover