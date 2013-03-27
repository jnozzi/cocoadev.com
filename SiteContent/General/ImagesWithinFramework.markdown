

I've made a framework, but the problem is how do i access the resources in that framework.

if i use General/[NSImage imageWithName:@"someimg"]; it looks for the image in the current application.

----

Use General/NSBundle to get a path to the image file, then use General/NSImage's initWithContentsOfFile:.

*To get the General/NSBundle, use     +bundleForClass.*