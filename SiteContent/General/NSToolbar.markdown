**Apple Toolbar Documentation**


* How Toolbars Work:  http://developer.apple.com/documentation/Cocoa/Conceptual/Toolbars/index.html 
* Toolbar Sample Code:  http://developer.apple.com/samplecode/General/ToolbarSample/index.html
* Toolbar API Documentation:  http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Classes/NSToolbar_Class/index.html
* How to add a toolbar in IB in 10.5 http://developer.apple.com/documentation/General/DeveloperTools/Conceptual/IB_UserGuide/General/BuildingaNibFile/chapter_4_section_4.html#//apple_ref/doc/uid/TP40005344-CH11-DontLinkElementID_29



**Toolbar Tutorials**


* Implemented with a Category and demonstrates adding a Custom View: http://www.macdevcenter.com/pub/a/mac/2002/03/15/cocoa.html (WARNING: the example will crash because setupToolbar uses autorelease twice)
* A shorter tutorial using a non-standard implementation: http://www.cocoadevcentral.com/articles/000037.php
* Adding a toolbar to your Preferences window: http://www.mere-mortal-software.com/blog/details.php?d=%202007-03-14
* and locally: General/NSToolbarTutorial



**Toolbar Sample Code**

* [http://www.tokobungasabana.com Toko Bunga Online]
* [http://www.optimaweb.co.id Online Marketing Indonesia]
* [http://www.optimaweb.co.id/seo-company SEO Company]
* [http://littletods.com/en/content/4-perlengkapan-bayi Perlengkapan Bayi]
* General/NSToolbarItemSampleCode 
* General/NSToolbarSampleCode



**Toolbar How Tos**


* General/ProperWayToUseNSToolbarInDocumentApps
* General/UsingToolbarInASheet
* General/SetToolbarShrinksWindow for window sizing issues associated with adding a toolbar to a window frame with data restored from a file.
* General/ToolbarAndArrayControllerBindings for targeting your toolbar item's action with General/CocoaBindings
* General/ProgressIndicatorInToolbar
* General/AlteringTheAppearanceOfNSToolbar



**Additional Toolbar Resources**


* General/JediKnil's General/GenericToolbar
* General/SimpleToolbar
* Ask for help with your source code at General/NSToolBarHelp.
* A Preferences window toolbar class: http://www.mere-mortal-software.com/blog/details.php?d=%202007-03-11



----
----

    - (id)initWithIdentifier:(General/NSString *)identifier;
The identifier is used to form the toolbar's autosave name.  Also, toolbars with the same identifier are implicitly synchronized so that they maintain the same state
----   
    - (void)insertItemWithItemIdentifier:(General/NSString *)itemIdentifier atIndex:(int)index;
    - (void)removeItemAtIndex:(int)index;
Primitives for explicitly adding and removing items.  Any change made will be propogated immediately to all other toolbars with the same identifier.
----
    - (void)setDelegate:(id)delegate;
    - (id)delegate;
Customizable toolbars must have a delegate, and must implement the required General/NSToolbar delegate methods.
----
    - (void)setVisible:(BOOL)shown;
    - (BOOL)isVisible;
toggles the visibliity of the toolbar.
----
    - (void)runCustomizationPalette:(id)sender;
    - (BOOL)customizationPaletteIsRunning;
Customizable toolbars (those with delegates) can show a palette which allows users to populate the toolbar with individual items or to reset the toolbar to some default set of items.  The items and item sets in the palette are specified by the delegate (-toolbarAllowedItemIdentifiers: and -toolbarDefaultItemIdenfiers:).  When the user is done configuring, they will dismiss the palette.
----
----
**Toolbar Attributes**

    - (void)setDisplayMode:(General/NSToolbarDisplayMode)displayMode;
- (General/NSToolbarDisplayMode)displayMode;
----
    - (void)setAllowsUserCustomization:(BOOL)allowCustomization;
- (BOOL)allowsUserCustomization;
This flag controls whether or not users can configure the toolbar by dragging items around, and whether or not the customization palette can be used.  The default value is NO, but can be changed at any time.  For instance, a developer may not want users to be able to edit the toolbar while some event is being processed.
----
----      
**Accessing toolbar info**

    - (General/NSString *)identifier;
All toolbars with the same name will share the same display attributes, and item order.  Also, if a toolbar autosaves its configuration, the item identifier will be used as the autosave name.
----
    - (General/NSArray *)items;
Allows you to access all current items in the toolbar.
----
    - (General/NSArray *)visibleItems;
Allows you to access the current visible items (non clipped).
----
----
**Autosaving The Configuration**

    - (void)setAutosavesConfiguration:(BOOL)flag;
- (BOOL)autosavesConfiguration;
If autosavesConfiguration is YES, the toolbar will automatically write changes the user makes to user defaults.  Customizable toolbars will want to set this flag to YES.  Setting this to NO means changes in configuration are not written automatically, however you can use the configurationDictionary method to do it yourself.  Default is NO. (IMHO, as of 10.1.4, the default is YES.  General/AndreasMayer)
----
    - (void)setConfigurationFromDictionary:(General/NSDictionary *)configDict;
- (General/NSDictionary *)configurationDictionary;
Set and get the current toolbar configuration using a dictionary representation.
----
----
**Validation of the items**

    - (void)validateVisibleItems;
Typically you should not invoke this method.  This method is called on window updates with the purpose of validating
each of the visible items.  The toolbar will iterate through the list of visible items, sending each a -validate message.
----
----
**Methods implemented by the delegate**

    - (General/NSToolbarItem *)toolbar: (General/NSToolbar *)toolbar itemForItemIdentifier:(General/NSString *)
         itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag;
Required method.  Given an item identifier, this method returns an item.  Note that, it is expected that each toolbar receives its own distinct copies.   If the item has a custom view, that view should be in place when the item is returned.  Finally, do not assume the returned item is going to be added as an active item in the toolbar.  In fact, the toolbar may ask for items here in order to construct the customization palette (it makes copies of the returned items).  if willBeInsertedIntoToolbar is YES, the returned item will be inserted, and you can expect toolbarWillAddItem: is about to be posted.
----   
    - (General/NSArray *)toolbarDefaultItemIdentifiers:(General/NSToolbar*)toolbar;
Required method.  Returns the ordered list of items to be shown in the toolbar by default.   If during initialization, no overriding values are found in the user defaults, or if the user chooses to revert to the default items this set will be used.
----
    - (General/NSArray *)toolbarAllowedItemIdentifiers:(General/NSToolbar*)toolbar;
Required method.  Returns the list of all allowed items by identifier.  By default, the toolbar does not assume any items are allowed, even the separator.  So, every allowed item must be explicitly listed.  The set of allowed items is used to construct the customization palette.  The order of items does not necessarily guarantee the order of appearance in the palette.  At minimum, you should return the default item list.
----
----
**Interface for Notifications**

    - (void)toolbarWillAddItem: (General/NSNotification *)notification;
Before an new item is added to the toolbar, this notification is posted.  This is the best place to notice a new item is going into the toolbar.  For instance, if you need to cache a reference to the toolbar item or need to set up some initial state, this is the best place to do it.   The notification object is the toolbar to which the item is being added.  The item being added is found by referencing the @"item" key in the userInfo.
----
    - (void)toolbarDidRemoveItem: (General/NSNotification *)notification;
After an item is removed from a toolbar the notification is sent.  This allows the chance to tear down information related to the item that may have been cached.  The notification object is the toolbar to which the item is being added.  The item being added is found by referencing the @"item" key in the userInfo.
----
----
**Notifications**
    General/NSToolbarWillAddItemNotification;
General/NSToolbarDidRemoveItemNotification;

----
----

See also: General/NSToolbarSampleCode

----
How do you set an action to a General/NSToolbarItem? --General/JoshaChapmanDodson

* [toolbarItem setAction:@selector(myAction:)]*
----
----

* [toolbarItem setAction:@selector(myAction:)]*
    
Controller.h
- (General/IBAction)myAction:(id)sender;

Controller.m
- (General/IBAction)myAction:(id)sender
{
	// Just Example Action wich load an image to an imageview
        General/NSImage *tempImg;
	
	tempImg = General/[[NSImage alloc] initWithContentsOfFile: General/[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"1.jpg"]];
        [puzzleView setImage: tempImg];
	[tempImg release];
}
 - General/MACnus

*General/[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"1.jpg"]];*

It's probably better to use     General/[[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"] here. Or just     General/[NSImage imageNamed:@"1"]
----
How do you get a menu into a General/NSToolbarItem? --General/JoshaChapmanDodson

*make the item a General/NSView and set the menu for that.*
----
I mean a sub menu of a General/NSToolbarItem.

"as above again"
----
I mean like the build toolbar item in xcode.

*I would create General/NSView toolbar item that includes an General/NSImageView subclass. This subclass could listen to the mouse-down events and perform an action for a single click, and bring up a context menu if the mouse is held down. -- General/RyanBates*
----
How do you have an action that selects a General/NSToolbarItem, like in a preference window.
----
See the 10.3 documentation for General/NSToolbar:

- (General/NSString *)selectedItemIdentifier

- (void)setSelectedItemIdentifier:(General/NSString *)itemIdentifier

and the delegate method

- (General/NSArray *)toolbarSelectableItemIdentifiers:(General/NSToolbar *)toolbar

-- General/AndreasMayer
----
I know how to do that! I was just wondering how I did that, for example "I have a General/NSToolbar, with to items, say @"Item1", and @"Item2" in the main General/NSWindow, I want to have a menu item that I want to switch the Shaded area from @"Item1" to @"Item2".

--General/JoshaChapmanDodson

----

See above. And learn what a homonym is.

----

Just a note: You don't *have* to make your toolbar configurable. I've seen plenty of toolbars with 2 or 3 items, all of which are essential to functionality of the application (or the toolbar, at least). So why allow the user to remove them? 

----

Tiger changes some stuff with toolbars. General/NSToolbarItem<nowiki/>s will now send a General/NilTargetedAction to the General/FirstResponder in their own window instead of the key window (which may be a different window). Also, General/NSWindow now has methods to show or hide the show or hide toolbar button, namely     - (void)setShowsToolbarButton:(BOOL)show and     - (BOOL)showsToolbarButton

----

If you're in need of knowing when a toolbar's items have been changed or rearranged, you can subclass General/NSToolbar and override this method:
    
- (General/NSDictionary *)configurationDictionary
{
	General/NSDictionary *configDict = [super configurationDictionary];
	SEL sel = @selector(toolbar:configurationDidChange:);
	if (General/self delegate] respondsToSelector:sel])
		[[self delegate] performSelector:sel withObject:self withObject:configDict];
	
	return configDict;
}

--[[KevinWojniak

----
Um, should that be overriding     setConfigurationDictionary: instead? Or does any change in the toolbar actually call this method? After all, you could just call it from your own code, perhaps even from the delegate.
----

How would one implement an General/NSToolbarFlexibleSpaceItemIdentifier that is linked to an General/NSSplitView?  Sort of like the one implemented in Apple's Mail.app notice that the delete button starts immediately after the edge of the mailboxes list and automatically adjusts itself when the split view is resized.

----
I would suspect that it is a custom view and placed into the toolbar using setView. All the custom view would have to do is occupy a rect whose width is dependent on the General/NSSplitView.

----
Okay ... I added my custom view and set it up to the intial size of the left General/NSSplitView pane.  Now, I have a method that gets called during the resizing of the General/NSSplitView and the goal is to tell this custom view to resize in the toolbar to match the size of the left pane.  However, it is not working.  Is there a setNeedsDisplay similar function for toolbars that I am missing?  I don't get any errors ... the toolbar item just simply refuses to resize.  Here is my code as it is being called in my subclassed General/NSSplitView:

    
- (void)mouseDragged:(General/NSEvent *)theEvent 
{
	[...]
	General/[[[self window] toolbar] toolbar:[[self window] toolbar] itemForItemIdentifier:@"[[CustomStretcher" willBeInsertedIntoToolbar:NO] view] setFrame: General/NSMakeRect(0, 0, newFrame.size.width, 32)];
	General/[[self window] toolbar] toolbar:[[self window] toolbar] itemForItemIdentifier:@"[[CustomStretcher" willBeInsertedIntoToolbar:NO] setMinSize:General/NSMakeSize(newFrame.size.width, 32)];
	General/[[self window] toolbar] toolbar:[[self window] toolbar] itemForItemIdentifier:@"[[CustomStretcher" willBeInsertedIntoToolbar:NO] setMaxSize:General/NSMakeSize(newFrame.size.width, 32)];
	[...]
}


