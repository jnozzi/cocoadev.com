

My task today was to learn the basics of General/NSToolbar and succeed in implementing a toolbar in the document window of a Document-based application. I studied a variety of sources including several open source applications. From that I came up with two different implementations. I am curious if one is/may be preferred and the reason(s) why. Please excuse the verbose details as I want to make sure that even the most inexperienced will be able to use these methods. All of my explanations use the PB and the IB as I haven't moved to General/XCode.

Granted these are useless toolbars....but they are toolbars nonetheless and more functionality can be added.

**Implementation within an General/NSDocument subclass**

1) Open the General/MyDocument.nib of a new Cocoa Document based application in the IB. Create a new outlet named "myWindow" and connect this outlet to the Window. Save and close.

2) Edit General/MyDocument.h to be:
    
#import <Cocoa/Cocoa.h>

@interface General/MyDocument : General/NSDocument
{
    General/IBOutlet id myWindow;
}

- (void)setupToolbar;
- (General/NSToolbarItem *)toolbar:(General/NSToolbar *)toolbar
     itemForItemIdentifier:(General/NSString *)itemIdentifier
 willBeInsertedIntoToolbar:(BOOL)flag;
- (General/NSArray *)toolbarAllowedItemIdentifiers:(General/NSToolbar *)toolbar;
- (General/NSArray *)toolbarDefaultItemIdentifiers:(General/NSToolbar *)toolbar;

@end


3) Edit General/MyDocument.m to be:
    
#import "General/MyDocument.h"

@implementation General/MyDocument

- (id)init
{
    self = [super init];
    if (self) {

    }
    return self;
}

- (General/NSString *)windowNibName
{
    return @"General/MyDocument";
}

- (void)windowControllerDidLoadNib:(General/NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
    [self setupToolbar];
}

- (General/NSData *)dataRepresentationOfType:(General/NSString *)aType
{
    return nil;
}

- (BOOL)loadDataRepresentation:(General/NSData *)data ofType:(General/NSString *)aType
{
    return YES;
}

- (void)setupToolbar
{
    General/NSToolbar *toolbar = General/[[NSToolbar alloc] initWithIdentifier:@"myToolbar"];
    [toolbar setAllowsUserCustomization: YES];
    [toolbar setAutosavesConfiguration: YES];
    [toolbar setDelegate: self];
    [myWindow setToolbar:[toolbar autorelease]];
}

- (General/NSToolbarItem *)toolbar:(General/NSToolbar *)toolbar itemForItemIdentifier:(General/NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    General/NSToolbarItem *item = General/[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    return [item autorelease];
}

- (General/NSArray *)toolbarAllowedItemIdentifiers:(General/NSToolbar *)toolbar
{
    return General/[NSArray arrayWithObjects:General/NSToolbarSeparatorItemIdentifier,
                                     General/NSToolbarSpaceItemIdentifier,
                                     General/NSToolbarFlexibleSpaceItemIdentifier,
                                     General/NSToolbarCustomizeToolbarItemIdentifier, nil];
}

- (General/NSArray *)toolbarDefaultItemIdentifiers:(General/NSToolbar *)toolbar
{
    return General/[NSArray arrayWithObjects:General/NSToolbarFlexibleSpaceItemIdentifier,
                                     General/NSToolbarCustomizeToolbarItemIdentifier, nil];
}

@end


4) Build and run.


**Implementation within an General/NSWindowController subclass**

1) In a different new project....

2) Create an General/NSWindowController subclass in the PB, including the header file, called General/MyWindowController.

3) Edit General/MyDocument.h to be:
    
#import <Cocoa/Cocoa.h>
@class General/MyWindowController;


@interface General/MyDocument : General/NSDocument
{
    General/MyWindowController			*windowController;
}

@end


4) Edit General/MyDocument.m to be:
    
#import "General/MyDocument.h"
#import "General/MyWindowController.h"


@implementation General/MyDocument

- (id)init
{
    self = [super init];
    if (self) {
    
    }
    return self;
}

- (void)makeWindowControllers
{
    windowController = General/[[MyWindowController alloc] initWithWindowNibName:@"General/MyDocument"];
    [self addWindowController:windowController];
}

- (void)windowControllerDidLoadNib:(General/NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];
}

- (General/NSData *)dataRepresentationOfType:(General/NSString *)aType
{
    return nil;
}

- (BOOL)loadDataRepresentation:(General/NSData *)data ofType:(General/NSString *)aType
{
    return YES;
}

@end


5) Edit General/MyWindowController.h to be:
    
#import <General/AppKit/General/AppKit.h>


@interface General/MyWindowController : General/NSWindowController
{
    General/NSToolbar                   *myToolbar;
}

- (General/NSToolbarItem *)toolbar:(General/NSToolbar *)toolbar
     itemForItemIdentifier:(General/NSString *)itemIdentifier
 willBeInsertedIntoToolbar:(BOOL)flag;
- (General/NSArray *)toolbarAllowedItemIdentifiers:(General/NSToolbar *)toolbar;
- (General/NSArray *)toolbarDefaultItemIdentifiers:(General/NSToolbar *)toolbar;

@end


6) Edit General/MyWindowController.m to be:
    
#import "General/MyWindowController.h"


@implementation General/MyWindowController

- (id) initWithWindowNibName:(General/NSString *) windowNibName
{
    self = [super initWithWindowNibName:windowNibName];
    myToolbar = General/[[NSToolbar alloc] initWithIdentifier:@"General/MyToolbar"];
    [myToolbar setAllowsUserCustomization:YES];
    [myToolbar setAutosavesConfiguration:YES];
    [myToolbar setDelegate:self];
    General/super window] setToolbar:myToolbar];
    return self;
}

- ([[NSToolbarItem *)toolbar:(General/NSToolbar *)toolbar
     itemForItemIdentifier:(General/NSString *)itemIdentifier
 willBeInsertedIntoToolbar:(BOOL)flag
{
    General/NSToolbarItem *item = General/[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
    return [item autorelease];
}

- (General/NSArray *)toolbarAllowedItemIdentifiers:(General/NSToolbar *)toolbar
{
    return General/[NSArray arrayWithObjects:General/NSToolbarSeparatorItemIdentifier,
                                     General/NSToolbarSpaceItemIdentifier,
                                     General/NSToolbarFlexibleSpaceItemIdentifier,
                                     General/NSToolbarCustomizeToolbarItemIdentifier, nil];
}

- (General/NSArray *)toolbarDefaultItemIdentifiers:(General/NSToolbar *)toolbar
{
    return General/[NSArray arrayWithObjects:General/NSToolbarFlexibleSpaceItemIdentifier,
                                     General/NSToolbarCustomizeToolbarItemIdentifier, nil];
}

- (void) dealloc
{
    [myToolbar release];
    General/self window] setDelegate:nil];
    [super dealloc];
}

@end


7) Build and run.

Any comments/suggestions/opinions?

-[[NedO

*Just wondering why you used the window controller as the toolbar delegate. This seems to violate the principle of giving each class a single purpose.*

I don't see why not. If the class's single purpose is "manage the window", then "manage the toolbar" would fall under that.

----

...or consider making it a category on the window controller...

*No, because then **all** windows would use the same toolbar...*

only windows which are controlled by a General/MyWindowController

*Oops, I thought you meant a category on General/NSWindowController. My bad.*