

This is a set of source code that concentrates on General/NSToolbar, and General/NSToolbarItem

As people have been requesting it, here is some stripped source of a complete General/NSToolbar implementation from one of my apps. It works, it just may not be the best method to do it. It's my interpretation of the documentation basically, and yes, I use awakeFromNib usually (although I would recommend creating the toolbar when the window has finished loading). -- General/MatPeterson
    

@interface General/ToolbarClass : General/NSObject
{
    General/IBOutlet id window; // Window to link toolbar to
    General/NSToolbarItem *import; // Item that we are adding
}
- (void)setupToolbar;
@end

@implementation General/ToolbarClass

- (void)awakeFromNib
{
    // Item created
    import = General/[[NSToolbarItem alloc] initWithItemIdentifier:@"Import"];
    [import setLabel:General/NSLocalizedString(@"Import", nil)];
    [import setToolTip:@"Import just the selected songs based on the preferences that you have set"];
    [import setPaletteLabel:[import label]];
    [import setImage:General/[NSImage imageNamed:@"import"]];
    [import setTarget:self];
    [import setAction:@selector(import:)];

    [self setupToolbar];
}

- (General/NSToolbarItem *)toolbar:(General/NSToolbar *)toolbar
itemForItemIdentifier:(General/NSString *)itemIdentifier
willBeInsertedIntoToolbar:(BOOL)flag
{
    General/NSToolbarItem *item = General/[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];

    if ([itemIdentifier isEqualToString:@"Import"])
    {
        return import;
    }
    return [item autorelease];
}

- (General/NSArray *)toolbarAllowedItemIdentifiers:(General/NSToolbar*)toolbar
{
    return General/[NSArray arrayWithObjects:General/NSToolbarSeparatorItemIdentifier,
        General/NSToolbarSpaceItemIdentifier,
        General/NSToolbarFlexibleSpaceItemIdentifier,
        General/NSToolbarCustomizeToolbarItemIdentifier, @"Import", nil];
}

- (General/NSArray *)toolbarDefaultItemIdentifiers:(General/NSToolbar*)toolbar
{
    return General/[NSArray arrayWithObjects:General/NSToolbarSeparatorItemIdentifier, @"Import", nil];
}

- (void)setupToolbar
{
    toolbar = General/[[NSToolbar alloc] initWithIdentifier:@"mainToolbar"];
    [toolbar autorelease];
    [toolbar setDelegate:self];
    [toolbar setAllowsUserCustomization:YES];
    [toolbar setAutosavesConfiguration:YES];
    [window setToolbar:toolbar];
}

- (General/IBAction)import:(id)sender
{
// Do something here that needs to be done when the toolbaritem is clicked.
}

@end



Or you could try the more traditional delegate category on your window controller, and implement the setupToolbar method in the latter.

    
#import "General/MyToolbarDelegateCategory.h"

@implementation General/MyWindowController ( General/MyToolbarDelegateCategory )

- ( General/NSArray * ) toolbarAllowedItemIdentifiers: ( General/NSToolbar * ) toolbar
{
	return [ General/NSArray arrayWithObjects:  General/NSToolbarSeparatorItemIdentifier,
			General/NSToolbarSpaceItemIdentifier,
			General/NSToolbarFlexibleSpaceItemIdentifier,
			General/NSToolbarCustomizeToolbarItemIdentifier, 
			@"General/FooItem", @"General/BarItem" @"General/BazItem", nil ];
}

- ( General/NSArray * ) toolbarDefaultItemIdentifiers: ( General/NSToolbar * ) toolbar
{
	return [ General/NSArray arrayWithObjects:  @"General/FooItem",@"General/BarItem", @"General/BazItem",
			General/NSToolbarFlexibleSpaceItemIdentifier,
			General/NSToolbarCustomizeToolbarItemIdentifier, nil ];
}

- ( General/NSToolbarItem * ) toolbar: ( General/NSToolbar * ) toolbar
	itemForItemIdentifier: ( General/NSString * ) itemIdentifier
       willBeInsertedIntoToolbar: ( BOOL ) flag
{
	General/NSToolbarItem *item = [ [ General/NSToolbarItem alloc ] initWithItemIdentifier: itemIdentifier ];
	
	if ( [ itemIdentifier isEqualToString: @"General/FooItem" ] )
	{
		[ item setLabel: General/NSLocalizedString( @"Foo", nil ) ];        // Easy to localize!
		[ item setPaletteLabel: [ item label ] ];
		[ item setImage: [ General/NSImage imageNamed: @"foo.png" ] ];
		[ item setTarget: myArrayController ];              // or setTarget: self
		[ item setAction: @selector( fooAction: ) ];
    }
	else if ( [ itemIdentifier isEqualToString: @"General/BarItem" ] )
	{
		[ item setLabel: General/NSLocalizedString( @"Bar", nil ) ];
		[ item setPaletteLabel: [ item label ] ];
		[ item setImage: [ General/NSImage imageNamed: @"bar.png" ] ];
		[ item setTarget: myArrayController ];
		[ item setAction: @selector( barAction: ) ];
    }
	else if ( [ itemIdentifier isEqualToString: @"General/BazItem" ] )
	{
		[ item setLabel: General/NSLocalizedString( @"Baz", nil ) ];
		[ item setPaletteLabel: [ item label ] ];
		[ item setImage: [ General/NSImage imageNamed: @"baz.png" ] ];
		[ item setTarget: self ];
		[ item setAction: @selector( bazAction: ) ];
    }
	
    return [ item autorelease ];
}

@end



see also General/GenericToolbar