----
I am using a General/GenericToolbar. It is not supposed to be customizable, as it only has one item (a view that has multiple controls in it; similar to the the way the first two items in Xcode's default toolbar config is: a General/NSPopupButton in an General/NSToolbarItem). However, that darn show/hide toolbar button on the titlebar still allows customization by switching the Icon Only, Text Only, and Icon/Text by holding down Command and double-clicking the little icon. I don't like this (it frustrates me) because the item has no text value. How do I disable (or better yet, hide) this little button for all uses except to hide the toolbar (or to hide itself)? - General/PietroGagliardi

----
The General/GenericToolbar's inspector allows you to disable customization in IB. Also, because General/GenericToolbar is third-party, questions about it should probably go on the General/GenericToolbar page (if anywhere; other people might not like me using General/CocoaDev for answering questions). --General/JediKnil (the developer)

----
Thanks, but this is an issue with the fact that there is a toolbar hide/show button on General/NSWindow's titlebar. How do I get rid of it, like in Safari?

...

Never mind. I found what I was looking for.

----
I had problems with General/GenericToolbar and had to switch to the native General/NSToolbar. Everything works fine for now, except that the button won't show!

CODE:
    
#import <Cocoa/Cocoa.h>
#import <General/QuartzCore/General/QuartzCore.h>
#import <General/QuickTime/General/QuickTime.h>
#import <General/QTKit/General/QTKit.h>
#import "General/MovieEditView.h"

@interface General/MyMovie : General/NSDocument {
	General/NSToolbar *toolbar;
	General/IBOutlet General/NSView *btnView;
	General/IBOutlet General/NSPanel *previewPanel;
	General/IBOutlet General/MovieEditView *qtview;
	General/QTMovie *movie;
}
- (General/NSString *)baseFileName;
- (char *)strWithChar:(char)c;
- (General/NSArray *)toolbarAllowedItemIdentifiers:(General/NSToolbar *)aToolbar;
- (General/NSArray *)toolbarDefaultItemIdentifiers:(General/NSToolbar *)aToolbar;
- (General/NSToolbarItem *) toolbar:(General/NSToolbar *)aToolbar itemForItemIdentifier:(General/NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag;
@end

@implementation General/MyMovie

- (id)init
{
	self = [super init];
	if (self)
		toolbar = General/[[NSToolbar alloc] initWithIdentifier:@"General/MovieToolbar"];
	return self;
}

- (void)awakeFromNib
{
	[qtview setUpDisplayLink];
}

- (General/NSString *)windowNibName
{
	return @"General/MyMovie";
}

- (void)windowControllerDidLoadNib:(General/NSWindowController *)aController
{
	General/NSMutableString *str;

	[super windowControllerDidLoadNib:aController];
	if (movie != nil) {
		str = General/[NSMutableString stringWithString:@"Preview of "];
		[qtview setMovie:movie];
		[previewPanel setTitle:[str stringByAppendingString:[self baseFileName]]];
	}
	[toolbar setAllowsUserCustomization:NO];
	[toolbar setSizeMode:General/NSToolbarSizeModeRegular];
	[toolbar setDisplayMode:General/NSToolbarDisplayModeIconOnly];
	[toolbar setVisible:YES];
	[toolbar setDelegate:self];
	[toolbar insertItemWithItemIdentifier:@"General/SelectArea" atIndex:0];
	General/qtview toolbarWindow] setToolbar:toolbar];
	[[qtview toolbarWindow] setShowsToolbarButton:NO];
}

