This is the depository for three classes which together form the base code for my implementation of the search filter bar seen in itunes, safari, finder, and mail.

The hope is that if you want to do it your own way, here's all the code.  But I plan on creating an IB palette for the whole project once it's polished off.  So just check back in.

Note that the code references 17 outside images, 15 of which can be found in Mail.app's bundle and are the basis for the button background in that style.  The other two are tiling strips for the two background styles (itunes and mail styles), and I guess if you want them you should post here telling me where I can drop them online and have them accessible.  No way I'm putting them in my .mac account.

Current status:
correct display of all 3 styles with corresponding buttons;
does NOT connect to a delegate, therefore there is only one button in the bar (but it's a purdy button!)

Heads up:
the three classes are:
General/FilterBar
General/SDFilterBarButton
General/SDFilterBarButtonCell

----

    
/* General/FilterBar */

#import <Cocoa/Cocoa.h>
#import "General/SDFilterBarButton.h"
#import "General/SDFilterBarButtonCell.h"


@interface General/FilterBar : General/NSView
{
	General/NSImage *backgroundImage;
	General/NSMutableArray *buttons;
}

- (General/NSButton *)newButton;
- (BOOL)addButtonWithTitle:(General/NSString *) representedObject:(id)repObject toFamily:(General/NSString *)family;

- (id)delegate;
- (void)setDelegate:(id)delegate;

@end


#import "General/FilterBar.h"

@implementation General/FilterBar

#pragma mark -
#pragma mark Setup

- (id)initWithFrame:(General/NSRect)frameRect
{
	if ( (self = [super initWithFrame:frameRect]) == nil )
		return nil;
	
	backgroundImage = General/[[NSImage imageNamed:@"General/FilterBarBackground"] retain];
	buttons = General/[[NSMutableArray alloc] init];
	
	General/[SDFilterBarButton setCellClass:General/[SDFilterBarButtonCell class]];
	
	return self;
}

- (void)awakeFromNib
{
	//General/self window] setAcceptsMouseMovedEvents:YES];
	
	[[SDFilterBarButton *newButton;
	newButton = [self newButton];

	General/NSRect frame = [newButton frame];
	frame.origin.x = 4;
	frame.origin.y = 2;
	[newButton setFrame:frame];
	
	General/newButton cell] setBezeled:NO];
	
	[buttons addObject:newButton];
	
	[self addSubview:newButton];
}

#pragma mark -
#pragma mark Display

- (void)drawRect:([[NSRect)rect
{
	General/NSLog(@"Displaying");
	[super drawRect:rect];
	[backgroundImage compositeToPoint:General/NSMakePoint(0,0) operation:General/NSCompositeCopy]; //General/NSCompositeSourceOver
}

#pragma mark -
#pragma mark Cell creation

- (General/NSButton *)newButton
{
	General/SDFilterBarButton *newButton = General/[[SDFilterBarButton alloc] init];
	[newButton setTitle:@"button title"];
	[newButton setButtonType:General/NSPushOnPushOffButton];
	[newButton setBezelStyle:General/NSRecessedBezelStyle];
	[newButton sizeToFit];
	//General/newButton cell] setBackgroundColor:nil];
	
	[[newButton cell] setHighlighted:NO];
	[[newButton cell] setShowsBorderOnlyWhileMouseInside:NO]; //NO
	return newButton;
}

- (BOOL)addButtonWithTitle:([[NSString *) representedObject:(id)repObject
{
	
}

#pragma mark -
#pragma mark Expiremental

- (void)mouseMoved:(General/NSEvent *)theEvent
{
	General/NSLog(@"YAY!");
}

- (void)mouseEntered:(General/NSEvent *)theEvent
{
	General/NSLog(@"mouse in filterBar");
}

#pragma mark -
#pragma mark Tracking rects

- (void)addSubview:(General/NSView *)aView
{
	General/NSLog(@"addSubview");
	[self setValue:[self addTrackingRect:[aView frame] 
								   owner:aView 
								userData:nil 
							assumeInside:NO] 
		forKeyPath:General/[NSString stringWithFormat:@"subviews.%@.tag", [aView title]]];
	
	[super addSubview:aView];
}

- (void)willRemoveSubview:(General/NSView *)subview
{
	General/NSLog(@"willRemoveSubview");
	[self removeTrackingRect:General/self valueForKeyPath:[[[NSString stringWithFormat:@"subviews.%@.tag", [subview title]]] intValue]];
	
	[super willRemoveSubview:subview];
}


@end



    

#import <Cocoa/Cocoa.h>
#import "General/SDFilterBarButtonCell.h"


@interface General/SDFilterBarButton : General/NSButton 
{

}

@end




#import "General/SDFilterBarButton.h"


@implementation General/SDFilterBarButton

#pragma mark -
#pragma mark Setup

- (id)init
{
	if ( ![super init] )
		return nil;
	
	[self setTarget:self];
	[self setAction:@selector(buttonDown:)];	
	
	return self;
}

#pragma mark -
#pragma mark Mouse tracking

- (void)mouseEntered:(General/NSEvent *)event
{
	General/self cell] setValue:[[[NSNumber numberWithBool:YES] forKey:@"mouseInView"];
	[self setNeedsDisplay:YES];
}

- (void)mouseExited:(General/NSEvent *)event
{
	General/self cell] setValue:[[[NSNumber numberWithBool:NO] forKey:@"mouseInView"];
	[self setNeedsDisplay:YES];
}

#pragma mark -
#pragma mark Action

- (General/IBAction)buttonDown:(id)sender
{
	General/self cell] toggleSelected];
}

@end



    


#import <Cocoa/Cocoa.h>


@interface [[SDFilterBarButtonCell : General/NSButtonCell
{
	BOOL selected;
	BOOL mouseInView;
}

- (void)toggleSelected;

@end


#import "General/SDFilterBarButtonCell.h"


@implementation General/SDFilterBarButtonCell

#pragma mark -
#pragma mark Setup

- (id)init
{
	if ( ![super init] )
		return nil;
		
	selected = NO;
	mouseInView = NO;
	
	return self;
}

#pragma mark -
#pragma mark Selection logic

- (void)toggleSelected
{
	if ( selected == YES ) {
		selected = NO;	
	} else {
		selected = YES;	
	}
}

#pragma mark -
#pragma mark Drawing

- (void)drawBezelWithFrame:(General/NSRect)frame inView:(General/NSView*)controlView
{
	if ( !mouseInView && !selected )
		return;	
		
	[super drawBezelWithFrame:frame inView:controlView];
}

- (General/NSRect)drawTitle:(General/NSAttributedString*)title withFrame:(General/NSRect)frame inView:(General/NSView*)controlView
{
	if ( mouseInView || selected )
		return [super drawTitle:title withFrame:frame inView:controlView];
		
	General/NSMutableAttributedString *prettyTitle = General/[[NSMutableAttributedString alloc] initWithAttributedString:title];
	[prettyTitle addAttribute:General/NSForegroundColorAttributeName value:General/[NSColor blackColor] range:General/NSMakeRange(0, [title length])]; //darkGrayColor
	
	General/NSShadow *shadow = General/[[NSShadow alloc] init];
		[shadow setShadowColor:General/[NSColor whiteColor]];
		[shadow setShadowBlurRadius:2];
		[shadow setShadowOffset:General/NSMakeSize(1, -1)];
	[prettyTitle addAttribute:General/NSShadowAttributeName value:shadow range:General/NSMakeRange(0, [title length])];
	
	return [super drawTitle:prettyTitle withFrame:frame inView:controlView];
}

@end

