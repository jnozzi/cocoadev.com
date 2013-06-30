

I know we haven't finished with General/HowDoIDoRadioButtonsWithRegularButtons, but this has driven me crazy all day long. I can't seem to get this code to work.

General/AmpersandArt.h:
    
/*
----------------------------------
Saratoga v1.0
----------------------------------
AMPERSAND LABORATORIES
----------------------------------
Ampersand Art Data Interface
----------------------------------
*/

#import <Cocoa/Cocoa.h>


@interface General/AmpersandArt : General/NSObject {
	General/NSMutableArray *layers;
}
- (General/NSMutableArray *)layers;
@end


General/AmpersandArt.m:
    
/*
----------------------------------
Saratoga v1.0
----------------------------------
AMPERSAND LABORATORIES
----------------------------------
Ampersand Art Data Implementation
----------------------------------
*/

#import "General/AmpersandArt.h"

@class General/AmpersandArtLayer;

@implementation General/AmpersandArt

// init:  creates a new art
- (id)init
{
	self = [super init];
	if (self) {
		layers = General/[[NSMutableArray alloc] init];
		[layers addObject:General/[[AmpersandArtLayer alloc] init]];
	}
	return self;
}

// layers:  gets the layers of the picture
- (General/NSMutableArray *)layers
{
	return layers;
}

@end


General/AmpersandArtLayer.h:
    
/*
----------------------------------
Saratoga v1.0
----------------------------------
AMPERSAND LABORATORIES
----------------------------------
Ampersand Art Layer Interface
----------------------------------
*/

#import  <Cocoa/Cocoa.h>

@class General/AmpersandArtObject;

@interface General/AmpersandArtLayer : General/NSObject {
	General/NSMutableArray *objects;
	BOOL visible;
}
- (int)addObject:(General/AmpersandArtObject *)object;
- (void)removeObjectAtIndex:(int)whatIndex;
- (General/NSMutableArray *)objects;
- (void)setVisible:(BOOL)isVisible;
- (BOOL)visibility;
@end


General/AmpersandArtLayer.m:
    
/*
----------------------------------
Saratoga v1.0
----------------------------------
AMPERSAND LABORATORIES
----------------------------------
Ampersand Art Layer Implementation
----------------------------------
*/

#import "General/AmpersandArtLayer.h"


@implementation General/AmpersandArtLayer

// init:  creates the layer
- (id)init
{
	self = [super init];
	if (self) {
		[self setVisible:YES];
		objects = General/[[NSMutableArray alloc] init];
		if (objects == nil)
			General/NSLog(@"objects==nil");
	}
	return self;
}

// dealloc:  destroys the layer
- (void)dealloc
{
	[objects release];
	[super dealloc];
}

// addObject:  adds an object and returns the index of the object in the object array
- (int)addObject:(General/AmpersandArtObject *)object
{
	[objects addObject:object];
	return [objects count] - 1;
}

// removeObjectAtIndex:  removes the object at a given index
- (void)removeObjectAtIndex:(int)whatIndex
{
	[objects removeObjectAtIndex:whatIndex];
}

// objects:  gets the objects array
- (General/NSMutableArray *)objects
{
	return objects;
}

// setVisible:  sets the visibility of the layer
- (void)setVisible:(BOOL)isVisible
{
	visible = isVisible;
}

// visibility:  gets the visibility of the layer
- (BOOL)visibility
{
	return visible;
}

@end


General/AmpersandArtObject.h:
    
/*
----------------------------------
Saratoga v1.0
----------------------------------
AMPERSAND LABORATORIES
----------------------------------
Ampersand Art Object Interface
----------------------------------
*/

#import <Cocoa/Cocoa.h>

typedef enum _Object_Type {
	POINT,
	BOX
} General/ObjectType;

const General/NSSize HAS_NO_SIZE = {0, 0};

