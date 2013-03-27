I've downloaded an HTML file into an General/NSData, but I don't know how to put the data in an General/NSString. I'm using Panther, by the way.

----
    General/[[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:*someEncoding*]

If you don't know the encoding, consider using     -General/[NSString initWithContentsOfURL:usedEncoding:error:] instead of pulling your HTML into an General/NSData.
----
initWithContentsOfURL only works for Tiger. Thanks. On the site, it says that the charset is windows-1252. That's N<nowiki/>SWindowsCP1252StringEncoding, right?

----

Yep, otherwise known as Windows Latin-1.  You could also check the General/WebKit framework for encoding-aware HTML download. I bet there's something there.

----

Actually, Apple says that General/WebKit is "not suitable for implementing non-GUI applications".