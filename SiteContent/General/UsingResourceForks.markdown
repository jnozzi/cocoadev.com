

[[ResourceForks]] were common under Classic applications, but they were unsupported by any other platform than [[MacOS]]. I'd like to be able to modify [[ResourceForks]] and read data from them from Cocoa, and if possible the new .rsrc files which have the [[ResourceFork]] data in the [[DataFork]].

Perhaps the easiest way to do this would be to create an Obj-C wrapper to the Carbon [[APIs]]? Anybody have any other ideas? Has someone else done it yet? Is there some class I've blatantly overlooked?

-- [[FinlayDobbie]]

----

You can go ahead and make the resource fork calls in your Cocoa code. An [[ObjC]] wrapper sounds like a fine programming experiment, but personally I don't have much use for such a thing. I want to move away from this legacy data format ...

Here's some code that illustrates opening a data-fork resource file from Cocoa. Note the use of [[NSBundle]] and [[NSString]]. This code came from a screen saver module, so I look up the class from [self class]. You'll probably want to use the app's main bundle.

<code>
// open our resource fork, if it exists ...
path = [[[[NSBundle]] bundleForClass:[self class]] pathForResource:@"resources" ofType:@"rsrc"];
if (path) {
    [[FSRef]] fsRef;

    if (![[FSPathMakeRef]]([path UTF8String], &fsRef, NULL)) {
        [[OSErr]] err;

        err = [[FSOpenResourceFile]](&fsRef, 0, NULL, (SInt8)fsRdPerm, &resourceRef);
        if (err) {
            [[NSLog]](@"can't load '%@': %d", path, err);
            // force _resourceRef of 0 to mean we didn't open the file.
            resourceRef = 0;
        }
    } else {
        [[NSLog]](@"couldn't make [[FSRef]] for %@", path);
    }
} else {
    [[NSLog]](@"couldn't find resources.rsrc");
}
</code>

Mind you you'll still have to use the normal resource calls to actually get data out of the file. That's where your [[ObjC]] wrapper will get interesting.

-- [[MikeTrent]]

----

Oh, and once you have a nice Obj-C wrapper for resource forks, you might want to distribute the class in the [[MiscKit]]. See http://www.misckit.com. That's a great way (the best way?) to share this code with the Cocoa community.

-- [[MikeTrent]] 

----

Thanks for the hints, Mike. I might do some basic [[ResourceFork]] code this summer, when I have some free time. Is [[MiscKit]] under development any more? The last announcements seem to be from years ago, and does it even compile for OS X v10.0?

-- [[FinlayDobbie]]

----

I posted the source to a class, [[GTResourceFork]], that encapsulates much resource fork work and is, for the most part, thread-safe. http://www.ghosttiger.com/?p=117 I welcome suggestions and improvements in the blog comments, but please, no spiced ham. :) -[[JonathanGrynspan]]