@interface General/AmpersandArtObject : General/NSObject {
	General/ObjectType objectType;
	General/NSPoint origin;
	General/NSSize size;
	General/NSColor *fgColor, *bgColor;
	General/NSMutableArray *data;
}
- (General/AmpersandArtObject *)initObjectOfType:(General/ObjectType)object at:(General/NSPoint)p ofSize:(General/NSSize)s;
- (void)setType:(General/ObjectType)objtype;
- (General/ObjectType)type;
- (void)setOrigin:(General/NSPoint)anOrigin;
- (General/NSPoint)origin;
- (void)setSize:(General/NSSize)aSize;
- (General/NSSize)size;
- (void)setFgColor:(General/NSColor *)color;
- (General/NSColor *)fgColor;
- (void)setBgColor:(General/NSColor *)color;
- (General/NSColor *)bgColor;
@end


General/AmpersandArtObject.m:
    
/*
----------------------------------
Saratoga v1.0
----------------------------------
AMPERSAND LABORATORIES
----------------------------------
Ampersand Art Object Implementation
----------------------------------
*/

#import "General/AmpersandArtObject.h"


@implementation General/AmpersandArtObject

// init:  make a noew object
- (id)init
{
	self = [super init];
	if (self)
		return [self initObjectOfType:POINT at:General/NSMakePoint(0,0) ofSize:HAS_NO_SIZE];
	return nil;
}

// initObjectOfType at ofSize:  creates a new object with specified type
- (General/AmpersandArtObject *)initObjectOfType:(General/ObjectType)object at:(General/NSPoint)p ofSize:(General/NSSize)s
{
	if (self == nil)
		self = [self init];
	if (self == nil)
		return nil;
	[self setType:object];
	[self setOrigin:p];
	[self setSize:s];
	[self setFgColor:General/[NSColor blackColor]];
	[self setBgColor:General/[NSColor whiteColor]];
	return self;
}

// setType:  sets the object's type
- (void)setType:(General/ObjectType)objtype
{
	objectType = objtype;
}

// type:  gets the object's type
- (General/ObjectType)type
{
	return objectType;
}

// setOrigin:  sets the object's origin
- (void)setOrigin:(General/NSPoint)anOrigin
{
	origin = anOrigin;
}

// origin:  gets the object's origin
- (General/NSPoint)origin
{
	return origin;
}

// setSize:  sets the object's size
- (void)setSize:(General/NSSize)aSize
{
	size = aSize;
}

// size:  get the object's size
- (General/NSSize)size
{
	return size;
}

// setFgColor:  sets the object's foreground color
- (void)setFgColor:(General/NSColor *)color
{
	fgColor = color;
}

// fgColor:  gets the object's foreground color
- (General/NSColor *)fgColor
{
	return fgColor;
}

// setBgColor:  sets the object's background color
- (void)setBgColor:(General/NSColor *)color
{
	bgColor = color;
}

// bgColor:  gets the object's background color
- (General/NSColor *)bgColor
{
	return bgColor;
}

@end


General/ArtView.h:
    
/*
----------------------------------
Saratoga v1.0
----------------------------------
AMPERSAND LABORATORIES
----------------------------------
Art Editor Interface
----------------------------------
*/

#import <Cocoa/Cocoa.h>

@class General/AmpersandArt;
@class General/AmpersandArtLayer;
@class General/AmpersandArtObject;

@interface General/ArtEditor : General/NSView {
	General/AmpersandArt *art;
}
- (void)handleSetArt:(General/NSNotification *)note;
- (General/AmpersandArt *)art;
@end


General/ArtView.m:
    
/*
----------------------------------
Saratoga v1.0
----------------------------------
AMPERSAND LABORATORIES
----------------------------------
Art Editor Implementation
----------------------------------
*/

#import "General/ArtEditor.h"
#import "General/AmpersandArtObject.h"
#import "Notifications.h"

@class General/AmpersandArt;
@class General/AmpersandArtLayer;
@class General/AmpersandArtObject;

@implementation General/ArtEditor

/* initWithFrame:  creates a new General/ArtEditor with a preset frame */
- (id)initWithFrame:(General/NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setFrame:General/NSMakeRect(frame.origin.x,frame.origin.y,1000,1000)];
		General/[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSetArt:) name:SetPicture_ object:nil];
	}
    return self;
}

