See [[SafelyNamingFiles]], [[NSStringCategory]], [[NSFileManagerCategory]] http://goo.gl/[[OeSCu]]

----

Or peruse the following function, taken from the [[TextEdit]] source.

<code>
/'' Generate a reasonably short temporary unique file, given an original path. 
''/ 
static [[NSString]] ''tempFileName([[NSString]] ''origPath) { 
	static int sequenceNumber = 0; 
	[[NSString]] ''name; 
	do { 
		sequenceNumber++; 
		name = [[[NSString]] stringWithFormat:@"%d-%d-%d.%@", [[[[NSProcessInfo]] processInfo] processIdentifier], (int)[[[NSDate]] timeIntervalSinceReferenceDate], sequenceNumber, [origPath pathExtension]]; 
		name = [[origPath stringByDeletingLastPathComponent] stringByAppendingPathComponent:name]; 
	} while ([[[[NSFileManager]] defaultManager] fileExistsAtPath:name]); 
	return name; 
} 
</code>

----
Or use a unique identifier as part of the file name:

<code>

[[[[NSProcessInfo]] processInfo] globallyUniqueString]

</code>

this code ''guarantee'' unique string, even across machines ! so file names will always be unique across hosts and network
look at man uuidgen :
     The uuidgen command generates a Universally Unique Identifier (UUID), a
     128-bit value guaranteed to be unique. A UUID is made unique over both
     space and time by combining a value unique to the computer on which it
     was generated--usually the Ethernet hardware address--and a value repre-
     senting the number of 100-nanosecond intervals since October 15, 1582 at
     00:00:00.

----

A race condition exists if you calculate the name and create the file in two different steps. In between those steps, another process could swoop in and create a file with the name you calculated. Probably not likely, but possible.

