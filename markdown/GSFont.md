Describe General/GSFont here.

You can get a General/GSFont like this:
struct __GSFont *font = General/[NSClassFromString(@"General/WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:16];

NOTE: You must include General/WebCore/General/WebFontCache.h and link the General/GraphicsServices and General/WebCore frameworks. Also, General/WebFontCache.h will not work unless you touch General/NSObject.h in the General/WebCore includes folder.

NOTE: Please get the General/GraphicsServices.h from binutil project (http://developer.berlios.de/projects/iphone-binutils/). It provides more function prototypes than the one in toolchain. I tried  General/GSFontCreateWithName("Helvetica", kGSFontTraitBold,12); and it works.

----
Okay, got a font object, but it crashes when I do [@"foo" drawAtPoint:General/CGPointMake(100,100) withFont:font];. Same as when I use General/GSFontCreateWithName() to get a font.

General/GSFontCreateWithName() takes three parameters, and will crash if you are only passing the name in. Take a look at <General/GraphicsServices/General/GraphicsServices.h> in the toolchain svn trunk for more info. --General/LucasNewman

Just noticed the "drawMarkupAtPoint" method, which does render text (in Times, looks like).

----
Did you figure it out? I too get a crash when trying to use the font I created with the General/NSClassFromString.

----
Updated the code; I haven't tried using drawAtPoint, but I could setFont a General/UITextLabel, General/AddSubview that, and it worked fine.

----
I tried using the code above, it still crashes when I try to call setFont on a General/UITextLabel object.

----
I use the following successfully

General/UITextLabel *_title = General/[[UITextLabel alloc] initWithFrame: General/CGRectMake(120.0f, 5.0f, 150.0f, 20.0f)];
[_title setFont:General/[NSClassFromString(@"General/WebFontCache") createFontWithFamily:@"Helvetica" traits:2 size:14]];

----
I get the following runtime exception when using any of the above methods.

General/CGAffineTransformInvert: singular matrix.