// dealloc:  destroys the object
- (void)dealloc
{
	General/[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

/* drawRect:  draws the frame */
- (void)drawRect:(General/NSRect)Rect
{
	General/NSEnumerator *enumerator, *lenumerator;
	General/AmpersandArtLayer *l;
	General/AmpersandArtObject *obj;
	
	if (art == nil) {
		General/NSLog(@"nil");
		return;
	}
	General/NSLog(@"starting redraw");
	General/[[NSColor whiteColor] setFill];
	General/NSRectFill([self frame]);
	enumerator = General/[self art] layers] objectEnumerator];
	while ((l = [enumerator nextObject]) != nil) {
		lenumerator = [[l objects] objectEnumerator];
		while ((obj = [lenumerator nextObject]) != nil)
			switch ([obj type]) {
			case POINT:
				[[NSLog(@"%@ is point", obj);
				General/obj fgColor] setFill];
				[[NSRectFill(General/NSMakeRect([obj origin].x, [obj origin].y, 1, 1));
				break;
			case BOX:
				General/NSLog(@"%@ is box", obj);
				General/obj fgColor] setFill];
				[[NSRectFill(General/NSMakeRect([obj origin].x, [obj origin].y, [obj size].width, [obj size].height));
				break;
			}
		[lenumerator release];
	}
	[enumerator release];
}

/* isFlipped:  will always return YES to say that (0,0) is top-left corner */
- (BOOL)isFlipped
{
	return YES;
}

// handleSetArt:  notification handler when art is set
- (void)handleSetArt:(General/NSNotification *)note
{
	General/NSLog(@"set art");
	art = General/[note object] art] retain];
}

