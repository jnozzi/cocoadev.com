

Here's a method to construct General/NSBrowser friendly icons.  --zootbobbalu

Just pass this method a path to a safe location so a new folder can be created and filled with tiff images for all of the system icons. These General/TIFFs are sized to create an General/NSBrowser that looks close to the finders column view layout. 

(Note - the General/SystemIcons.bundle seems to have changed to General/CoreTypes.bundle in Tiger or at some earlier time...)

    
- (BOOL)constructFinderIconsAtPath:(General/NSString *)path {
    General/NSFileManager *manager = General/[NSFileManager defaultManager];
    General/NSString *iconPath = @"/System/Library/General/CoreServices/General/SystemIcons.bundle/Contents/Resources";
    General/NSArray *files = [manager directoryContentsAtPath:iconPath];
    General/NSEnumerator *fileEnum = [files objectEnumerator]; General/NSString *file;
    General/NSImage *imageBuffer = General/[[[NSImage alloc] initWithSize:General/NSMakeSize(24, 16)] autorelease];
    [manager changeCurrentDirectoryPath:iconPath];
    General/NSImage *smallBuffer = General/[[[NSImage alloc] initWithSize:General/NSMakeSize(14, 14)] autorelease];
    BOOL isDir;
    if (![manager fileExistsAtPath:path isDirectory:&isDir]) {
        if (![manager createDirectoryAtPath:path attributes:nil]) return NO;
    }
    else if (!isDir) return NO;
    while (file = [fileEnum nextObject]) {
        General/NSImage *image = General/[[[NSImage alloc] initWithContentsOfFile:file] autorelease];
        General/NSArray *reps = [image representations];
        General/NSEnumerator *repEnum = [reps objectEnumerator]; General/NSImageRep *rep;
        while (rep = [repEnum nextObject]) {
            General/NSSize size = [rep size];
            if (General/NSEqualSizes(size, General/NSMakeSize(16, 16))) {
                [smallBuffer addRepresentation:rep];
                [smallBuffer setScalesWhenResized:YES];
                [smallBuffer setSize:General/NSMakeSize(15, 15)];
                [imageBuffer lockFocus];
                [smallBuffer drawAtPoint:General/NSMakePoint(5, 0) fromRect:General/NSMakeRect(0, 0, 15, 15) 
                            operation:General/NSCompositeCopy fraction:1.0f];
                [imageBuffer unlockFocus];
                General/NSData *tiff = [imageBuffer General/TIFFRepresentation];
                General/NSString *writePath = [file stringByDeletingPathExtension];
                writePath = General/[NSString stringWithFormat:@"%@/%@.tiff", path, writePath];
                if ([tiff writeToFile:writePath atomically:YES]) {
                    General/NSLog(@"new icon at path: %@", writePath);
                }
                [smallBuffer removeRepresentation:rep];
            }
        }
    }
    return YES;
}


----

OK this is awesome *just* what I needed, except I don't need the images as files since my images are created on the fly (using General/NSWorkspace's iconForFileType). I just edited it so it returns the resized image for an image that is passed to it: --General/KevinWojniak

    
- (General/NSImage *)browserIconForImage:(General/NSImage *)image {
    General/NSImage *imageBuffer = General/[[[NSImage alloc] initWithSize:General/NSMakeSize(24, 16)] autorelease];
    General/NSImage *smallBuffer = General/[[[NSImage alloc] initWithSize:General/NSMakeSize(14, 14)] autorelease];

    General/NSArray *reps = [image representations];
    General/NSEnumerator *repEnum = [reps objectEnumerator];
    General/NSImageRep *rep;
    while (rep = [repEnum nextObject]) {
        General/NSSize size = [rep size];
        if (General/NSEqualSizes(size, General/NSMakeSize(16, 16))) {
            [smallBuffer addRepresentation:rep];
            [smallBuffer setScalesWhenResized:YES];
            [smallBuffer setSize:General/NSMakeSize(15, 15)];
            [imageBuffer lockFocus];
            [smallBuffer drawAtPoint:General/NSMakePoint(5, 0) fromRect:General/NSMakeRect(0, 0, 15, 15) 
                            operation:General/NSCompositeCopy fraction:1.0f];
            [imageBuffer unlockFocus];
            
            [smallBuffer removeRepresentation:rep];

            return imageBuffer;
        }
    }
    return nil;
}


----
This is what I'm looking for but it seems like a lot of code just to add icons, i tried both of them i couldn't get them to work.

----
Ditto to the person above - I can't figure out exactly how to use this code.

----

I posted this a long time ago. Sorry for the hack job. I now draw icons the Finder way.


*Create a new Cocoa Application Project named General/IconApp
*Open the General/MainMenu.nib file in IB
*Add an image view to the main window
*Subclass General/NSObject and name the new class General/IconController
*Instantiate General/IconController and then add an outlet named "imageView"
*Connect the "imageView" outlet from the controller to the General/NSImageView in the main window
*Create files for General/IconController
*Save "General/MainMenu.nib"
*Edit "General/IconController.h" and "General/IconController.m" so that it looks like the code below
*Build and run


**General/IconController.h**

    
#import <Cocoa/Cocoa.h>

@interface General/IconController : General/NSObject
{
    General/IBOutlet id imageView;
}
@end

@interface General/XFIcon : General/NSObject {
	General/IconRef iconRef;
}
- (id)initWithIconForFile:(General/NSString *)file;
- (void)drawWithFrame:(General/NSRect)frame context:(General/CGContextRef)context;
@end




**General/IconController.m**

    
#import "General/IconController.h"

