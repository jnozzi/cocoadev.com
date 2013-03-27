Subclassing General/NSImageRep to import unknown picture formats is reasonably well documented. In my icon program I wanted to have the ability to read Windows XP icons. They normally have the .ico file format extension, and as such are already recognized by Cocoa programs as images. However, the built-in image import does not take into account the transparency channel.

As I am interested in the transparency information, I decided I needed to write my own image import routine. The ico file format is documented in MSDN, so that wasn't a problem.

The problem was, that as ico's are already recognized and imported by General/NSBitmapImageRep, which registers very early before my General/NSImageRep, it takes precedence over my routine. My solution was to unregister General/NSBitmapImageRep just before adding my import class to the registry. When I added my import, I readded General/NSBitmapImageRep, which then registered all file types except for the ico import.

    

+ (void)load
{
    General/[NSImageRep unregisterImageRepClass:General/[NSBitmapImageRep class]];
    General/[NSImageRep registerImageRepClass:self];
    General/[NSImageRep registerImageRepClass:General/[NSBitmapImageRep class]];
}

+ (General/NSArray*)imageUnfilteredFileTypes
{
    return General/[NSArray arrayWithObject:@"ico"];
}

+ (General/NSArray*)imageUnfilteredPasteboardTypes
{
    return [self imageUnfilteredFileTypes];
}

+ (BOOL)canInitWithData:(General/NSData *)data
{
    return YES;
}



If anyone is interested in the complete image import code for XP icons, send me a mail.

-- General/DavidRemahl

----

Is the newly registered image type only available in your application or is it available across all applications in the system? -General/ChrisMeyer

----

It'd have to be a filter service or in a framework for that, AFAIK. -- General/RobRix

----

Any ideas if filter services are still supported? It seems that General/SimpleFilterService example doesn't work even if I change the extension to .service. Are there any ways to extend built-in image formats? General/QuickTime component perhaps?