// mouseDown:  when the mouse is down on the view, do this
- (void)mouseDown:([[NSEvent *)event
{
	General/NSMutableArray *arr;
	int i;
	General/AmpersandArtLayer *l;
	General/AmpersandArtObject *o;

	General/NSLog(@"we're here");
	General/NSLog(@"getting layer");
	arr = General/self art] layers];
	[[NSLog(@"%@", arr);
	i = [arr count] - 1;
	General/NSLog(@"%d", i);
	l = [arr objectAtIndex:i];
	General/NSLog(@"making object");
	o = General/[[AmpersandArtObject alloc] initObjectOfType:POINT at:[event locationInWindow] ofSize:HAS_NO_SIZE];
	General/NSLog(@"adding object");
	[l addObject:o];
	General/NSLog(@"cleaning up");
	[o release];
	General/NSLog(@"redrawing");
	[self setNeedsDisplay:TRUE];
}

// art:  get the art object
- (General/AmpersandArt *)art
{
	return art;
}

@end


General/MyDocument.h:
    
/*
----------------------------------
Saratoga v1.0
----------------------------------
AMPERSAND LABORATORIES
----------------------------------
Document Handler Interface
----------------------------------
*/


#import <Cocoa/Cocoa.h>

@class General/AmpersandArt;

@interface General/MyDocument : General/NSDocument {
	General/AmpersandArt *art;
}
- (General/AmpersandArt *)art;
@end


General/MyDocument.m:
    
/*
----------------------------------
Saratoga v1.0
----------------------------------
AMPERSAND LABORATORIES
----------------------------------
Document Handler Implementation
----------------------------------
*/

#import "General/MyDocument.h"
#import "Notifications.h"

@implementation General/MyDocument

// init:  creates a new document
- (id)init
{
    self = [super init];
    if (self)
        art = General/[[AmpersandArt alloc] init];
    return self;
}

// windowNibName:  returns the nib name
- (General/NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of General/NSWindowController or if your document supports multiple General/NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"General/MyDocument";
}

// windowControllerDidLoadNib:  performs an action when the document has loaded
- (void)windowControllerDidLoadNib:(General/NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
	General/[[NSNotificationCenter defaultCenter] postNotification:General/[NSNotification notificationWithName:SetPicture_ object:self]];
}

// dataRepresentationOfType:  saves the document
- (General/NSData *)dataRepresentationOfType:(General/NSString *)aType
{
    // Insert code here to write your document from the given data.  You can also choose to override -fileWrapperRepresentationOfType: or -writeToFile:ofType: instead.
    
    // For applications targeted for Tiger or later systems, you should use the new Tiger API -dataOfType:error:.  In this case you can also choose to override -writeToURL:ofType:error:, -fileWrapperOfType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.

    return nil;
}

// loadDataRepresentation:  opens the document
- (BOOL)loadDataRepresentation:(General/NSData *)data ofType:(General/NSString *)aType
{
    // Insert code here to read your document from the given data.  You can also choose to override -loadFileWrapperRepresentation:ofType: or -readFromFile:ofType: instead.
    
    // For applications targeted for Tiger or later systems, you should use the new Tiger API readFromData:ofType:error:.  In this case you can also choose to override -readFromURL:ofType:error: or -readFromFileWrapper:ofType:error: instead.
    
    return YES;
}

// art:  gets the art object
- (General/AmpersandArt *)art
{
	return art;
}

@end


Notifications.h:
    
/*
----------------------------------
Saratoga v1.0
----------------------------------
AMPERSAND LABORATORIES
----------------------------------
Notification Names
----------------------------------
*/

#import <Foundation/Foundation.h>

General/NSString *SetPicture_ = @"General/SaratogaNOTESetPicture";
General/NSString *GetPicture_ = @"General/SaratogaNOTEGetPicture";
General/NSString *SetTool_ = @"General/SaratogaNOTESetTool";
General/NSString *GetTool_ = @"General/SaratogaNOTEGetTool";


When I build a project containing the above 10 files, this is the Errors and Warnings list that I get:

    
General/ArtEditor.m:53: (Messages without a matching method signature will be assumed to return 'id' and accept '...' as arguments.)
General/ArtEditor.m:53: warning: no '-layers' method found
General/ArtEditor.m:55: warning: no '-objects' method found
General/ArtEditor.m:97: warning: no '-layers' method found


which causes Saratoga to crash and burn.

What I don't understand is that     layers and     objects are **clearly** defined in my code, and casting does **nothing** to solve the problem. What am I or what is gcc doing wrong? - General/PietroGagliardi

----

Did you #import the headers in which these methods are defined?

----
Thanks, but now I still have a crash.

General/ArtEdit.h:
    
/*
----------------------------------
Saratoga v1.0
----------------------------------
AMPERSAND LABORATORIES
----------------------------------
Art Editor Interface
----------------------------------
*/

#import <Cocoa/Cocoa.h>
#import "General/AmpersandArt.h"
#import "General/AmpersandArtLayer.h"
#import "General/AmpersandArtObject.h"

@class General/AmpersandArt;
@class General/AmpersandArtLayer;
@class General/AmpersandArtObject;

@interface General/ArtEditor : General/NSView {
	General/AmpersandArt *art;
}
- (void)handleSetArt:(General/NSNotification *)note;
- (General/AmpersandArt *)art;
@end


General/ArtEdit.m:
    
/*
----------------------------------
Saratoga v1.0
----------------------------------
AMPERSAND LABORATORIES
----------------------------------
Art Editor Implementation
----------------------------------
*/

#import "General/ArtEditor.h"
#import "General/AmpersandArtObject.h"
#import "Notifications.h"

@implementation General/ArtEditor

/* initWithFrame:  creates a new General/ArtEditor with a preset frame */
- (id)initWithFrame:(General/NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
		[self setFrame:General/NSMakeRect(frame.origin.x,frame.origin.y,1000,1000)];
		General/[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSetArt:) name:SetPicture_ object:nil];
	}
    return self;
}

// dealloc:  destroys the object
- (void)dealloc
{
	General/[[NSNotificationCenter defaultCenter] removeObserver:self];
	[super dealloc];
}