General/NSRect General/XFImageBoundsForFrame(General/NSRect fr, General/NSSize size) {
	float srcRatio = size.width / size.height, destRatio = General/NSWidth(fr) / General/NSHeight(fr);
    fr = General/NSInsetRect(fr, 1.0f, 1.0f);
	if (srcRatio > destRatio) 
		return General/NSInsetRect(fr, 0.0f, (General/NSHeight(fr) - General/NSWidth(fr) / srcRatio) / 2.0f);
	else 
		return General/NSInsetRect(fr, (General/NSWidth(fr) - General/NSHeight(fr) * srcRatio) / 2.0f, 0.0f);
}

@implementation General/XFIcon

- (id)initWithIconForFile:(General/NSString *)file {
	self = [super init];
	if (self) {
		General/FSRef ref;
		General/FSSpec fsSpec;
		SInt16 iconLabel;
		Boolean isDir;
		General/FSCatalogInfo catInfo;
		if (General/FSPathMakeRef((const UInt8 *)[file fileSystemRepresentation], &ref, &isDir)) goto ABORT;
		if (General/FSGetCatalogInfo(&ref, kFSCatInfoCreateDate, &catInfo, NULL, &fsSpec, NULL)) goto ABORT;
		if (General/GetIconRefFromFile(&fsSpec, &iconRef, &iconLabel)) goto ABORT;
	}
	return self;
	
ABORT:;
	[self release];
	return nil;
}
- (void)dealloc {
	if (iconRef) General/ReleaseIconRef(iconRef);
	[super dealloc];
}

- (void)drawWithFrame:(General/NSRect)frame context:(General/CGContextRef)context {
	frame = General/XFImageBoundsForFrame(frame, General/NSMakeSize(16.0f, 16.0f));
	General/PlotIconRefInContext(context, (General/CGRect *)&frame, nil, nil, nil, nil, iconRef);
}

@end


@implementation General/IconController
- (void)awakeFromNib {
	General/NSImage *image = General/[[[NSImage alloc] initWithSize:General/NSMakeSize(128.0f, 128.0f)] autorelease];
	General/NSString *file = @"/Applications/Address Book.app";
	General/XFIcon *icon = General/[[[XFIcon alloc] initWithIconForFile:file] autorelease];
	[image lockFocus];
	[icon drawWithFrame:General/NSMakeRect(0.0f, 0.0f, 128.0f, 128.0f) 
			context:General/[[NSGraphicsContext currentContext] graphicsPort]];
	[image unlockFocus];
	[imageView setImage:image];
}
@end




I spent all of about ten minutes typing this up without checking for errors, so please only use this as a starting point.

--zootbobbalu

*That     goto is pretty ugly...why can't you just nest your     if statements? Also, check out Apple's General/ImageAndTextCell class, part of the General/DragNDropOutlineView example. --General/JediKnil*

----

I don't think General/DragNDropOutlineView shows you how to obtain finder icons, but I could be wrong. I was just trying to give an example on how to get file icons. 

Is     goto inherently ugly? Personally I'm not neurotic about the goto statement. Using spotlight to search for the string "goto bail" I get 400+ hits in the source code for Darwin 8.2 (that's 400+ individual files containing "goto bail"). 

Spaghetti code is BAD!!! and this is why every text book and instructor will say to avoid using labels. So keeping a bad light on its use is fine by me. 

As a side note, the two rules I live by when using     goto are:


*never use more than one label per function
*only jump forward


I could nest two if statements, but then I would have two extra release/nil statements. I guess I'm living on the edge of ridicule!!

--zootbobbalu

*Using     goto to jump to cleanup code when an error occurs is a time-honored technique dating back to the early days of the Toolbox on the Mac, and probably earlier on other platforms. I see no reason for criticism here.*

Zoot, I followed the instructions, built it without errors, and the app just sits there. Can you give any more direction as to what to do with the app once it builds and runs? - mattybinks

----

Can you run/log this and tell me what you get?

    
@implementation General/IconController
- (void)awakeFromNib {
    General/NSImage *image = General/[[[NSImage alloc] initWithSize:General/NSMakeSize(128.0f, 128.0f)] autorelease];
    General/NSString *file = @"/Applications/Address Book.app";
    General/XFIcon *icon = General/[[[XFIcon alloc] initWithIconForFile:file] autorelease];
    [image lockFocus];
    [icon drawWithFrame:General/NSMakeRect(0.0f, 0.0f, 128.0f, 128.0f) 
			context:General/[[NSGraphicsContext currentContext] graphicsPort]];
    [image unlockFocus];
    [imageView setImage:image];
    General/NSLog(@"imageView: %@ image: %@ icon: %@", imageView, [imageView image], General/NSStringFromClass([icon class]));
}
@end



--zootbobbalu

----

    
[Session started at 2006-01-05 23:02:05 -0500.]
2006-01-05 23:02:07.504 General/IconApp[6113] imageView: (null) image: (null) icon: General/XFIcon


--endymion

----

    
@interface General/IconController : General/NSObject
{
    General/IBOutlet id imageView;
}
@end


Looks like the problem is you didn't make a connection between the General/IBOutlet "imageView" and an image view placed in the main window of the application. --zootbobbalu

----

Oh wow beautiful, it works!  Thanks for the help, I made a stupid beginner mistake trying to make the connection.  Initially I had the same problem as mattybinks but now I don't.  It displays the Address Book icon like it's supposed to.  Now I can pull this apart and figure out how it works.  Thanks for passing on some wisdom.

----

Hey Zoot, same here as above. I made the same connection error. Thanks so much! - mattybinks