- ([[NSData *)dataRepresentationOfType:(General/NSString *)type
{
	return [movie movieFormatRepresentation];
}

- (BOOL)loadDataRepresentation:(General/NSData *)data ofType:(General/NSString *)type
{
	General/NSError **err;

	movie = General/[QTMovie movieWithData:data error:err];
	return movie != nil;
}

- (General/NSArray *)toolbarAllowedItemIdentifiers:(General/NSToolbar *)aToolbar
{
	return General/[NSArray arrayWithObject:@"General/SelectArea"];
}

- (General/NSArray *)toolbarDefaultItemIdentifiers:(General/NSToolbar *)aToolbar
{
	return General/[NSArray arrayWithObject:@"General/SelectArea"];
}

- (General/NSToolbarItem *)toolbar:(General/NSToolbar *)aToolbar itemForItemIdentifier:(General/NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
	General/NSToolbarItem *itm;

	itm = General/[[[NSToolbarItem alloc] initWithItemIdentifier:@"General/SelectArea"] autorelease];
	[itm setView:btnView];
	[itm setLabel:@""];
	return itm;
}

- (General/NSString *)baseFileName
{
	// unrelated
}

- (char *)strWithChar:(char)c
{
	// unrelated
}

@end


OTHER DETAILS:

*The     [qtview toolbarWindow] variable refers to the window that contains the toolbar.
*    [qtview setUpDisplayLink]: message that refers to a Core Video routine I wrote based on tutorial code, unrelated


What am I doing wrong? - General/PietroGagliardi

----
    General/qtview toolbarWindow] setShowsToolbarButton:NO];?