/* drawRect:  draws the frame */
- (void)drawRect:(General/NSRect)Rect
{
	General/NSEnumerator *enumerator, *lenumerator;
	General/AmpersandArtLayer *l;
	General/NSMutableArray *lay;
	General/AmpersandArtObject *obj;
	
	if (art == nil) {
		General/NSLog(@"nil");
		return;
	}
	General/NSLog(@"starting redraw");
	General/NSLog(@"setting white for bg");
	General/[[NSColor whiteColor] setFill];
	General/NSLog(@"filling rect");
	General/NSRectFill([self frame]);
	General/NSLog(@"testing");
	if ([self art] == nil) {
		General/NSLog(@"nil art");
		return;
	}
	if (General/self art] layers] == nil) {
		[[NSLog(@"nil layers");
		return;
	}
	General/NSLog(@"setting layers");
	lay = General/self art] layers];
	[[NSLog(@"setting enumerator");
// ------------------------------------------
// THE BUG IS HERE
// ERC_BAD_ADDRESS
	enumerator = [lay objectEnumerator];
// ------------------------------------------
	while ((l = [enumerator nextObject]) != nil) {
		if ([l visibility] == NO)
			continue;
		if (General/l objects] count] == 0)
			continue;
		lenumerator = [[l objects] objectEnumerator];
		if (lenumerator == nil) {
			[[NSLog(@"nil objects");
			return;
		}
		while ((obj = [lenumerator nextObject]) != nil)
			switch ([obj type]) {
			case POINT:
				General/NSLog(@"%@ is point", obj);
				General/obj fgColor] setFill];
				[[NSRectFill(General/NSMakeRect([obj origin].x, [obj origin].y, 1, 1));
				break;
			case BOX:
				General/NSLog(@"%@ is box", obj);
				General/obj fgColor] setFill];
				[[NSRectFill(General/NSMakeRect([obj origin].x, [obj origin].y, [obj size].width, [obj size].height));
				break;
			}
		[lenumerator release];
	}
	[enumerator release];
}

/* isFlipped:  will always return YES to say that (0,0) is top-left corner */
- (BOOL)isFlipped
{
	return YES;
}

// handleSetArt:  notification handler when art is set
- (void)handleSetArt:(General/NSNotification *)note
{
	General/NSLog(@"set art");
	art = General/[note object] art] retain];
}

// mouseDown:  when the mouse is down on the view, do this
- (void)mouseDown:([[NSEvent *)event
{
	General/NSMutableArray *arr;
	int i;
	General/AmpersandArtLayer *l;
	General/AmpersandArtObject *o;

	General/NSLog(@"we're here");
	General/NSLog(@"getting layer");
	arr = General/self art] layers];
	[[NSLog(@"%@", arr);
	i = [arr count] - 1;
	General/NSLog(@"%d", i);
	l = [arr objectAtIndex:i];
	General/NSLog(@"making object");
	o = General/[[AmpersandArtObject alloc] initObjectOfType:POINT at:[event locationInWindow] ofSize:HAS_NO_SIZE];
	General/NSLog(@"adding object");
	[l addObject:o];
	General/NSLog(@"cleaning up");
	[o release];
	General/NSLog(@"redrawing");
	[self setNeedsDisplay:TRUE];
}

// art:  get the art object
- (General/AmpersandArt *)art
{
	return art;
}

@end


How can an enumerator be at a bad address? - General/PietroGagliardi

----

A few tips here:


* Your General/MemoryManagement is broken in many ways. Read up on it and fix your code. This will probably stop the crash.
* Your page title is terrible. Think of another one. Alternatively, this is the sort of General/MailingListMode problem-solving which probably won't become a useful wiki page and as such may be more suitable to a venue such as the cocoa-dev mailing list.
* This page contains way too much code. Try to only post the code that's relevant to the problem. If you can't do that (and here you may not be able to), then post a .zip of your project instead of posting the full contents of a dozen different files.
* Clearly ask your question at the top of the page. For this page, post the exact errors you're getting, including the warnings and the crash. Indicate where the crash happens in your code if you know. After that, post code or a link to a .zip.
* Remember, the easier you make our job, the better help you'll get.


----
I'm in the process of replacing the above with a system based on a General/NSTableView and an General/NSArrayController, which I hope will be a lot cleaner and less crash-prone. I wanted to hold off on the interface design until the above was fully implemented, but now I realize it is a bad idea. - General/PietroGagliardi

----

Have a look at /Developer/Examples/General/AppKit/Sketch I think it's what your looking for (i.e a simple object oriented drawing application).