There's already a standard function called <code>mktemp</code> (<code>man mktemp</code>) to take care of this for you. ''mktemp actually has the same race condition; mk'''s'''temp does not.'' My favorite is <code>mkdtemp</code>, which will generate a unique name for a directory, and create the directory for you, all in one step. It's a C function, so need to use C strings. You need to pass in a C string that the function can modify in place, because it will look for "X" characters at the end of the string, and replace them with random characters to make the file name unique. -[[ChrisCampbell]]

<code>
    char ''template = "/tmp/[[MyApp]].XXXXXX";
    char ''buffer = malloc(strlen(template) + 1);
    strcpy(buffer, template);
    mkdtemp(buffer);
    [[NSString]] ''path = [[[NSString]] stringWithFormat:@"%s", buffer];
    free(buffer);

    // Create files inside of path, which is a directory in /tmp
    // ...

</code>

''Why not just use the static char array <code>template</code>? Cocoa can handle static arrays as easily as dynamic ones, as long as they don't contain objects.''

----

Apple discourages hardcoding "/tmp" instead you should use [[NSTemporaryDirectory]]() to get the temporary directory. (http://developer.apple.com/documentation/[[MacOSX]]/Conceptual/[[BPFileSystem]]/Articles/[[WhereToPutFiles]].html). A better code to get a path to a directory with a unique name would be:

<code>
const char ''buffer = [[[[NSString]] stringWithFormat:@"%@/%@",[[NSTemporaryDirectory]](),@"[[MyApp]].XXXXXX"] cStringUsingEncoding:[[[NSString]] defaultCStringEncoding]];
mkdtemp(buffer);
[[NSString]] ''path = [[[NSString]] stringWithFormat:@"%s", buffer];
</code>

-[[PabloGomez]]

The "const" in <code>const char ''buffer</code> means you're not allowed to modify the contents. So you really need to copy that buffer into something you can change.

Also, it's possible though unlikely that [[NSTemporaryDirectory]] will return a string with non-ASCII characters, so you really should use [[NSString]]'s fileSystemRepresentation methods to convert to/from C strings.

----

Lots of great comments guys. Good catch on the hardcoding /tmp. I notice the mkdtemp man page also hardcodes /tmp. :) I just thought I'd mention a few things: cStringUsingEncoding: requires 10.4, [[NSTemporaryDirectory]]() can return nil, the mkdtemp man page specificaly warns against passing const buffers, the man page does not say what char encoding the string should be in.  Man, writing perfect code is hard. :) -smcbride

Like all BSD calls, mkdtemp accepts UTF8 in the form returned by [[NSString]]'s fileSystemRepresentation. (This isn't necessarily the same as the result from the -UTF8String method... precomposed vs decomposed Unicode, etc.) The bytes it fills in are ASCII. --[[DrewThaler]]

----

Here's my take on the whole thing. I needed to dump out a text file with a specific extension (".ext") to be processed by a command-line tool, then delete the file later. This method will return nil if anything fails, otherwise it returns the path to the temp file to be processed.

<code>
-([[NSString]] '')createTemporaryFileWithUTF8Contents:([[NSString]] '')contents
{
    [[NSAutoreleasePool]] ''pool = [[[[NSAutoreleasePool]] alloc] init];
    [[NSString]] ''td = [[NSTemporaryDirectory]]();
    [[NSString]] ''suffix = @".ext";
    [[NSString]] ''templateString = [[[NSString]] stringWithFormat:@"%@/%@%@",td ? td:@"/tmp",@"[[MyApp]].XXXXXX",suffix];
    [[CFStringRef]] templateStringRef = ([[CFStringRef]])templateString;
    [[NSString]] ''result = nil;
    BOOL success = NO;
    int fd = -1;
    
    // Create an [[NSData]] to hold the template
    unsigned templateDataLength = (unsigned)[[CFStringGetMaximumSizeOfFileSystemRepresentation]](templateStringRef);
    [[NSMutableData]] ''templateData = [[[NSMutableData]] dataWithLength:templateDataLength];
    char ''template = (char'')[templateData mutableBytes];
    if (templateData != nil)
    {
        // Fetch the template into the buffer
        if ([templateString getFileSystemRepresentation:template maxLength:templateDataLength])
        {
            // Create the file. This modifies the template (XXXXXX is replaced by a random string)
            int fd = mkstemps(template, (int)[suffix length]);
            if (fd >= 0)
            {
                // Write the contents into the file.
                [[NSData]] ''contentsData = [contents dataUsingEncoding:NSUTF8StringEncoding];
                unsigned contentsDataLength = [contentsData length];
                if (contentsData != nil)
                {
                    if (write(fd, [contentsData bytes], contentsDataLength) == (ssize_t)contentsDataLength)
                    {
                        if (close(fd) == 0)
                        {
                            result = ([[NSString]] '')[[CFStringCreateWithFileSystemRepresentation]](NULL, template);
                            success = YES;
                        }
                        else
                            [[NSLog]](@"%s close failed! %s", __PRETTY_FUNCTION__, strerror(errno));
                        fd = -1;
                    } else
                        [[NSLog]](@"%s write failed! %s", __PRETTY_FUNCTION__, strerror(errno));
                } else
                    [[NSLog]](@"%s contentsData allocation failed!", __PRETTY_FUNCTION__);
            } else
                [[NSLog]](@"%s mkstemps failed! %s", __PRETTY_FUNCTION__, strerror(errno));
        } else
            [[NSLog]](@"%s getFileSystemRepresentation failed!", __PRETTY_FUNCTION__);
    } else
        [[NSLog]](@"%s templateData allocation failed!", __PRETTY_FUNCTION__);
    
    if (!success && template != nil)
        unlink(template);
    if (fd >= 0)
        close(fd);
    
    // Clean up and return.
    [pool release];
    return [result autorelease];
}
</code>

It checks for nil returns from [[NSTemporaryDirectory]](), drops down to [[CFString]] calls in a few places because [[NSString]] (until 10.4) lacked the appropriate encoding conversions, and it uses an autorelease pool to clean up all the temporary allocations in case you're doing this a large number of times. It also takes care to unlink the file if anything goes wrong. I think the only thing it doesn't do is create the temporary directory if it doesn't exist... however, experiment shows that [[NSTemporaryDirectory]]() will do that these days. --[[DrewThaler]]