----
That takes off that little grey button that hides and shows the toolbar from the titlebar when you add a toolbar to it - that's not the problem.

----
Mm...this is one of the annoying facts about [[NSToolbarItem that is buried in the documentation, and I wouldn't blame you for not seeing it. Anyway, all view toolbar items must have their min size and max size set, usually to the size of the view. (I've never tried *not* the size of the view). Sorry to hear that General/GenericToolbar didn't work for you. --General/JediKnil

----
It's fine. I hope to find General/GenericToolbar useful in the future.

Anyways, I modified the min and max size code and it works now. Thanks! - General/PietroGagliardi

PS - When I get enough done, I'll post a shot of how I'm using the toolbar.

----

Just sharing a little tidbit I gleaned from using a toolbar: General/NSToolbar does not add a view to the window's contentView. Instead, it adds another private view directly in the window and moves the contentView down out of the way. This is good - it means your window layout and view structure don't need to know about the toolbar being there at all.However, it does bring with it a few kinks, which in hindsight are obvious but may catch out the unwary. First, if you are making any assumptions about the size relationships between your window frame and the contentView frame, chances are a toolbar will bite you. This can happen if you are doing any sort of weird sizing on the window, like implementing a drawer as part of the window itself. In that sort of case, you can ignore the toolbar providing you work off the contentView frame. Also, for window sizing limits, you need to use setContentMaxSize, setContentMinSize, etc instead of the window's setMaxSize, setMinSize. --General/GrahamCox

----

So I guess the basic lesson is "Don't Assume The Size Of The Titlebar Is Constant, Because Someday You Might Just Want A Toolbar."  :)

----

In a nutshell. ;-) -GC

----

I inserted an General/NSSearchField in my toolbar in IB.

One item of its searchMenuTemplate was bound to the Shared User Defaults Controller and was supposed to reflect the state of a preference.

As the item seemed to have no effect, I searched and discovered that the search field�s searchMenuTemplate is copied. 

As a result, any binding set in IB for an item gets lost.

Should this be considered  a bug??

Anyway, I wrote this General/NSMenuItem subclass to workaround this problem.  --Flofl.

    
@interface General/CopyBindingMenuItem : General/NSMenuItem {}
@end

@implementation General/CopyBindingMenuItem

-(id)copyWithZone:(General/NSZone *)zone {
    
    General/CopyBindingMenuItem * result = [super copyWithZone:zone];
    
    if (result) {

	General/NSDictionary * bindingInfo = [self infoForBinding:@"value"];
	
	[result bind:@"value"
	    toObject:[bindingInfo valueForKey:General/NSObservedObjectKey]
	 withKeyPath:[bindingInfo valueForKey:General/NSObservedKeyPathKey] 
	     options:[bindingInfo valueForKey:General/NSOptionsKey]];
    }
    
    return result;
}

@end
