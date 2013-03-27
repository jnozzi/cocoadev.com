Looking for some help on how to do some tricks in the General/NSTableViews. I want to be able to set out my General/TableView exactly the way it is done in the Accounts Preference Pane in System Preferences. The grayed out title and a few rows, and then another grayed out title and a few more rows, and lastly a divider line to separate a special row. And if possible the gradient that shows on selected rows.

Check out this pic for a diagram sort of thing.
http://i.domaindlx.com/virux/syspref.jpg

It'd be great if this could be done in Applescript Studio, but very willing to do in Cocoa.

----

a General/ClassDump of /System/Library/General/PreferencePanes/Accounts.prefPane/Contents/General/MacOS/Accounts looks very informative. I doubt you'll be able to do it in General/AppleScript Studio, but you could do the class in Obj-C/Cocoa and call it from ASS (I suppose... I don't know anything about ASS).

----

Hey thanks dude. Yeah I guess i'd have to do it in cocoa, but ASS can call cocoa easily. I have already had to use cocoa and call it from ASS to get icons for files. Anyhow, the Finder window's side bars have the same thing as the accounts preference pane. The side bar in the finder windows is similar to the account tableview in accounts preference pane. Anyhow thanks very much for your help. Will try a class dump and see what I can use. Thanks!

OK, has anybody got this working properly? I subclassed General/NSTableView. The subclass contains the following code:

    
- (void)highlightSelectionInClipRect:(General/NSRect)clipRect
{
	General/NSImage *backgroundImage = General/[NSImage imageNamed:@"selectionGradient"];

	if(backgroundImage)
	{
		[backgroundImage setScalesWhenResized:YES];
		[backgroundImage setFlipped:YES]; // This was added 8 October 2004. See update below for more information.
		
		General/NSRect drawingRect;
		drawingRect = [self rectOfRow:[self selectedRow]];

		General/NSSize bgImageSize;
		bgImageSize = drawingRect.size;
		[backgroundImage setSize:bgImageSize];

		General/NSRect imageRect;
		imageRect.origin = General/NSZeroPoint;
		imageRect.size = [backgroundImage size];

		[backgroundImage drawInRect:drawingRect
						   fromRect:imageRect
						  operation:General/NSCompositeSourceOver
						   fraction:1.0];
	}
}

- (void)drawBackgroundInClipRect:(General/NSRect)clipRect
{
	General/[[NSColor whiteColor] set];
	General/NSRectFill(clipRect);
}


The background image scales properly and tracks with the selection, but the problem is the gray highlight color is still being drawn on top of it! Any ideas?

Here's a snapshot:

http://homepage.mac.com/tylers/Development/images/General/TableViewProblems.jpg

* Once again, I posted before thoroughly searching: http://www.cocoadev.com/index.pl?General/RoundedRectRowHighlighting

I was missing the following method in my subclass of General/NSTableView:*

    
- (id)_highlightColorForCell:(General/NSCell *)cell
{
	return nil;
}


And the fixed version:

http://homepage.mac.com/tylers/Development/images/General/TableViewFixed.jpg

*Update: 8 October 2004*
I noticed as I was doing some more work on this that the image was flipped across the Y axis (the lighter portion of the highlight is on the top in the image and in Accounts.prefPane, but it's on bottom in the pictures above). To fix this, simply put [backgroundImage setFlipped:YES]; after [backgroundImage setScalesWhenResized:YES]; (See updated source above).

Now it should work properly:

http://homepage.mac.com/tylers/Development/images/General/TableViewFixedHighlight.jpg

You'll notice in the picture above that I also have the divider and the top and bottom cells. Here's how everything is arranged: a custom General/NSView holds an General/NSControl for the top cell (in the Accounts.prefPanel, this top cell is your user), a custom General/NSTableView for the list of objects (in Accounts.prefPanel this is populated with all the other users on the system), and another General/NSControl for the bottom cell (login options). The controls use a background image to make it seem like they are in the table view. The dividers are simply the borders between the table view and the two controls. I have subclassed General/NSActionCell to handle the drawing of the background in the two General/NSControls - these subclasses are called from the custom General/NSView's controller (via setCell).

General/TylerStromberg

----
Any ideas on how to do the title row(s)? Also, any ideas on how to add the icon and subtext to the cells? Am I going to have to subclass General/NSCell also?

*Update: 7 October 2004*

After looking at the class-dump for the preference pane, I noticed the class General/UsersTableCell (which is a subclass of General/NSCell).

Here's it's interface file:
    
@interface General/UsersTableCell : General/NSCell
{
	General/NSDictionary *mValueDict;
	BOOL mFirstCell;
	General/NSImage *mSharedAlteredImage;
}

- (void)dealloc;
- (void)setObjectValue:(id)fp8;
- (void)_drawHighlightWithFrame:(struct _NSRect)fp8 inView:(id)fp24;
- (void)drawInteriorWithFrame:(struct _NSRect)fp8 inView:(id)fp24;
- (void)setFirstCell:(BOOL)fp8;

@end

I'm assuming that mValueDict stores the following info for the cell: 1. whether it's the first cell or not 2. the user's first and last name 3. the admin/standard string 4. the image to be displayed. Then drawInteriorWithFrame overwrites General/NSCell's method and handles all the custom drawing (including positioning of all the above-mentioned elements or just drawing "the title thing"). Right? OK, so how do we tackle this??

*Update: 9 October 2004*

After a few hours of coding, I have accomplished a lot of stuff. I have created 3 subclasses: 2 for the custom General/NSControls on the bottom and top of the table and one for the custom General/NSCell that gets drawn in the table. I have figured out how to draw the background in both the General/NSControls. Also, the bottom control draws the "home" icon and the two text strings. The General/NSCell subclass draws the icon, string, and substring. It also draws the label cells (the gray, unselectable ones), but I can't figure out how to change the label rows' height.

Check it out:

http://homepage.mac.com/tylers/Development/images/General/TableViewWithIcons.jpg

So now we just have to figure out how to handle selection in the two General/NSControls and how to adjust the row height on the rows that are only labels.

I'll post my code

General/TylerStromberg

----

Will you share the whole code please?

*That is the whole code. Those three methods are the complete subclass of General/NSTableView. Just go into IB, click on the classes tab. Find General/NSTableView in the hierarchy and hit return (creating a subclass). Name it whatever you want. Tell IB to create the files for it, then just copy and paste the 3 methods above into the implementation file in General/XCode. Note that you'll need to grab the highlight image named "selectionGradient.png" from /System/Library/General/PreferencePanes/Accounts.prefPane

General/TylerStromberg*

----

<broken record>anyone figured out how to change/override the ugly black highlight rect when you drag onto a cell in a tableview?</broken record>

General/EcumeDesJours

----
Wow, I haven't been back here for a while and I thought I'd drop into this page to see if it had been updated at all and...  my jaw dropped to the floor.
Thanks for all of the interest in the topic, and the code :D I'm a little more fluent in table views now, since I decided to completely rewrite my app in cocoa. When you do get the selection thing going for the General/NSControls, It would be sweet to post all of the code from the project. Because you said earlier that you created 3 subclasses, but they aren't on this page at the moment. It mustn't have gone through the last time you posted. I just gotta get the text highlight white when selected, which shouldn't be a too bigger deal.

Cheers
Louis

----
Louis,

I'll try and post all the code I have tomorrow afternoon. I've been quite busy as of late, so I haven't had a lot of time to work on it. I'm basically still stuck at the same point I was a few weeks ago...

*my jaw dropped to the floor*

Thanks! Not bad for only starting to learn Cocoa 4 weeks ago, eh? =)

Tyler

----
Not bad, I only started about 4 days ago :P I'm surprised I can actually get something into a table view at all!

Looking forward to it!

Louis

----
OK, here it is! Disclaimer: I haven't looked through it in a while, so there's probably some stuff in there that isn't necessary and is there because I was testing something...

General/AppController.h
    
/* General/AppController */

#import <Cocoa/Cocoa.h>

@interface General/AppController : General/NSObject
{
    General/IBOutlet General/IQAquaTableView *tableView;
	General/NSMutableArray *_people;
}

- (General/IBAction)addPerson:(id)sender;
- (General/IBAction)removePerson:(id)sender;

@end


General/AppController.m
    
#import "General/AppController.h"

@implementation General/AppController

- (id)init
{
	if(self = [super init])
	{
		_people = General/[[NSMutableArray alloc] init];

		Person *labelRecord = General/Person alloc] init];
		[[labelRecord personProperties] setValue:@"label;Other People" forKey:@"name"];
		[_people addObject:labelRecord];
		
		Person *newPerson = [[Person alloc] init];
		[_people addObject:newPerson];
	}

	return self;
}

- (void)dealloc
{
	[_people release];
	[super dealloc];
}


#pragma mark -
#pragma mark UI Methods
- (void)addPerson:(id)sender
{
}

- (void)removePerson:(id)sender
{
}


#pragma mark -
#pragma mark Table Datasource Methods

- (id)tableView:([[NSTableView *)aTableView
    objectValueForTableColumn:(General/NSTableColumn *)aTableColumn
			row:(int)rowIndex
{
	id tableColumnIdentifier = [aTableColumn identifier];
//	General/NSDictionary *personProperties = General/_people objectAtIndex:rowIndex] personProperties];

	if([tableColumnIdentifier isEqual:@"person"])
	{
		return [[_people objectAtIndex:rowIndex] personProperties]; //[personProperties objectForKey:@"name"];
	}
}

- (int)numberOfRowsInTableView:([[NSTableView *)aTableView
{
    return [_people count];
}

@end


*General/PeopleTableViewControl - This is the custom view that the top and bottom "cells" (ie the currently logged in user and the "Login Options") and the table view of other users are subviews of.*

General/PeopleTableViewControl.h
    
/* General/PeopleTableViewControl */

#import <Cocoa/Cocoa.h>

@interface General/PeopleTableViewControl : General/NSControl
{
    General/NSControl *mPeopleTableBottomControl;
    General/NSControl *mPeopleTableTopControl;
    General/IQAquaTableView *mPeopleTableView;
}

- (void)awakeFromNib;
- (BOOL)acceptsFirstResponder;
- (BOOL)becameFirstResponder;
- (BOOL)resignFirstResponder;
//- (id)hitTest:(General/NSPoint)mouseLocation; // I'm assuming this method will handle not letting the "label" cells to be highlighted, but I haven't implemented it yet...
- (void)scrollWheel:(id)sender;
- (void)mouseDown:(id)sender;
- (void)moveDown:(id)sender;
- (void)moveUp:(id)sender;
- (void)tableView:(General/NSTableView *)aTableView willDisplayCell:(id)aCell forTableColumn:(General/NSTableColumn *)aTableColumn row:(int)rowIndex;
- (BOOL)loginOptionsSelected;
- (id)selectedPerson;
- (void)rebuildPersonList;
- (void)selectSomething:(id)objectToSelect;
- (void)addNewPerson;

@end


General/PeopleTableViewControl.m
    
#import "General/PeopleTableViewControl.h"

@implementation General/PeopleTableViewControl

- (void)awakeFromNib;
{
	id topCell = General/[[PeopleTableTopCell alloc] init];
	[mPeopleTableTopControl setCell:topCell];

	id personCell = General/[[PeopleTableCell alloc] init];
	General/mPeopleTableView tableColumnWithIdentifier:@"person"] setDataCell:personCell];

	id bottomCell = [[[[PeopleTableBottomCell alloc] init];
	[mPeopleTableBottomControl setCell:bottomCell];
}


#pragma mark -
#pragma mark Table Delegate Methods

- (void)tableView:(General/NSTableView *)aTableView 
  willDisplayCell:(id)aCell 
   forTableColumn:(General/NSTableColumn *)aTableColumn
			  row:(int)rowIndex
{
	if(rowIndex==[aTableView selectedRow])
	{
	}
}

@end


*General/PeopleTableTopCell - This is the custom class that handles the top "cell" of the table (which is actually an General/NSControl with a background image)*

General/PeopleTableTopCell.h
    
/* General/PeopleTableTopCell */

#import <Cocoa/Cocoa.h>

@interface General/PeopleTableTopCell : General/NSActionCell
{
    General/NSImage *mBackgroundImage;
    General/NSMutableAttributedString *mTitleString;
}

- (void)dealloc;
- (id)representedObject;
- (void)drawInteriorWithFrame:(General/NSRect)cellFrame inView:(General/NSView *)controlView;
- (BOOL)acceptsFirstResponder;

@end


General/PeopleTableTopCell.m
    
#import "General/PeopleTableTopCell.h"

@implementation General/PeopleTableTopCell

- (void)dealloc
{
	[mBackgroundImage release];
	[mTitleString release];
}

- (id)representedObject
{
	return [self objectValue];
}

- (void)drawInteriorWithFrame:(General/NSRect)cellFrame inView:(General/NSView *)controlView
{
	mBackgroundImage = General/[NSImage imageNamed:@"General/TopCell"];
	General/NSImage *personImage = General/[NSImage imageNamed:@"Snowflake"];
	General/NSSize personImageSize;
	General/NSMutableAttributedString *cellPersonName = General/[[NSMutableAttributedString alloc] initWithString:@"Tyler Stromberg"];
	General/NSMutableAttributedString *cellPersonTitle = General/[[NSMutableAttributedString alloc] initWithString:@"New to Cocoa"];
	
    if (mBackgroundImage != nil)
	{
		[controlView lockFocus];
        [mBackgroundImage compositeToPoint:cellFrame.origin operation:General/NSCompositeSourceOver];
		[controlView unlockFocus];
	}

	
	General/NSString *cellLabel = General/[[NSString alloc] initWithString:@"My Account"];
	General/NSMutableAttributedString *attributedCellLabel = General/[[NSMutableAttributedString alloc] initWithString:cellLabel];
	General/NSRect labelRect;

	[attributedCellLabel addAttribute:General/NSFontAttributeName
								value:General/[NSFont systemFontOfSize:11]
								range:General/NSMakeRange(0, [attributedCellLabel length])];
	[attributedCellLabel addAttribute:General/NSForegroundColorAttributeName
								value:General/[NSColor grayColor]
								range:General/NSMakeRange(0, [attributedCellLabel length])];

	if([controlView isFlipped])
		General/NSDivideRect(cellFrame,&labelRect,&cellFrame,22.0,General/NSMinYEdge);

	else
		General/NSDivideRect(cellFrame,&labelRect,&cellFrame,22.0,General/NSMaxYEdge);

	[attributedCellLabel drawAtPoint:General/NSMakePoint(labelRect.origin.x + 8, labelRect.origin.y + (labelRect.size.height - [attributedCellLabel size].height)/2 - 2)];

	if([self isHighlighted])
	{
		General/NSImage *backgroundImage = General/[NSImage imageNamed:@"selectionGradient"];
		
		if(backgroundImage)
		{
			[backgroundImage setScalesWhenResized:YES];
			if([backgroundImage isFlipped])
				[backgroundImage setFlipped:NO];
			
			General/NSRect drawingRect;
			drawingRect = cellFrame;
//			drawingRect.size.height -= 2;
			drawingRect.origin.y -= 1;
			
			General/NSSize bgImageSize;
			bgImageSize = General/NSMakeSize(drawingRect.size.width,33);
			[backgroundImage setSize:bgImageSize];
			
			General/NSRect imageRect;
			imageRect.origin = General/NSZeroPoint;
			imageRect.size = [backgroundImage size];
			
			if(drawingRect.size.width != 0 && drawingRect.size.height != 0)
				[backgroundImage drawInRect:drawingRect
								   fromRect:imageRect
								  operation:General/NSCompositeSourceOver
								   fraction:1.0];
		}

		[cellPersonName addAttribute:General/NSForegroundColorAttributeName
							   value:General/[NSColor whiteColor]
							   range:General/NSMakeRange(0, [cellPersonName length])];	
		[cellPersonTitle addAttribute:General/NSForegroundColorAttributeName
								value:General/[NSColor whiteColor]
								range:General/NSMakeRange(0, [cellPersonTitle length])];
	}
	
	personImageSize.height = (cellFrame.size.height - 10);
	personImageSize.width = personImageSize.height;

	if(personImage != nil)
	{
		[personImage setScalesWhenResized:YES];
		[personImage setSize:personImageSize];
		
		[controlView lockFocus];
		
		if ([controlView isFlipped])
			[personImage compositeToPoint:General/NSMakePoint(cellFrame.origin.x + 6, (cellFrame.origin.y + 3) + [personImage size].height) operation:General/NSCompositeSourceOver];
		else
			[personImage compositeToPoint:General/NSMakePoint(cellFrame.origin.x + 6, cellFrame.origin.y + 3) operation:General/NSCompositeSourceOver];
		
		[controlView unlockFocus];
	}
	
	if (cellPersonName != nil)
	{
		[cellPersonName addAttribute:General/NSFontAttributeName 
						   value:General/[NSFont systemFontOfSize:13]
						   range:General/NSMakeRange(0, [cellPersonName length])];

		if([controlView isFlipped])
			[cellPersonName drawAtPoint:General/NSMakePoint(cellFrame.origin.x + [personImage size].width + 12, cellFrame.origin.y - 1)];
		else
			[cellPersonName drawAtPoint:General/NSMakePoint(cellFrame.origin.x + [personImage size].width + 12, (cellFrame.origin.y - 1) + [cellPersonTitle size].height)];
	}
	
	if (cellPersonTitle != nil)
	{
		[cellPersonTitle addAttribute:General/NSFontAttributeName
							value:General/[NSFont systemFontOfSize:11]
							range:General/NSMakeRange(0, [cellPersonTitle length])];

		if([controlView isFlipped])
			[cellPersonTitle drawAtPoint:General/NSMakePoint(cellFrame.origin.x + [personImage size].width + 12, (cellFrame.origin.y - 1) + [cellPersonName size].height)];
		else
			[cellPersonTitle drawAtPoint:General/NSMakePoint(cellFrame.origin.x + [personImage size].width + 12, cellFrame.origin.y - 1)];
	}
}

- (BOOL)acceptsFirstResponder
{
	return FALSE; // ??
}

@end


*General/PeopleTableCell - This is the custom subclass of General/NSCell that handles all the cell drawing in the table (the image, name string, and title string)*

General/PeopleTableCell.h
    
/* General/PeopleTableCell */

#import <Cocoa/Cocoa.h>

@interface General/PeopleTableCell : General/NSCell
{
	General/NSDictionary *mValueDict;
	General/NSImage *mPersonImage;
@public
	BOOL mLabelCell;
}

- (void)dealloc;
- (void)setObjectValue:(id <General/NSCopying>)object;
- (void)_drawHighlightWithFrame:(General/NSRect)cellFrame inView:(General/NSView *)controlView;
- (void)drawInteriorWithFrame:(General/NSRect)cellFrame inView:(General/NSView *)controlView;
- (void)setLabelCell:(BOOL)convertCellToLabel;
- (BOOL)cellIsLabelCell;

@end


General/PeopleTableCell.m
    
#import "General/PeopleTableCell.h"

@implementation General/PeopleTableCell

- (void)dealloc
{
	[mValueDict release];
	[mPersonImage release];
}

- (void)setObjectValue:(id <General/NSCopying>)object
{
	General/NSMutableAttributedString *personName = General/[[NSMutableAttributedString alloc] initWithString:[object valueForKey:@"name"]];
	General/NSMutableAttributedString *personTitle = General/[[NSMutableAttributedString alloc] initWithString:[object valueForKey:@"title"]];
	General/NSString *pictureName = General/[[NSString alloc] initWithString:[object valueForKey:@"picture"]];

	if([personName length] >= 6) // Make sure the string is long enough before trying to extract the first 6 characters from it
	{
		General/NSString *labelCellChecker = General/personName string] substringToIndex:6]; // Extract the first 6 characters so we can compare them to the label string
		if([labelCellChecker isEqualToString:@"label;"])
			mLabelCell = YES;
		else
			mLabelCell = NO;
	}

	[personName addAttribute:[[NSFontAttributeName 
					   value:General/[NSFont systemFontOfSize:13]
					   range:General/NSMakeRange(0, [personName length])];
	[personTitle addAttribute:General/NSFontAttributeName
						value:General/[NSFont systemFontOfSize:11]
						range:General/NSMakeRange(0, [personTitle length])];

	General/NSArray *keys = General/[NSArray arrayWithObjects:@"name", @"title", @"picture", @"labelCell", nil];
	General/NSArray *values = General/[NSArray arrayWithObjects:personName, personTitle, pictureName, General/[NSNumber numberWithBool:mLabelCell], nil];
	mValueDict = General/[[NSDictionary alloc] initWithObjects:values forKeys:keys];
}

- (void)drawInteriorWithFrame:(General/NSRect)cellFrame inView:(General/NSView *)controlView
{
	mPersonImage = General/[NSImage imageNamed:[mValueDict objectForKey:@"picture"]];
	General/NSSize personImageSize;
	General/NSMutableAttributedString *cellPersonName = [mValueDict objectForKey:@"name"];
	General/NSMutableAttributedString *cellPersonTitle = [mValueDict objectForKey:@"title"];

	if(!mLabelCell)
	{
		General/NSRect selectedCellRect = [controlView frameOfCellAtColumn:[controlView columnWithIdentifier:@"person"] row:[controlView selectedRow]];

		personImageSize.height = (cellFrame.size.height - 8);
		personImageSize.width = personImageSize.height;

		if((cellFrame.origin.x == selectedCellRect.origin.x) && (cellFrame.origin.y == selectedCellRect.origin.y) && (cellFrame.size.height == selectedCellRect.size.height) && (cellFrame.size.width == selectedCellRect.size.width))
		{
			[cellPersonName addAttribute:General/NSForegroundColorAttributeName
								   value:General/[NSColor whiteColor]
								   range:General/NSMakeRange(0, [cellPersonName length])];	
			[cellPersonTitle addAttribute:General/NSForegroundColorAttributeName
								value:General/[NSColor whiteColor]
								range:General/NSMakeRange(0, [cellPersonTitle length])];
		}
		
		if(mPersonImage != nil)
		{
			[mPersonImage setScalesWhenResized:YES];
			[mPersonImage setSize:personImageSize];

			[controlView lockFocus];

			if ([controlView isFlipped])
				[mPersonImage compositeToPoint:General/NSMakePoint(cellFrame.origin.x + 6, (cellFrame.origin.y + 3) + [mPersonImage size].height) operation:General/NSCompositeSourceOver];
			else
				[mPersonImage compositeToPoint:General/NSMakePoint(cellFrame.origin.x + 6, cellFrame.origin.y + 3) operation:General/NSCompositeSourceOver];

			[controlView unlockFocus];
		}

		if (cellPersonName != nil)
		{
			if([controlView isFlipped])
				[cellPersonName drawAtPoint:General/NSMakePoint(cellFrame.origin.x + [mPersonImage size].width + 12, cellFrame.origin.y - 1)];
			else
				[cellPersonName drawAtPoint:General/NSMakePoint(cellFrame.origin.x + [mPersonImage size].width + 12, (cellFrame.origin.y - 1) + [cellPersonTitle size].height)];
		}
		
		if (cellPersonTitle != nil)
		{
			if([controlView isFlipped])
				[cellPersonTitle drawAtPoint:General/NSMakePoint(cellFrame.origin.x + [mPersonImage size].width + 12, (cellFrame.origin.y - 1) + [cellPersonName size].height)];
			else
				[cellPersonTitle drawAtPoint:General/NSMakePoint(cellFrame.origin.x + [mPersonImage size].width + 12, cellFrame.origin.y - 1)];
		}
	}

	else
	{
		General/NSString *cellLabel = General/[mValueDict objectForKey:@"name"] string] substringFromIndex:6];
		[[NSMutableAttributedString *attributedCellLabel = General/[[NSMutableAttributedString alloc] initWithString:cellLabel];

		[attributedCellLabel addAttribute:General/NSFontAttributeName
						   value:General/[NSFont systemFontOfSize:11]
						   range:General/NSMakeRange(0, [attributedCellLabel length])];
		[attributedCellLabel addAttribute:General/NSForegroundColorAttributeName
							   value:General/[NSColor grayColor]
							   range:General/NSMakeRange(0, [attributedCellLabel length])];

		[attributedCellLabel drawAtPoint:General/NSMakePoint(cellFrame.origin.x + 7, cellFrame.origin.y + (cellFrame.size.height - [attributedCellLabel size].height)/2)];
	}
}

- (BOOL)cellIsLabelCell
{
	return mLabelCell;
}

@end


*General/PeopleTableBottomCell - This is the custom class that handles the bottom "cell" of the table (which is actually an General/NSControl with a background image)*

General/PeopleTableBottomCell.h
    
/* General/PeopleTableBottomCell */

#import <Cocoa/Cocoa.h>

@interface General/PeopleTableBottomCell : General/NSActionCell
{
	General/NSMutableAttributedString *mFirstString;
	General/NSMutableAttributedString *mSecondString;
    General/NSImage *mBackgroundImage;
	General/NSImage *mImage;
	General/NSImage *mSelectedImage;
}

- (void)dealloc;
- (void)drawInteriorWithFrame:(General/NSRect)cellFrame inView:(General/NSView *)controlView;
- (BOOL)acceptsFirstResponder;

@end


General/PeopleTableBottomCell.m
    
#import "General/PeopleTableBottomCell.h"

@implementation General/PeopleTableBottomCell

- (void)dealloc
{
	[mFirstString release];
	[mSecondString release];
	[mBackgroundImage release];
	[mImage release];
	[mSelectedImage release];
}

- (void)drawInteriorWithFrame:(General/NSRect)cellFrame inView:(General/NSView *)controlView
{
	mFirstString = General/[[NSMutableAttributedString alloc] initWithString:@"Login"];
	mSecondString = General/[[NSMutableAttributedString alloc] initWithString:@"Options"];
	mBackgroundImage = General/[NSImage imageNamed:@"General/BottomCell"];
	mImage = General/[NSImage imageNamed:@"General/LoginOptions"];
	mSelectedImage = General/[NSImage imageNamed:@"General/LoginOptionsWhite"];

    if (mBackgroundImage != nil)
	{
		[controlView lockFocus];
        [mBackgroundImage compositeToPoint:cellFrame.origin operation:General/NSCompositeSourceOver];
		[controlView unlockFocus];
	}

	if(mImage != nil)
	{
		[controlView lockFocus];
		[mImage compositeToPoint:General/NSMakePoint(cellFrame.origin.x+8, ([mBackgroundImage size].height - [mImage size].height)/2) operation:General/NSCompositeSourceAtop];
		[controlView unlockFocus];
	}

	General/NSString *plainCombinedString = General/[[NSString alloc] initWithFormat:@"%@ %@", [mFirstString string], [mSecondString string]];
	General/NSMutableAttributedString *combinedString = General/[[NSMutableAttributedString alloc] initWithString:plainCombinedString];

	if (combinedString != nil)
	{
		[combinedString addAttribute:General/NSFontAttributeName
							 value:General/[NSFont systemFontOfSize:13]
							 range:General/NSMakeRange(0, [combinedString length])];

		[combinedString drawAtPoint:General/NSMakePoint(cellFrame.origin.x + 8 + [mImage size].width + 6, ([mBackgroundImage size].height - [combinedString size].height)/2 - 1)];
	}
}

- (BOOL)acceptsFirstResponder
{
	return TRUE; // ??
}

@end


*General/IQAquaTableView - This is the custom subclass of General/NSTableView. It handles row highlighting and should handle the variable row height (but I can't figure out how to make it do so...*

General/IQAquaTableView.h
    
/* General/IQAquaTableView */

#import <Cocoa/Cocoa.h>

@interface General/IQAquaTableView : General/NSTableView
{
}

- (float)rowHeight;

@end


General/IQAquaTableView.m
    
#import "General/IQAquaTableView.h"

@implementation General/IQAquaTableView

- (id)_highlightColorForCell:(General/NSCell *)cell
{
	return nil;
}

- (void)highlightSelectionInClipRect:(General/NSRect)clipRect
{
   General/NSImage *backgroundImage = General/[NSImage imageNamed:@"selectionGradient"];

	if(backgroundImage)
	{
		[backgroundImage setScalesWhenResized:YES];
		[backgroundImage setFlipped:YES];
		
		General/NSRect drawingRect;
		drawingRect = [self rectOfRow:[self selectedRow]];
		drawingRect.size.height -= 2;

		General/NSSize bgImageSize;
		bgImageSize = drawingRect.size;
		[backgroundImage setSize:bgImageSize];

		General/NSRect imageRect;
		imageRect.origin = General/NSZeroPoint;
		imageRect.size = [backgroundImage size];

		if(drawingRect.size.width != 0 && drawingRect.size.height != 0)
			[backgroundImage drawInRect:drawingRect
						   fromRect:imageRect
						  operation:General/NSCompositeSourceOver
						   fraction:1.0];
	}
}

- (void)drawBackgroundInClipRect:(General/NSRect)clipRect
{
	General/[[NSColor whiteColor] set];
	General/NSRectFill(clipRect);
}

- (float)rowHeight
{
//	This method doesn't do what it's supposed to. The code below was a pathetic attempt by me to get it working properly, but to no avail.
//	I need to figure out a way to get the rows the label cells are in so this method can set them to the proper height.
//	Any help here would be GREATLY appreciated!

	General/PeopleTableCell *currentCell = General/[[PeopleTableCell alloc] init]; // Yeah, definitely not the right way to do it; "It was late and I was tired"

	if(currentCell->mLabelCell)
		return 22.0;
	else
		return 32.0;
}

@end


*Person - This class is basically what holds all the information about the people (icon to use, username, admin/standard string, etc)  - General/AppController has an General/NSMutableArray of these.*

Person.h
    
/* Person */

#import <Cocoa/Cocoa.h>

@interface Person : General/NSObject
{
	General/NSMutableDictionary *properties;
}

// Simple accessor methods
- (General/NSMutableDictionary *)personProperties;
- (void)setPersonProperties:(General/NSDictionary *)newProperties;

@end


Person.m
    
#import "Person.h"

@implementation Person

- (id)init
{
	if (self = [super init])
	{
		General/NSArray *keys = General/[NSArray arrayWithObjects:@"name", @"picture", @"title", nil];
		General/NSArray *values = General/[NSArray arrayWithObjects:@"Tyler Stromberg", @"Snowflake", @"Admin", nil];
		properties = General/[[NSMutableDictionary alloc] initWithObjects:values forKeys:keys];
	}
	return self;
}

- (void)dealloc
{
	[properties release];
	
	[super dealloc];
}

- (id)copyWithZone:(General/NSZone *)zone
{
	return nil;
}

// Simple accessor methods

- (General/NSMutableDictionary *)personProperties
{
	return properties;
}

- (void)setPersonProperties:(General/NSDictionary *)newProperties
{
	if (properties != newProperties)
	{
		[properties autorelease];
		properties = General/[[NSMutableDictionary alloc] initWithDictionary:newProperties];
	}
}

@end


(Note, to get the above code working, you need to get the images that are referenced from the Accounts.prefPane bundle and /Library/User Pictures/Nature/)

Well, there you have it. Some help from more experienced Cocoa developers on getting the variable row height working would be greatly appreciated. Also, right now the top and bottom cells currently only do a click-like selection instead of the constant that they should. I think that this needs to be handled in General/PeopleTableViewControl's hitTest method. Also, if any experienced Cocoa developers have any suggestions regarding anything in the source, please let me know.

----
Sweet, thats some nice code. But I'm having trouble piecing it together. I get heaps of errors while compiling. Its really weird because I get parse errors, and first use in function errors. I tried to put some #import ".h" files and that helped a little bit. But I still can't iron out the errors. I have completely no idea on what's going wrong!?!? I don't think I've put together some files or anything right :P It would be great if I could get something to compare it to, and then fix up the mess I've made. Have you got the Xcode or pbproj project handy? My email address is soundust@bigpond.net.au or AIM: macuser36 it would be really cool if you could send it, if it isn't too much trouble.

I must be eating you out of house and home :P Thanks sooo much mate.

----

Indeed, can someone put together an example project for the ones that haven't been following from the start?

----

Agreed.

----
I have all the header files being imported in the precompiled header file, so I think that's why you're getting parse errors.

Anyway... I'll stuff my General/XCode project and post it on my site tomorrow morning for everybody. I'll try to add as many comments to the code as I can to make it easier to read/understand.

*Update - 22 October 2004:* I just posted the project to my site: http://homepage.mac.com/tylers/ (it's the .zip file called General/AquaTable) Note: I haven't had time to add comments yet, but for those of you who can't wait, there you go! I'll add comments and update the archive ASAP.

OK, I've done some work on the source: now, the table will only allow selection of non-label cells (ie the "Other People" row above is no longer selectable). However, I can't figure out how to do it by using the cellIsLabelCell method, because I can't figure out how to isolate the particular cell in the table view. So instead, I'm basically getting the name from the dataSource and checking to see if the first 6 characters are "label;" again.

Here's my source that I added to General/PeopleTableViewControl (the delegate for the table view):

    
- (BOOL)tableView:(General/NSTableView *)aTableView
  shouldSelectRow:(int)rowIndex
{
	id personInCell = General/aTableView dataSource] personAtIndex:rowIndex];
	[[NSMutableAttributedString *personName = General/[[NSMutableAttributedString alloc] initWithString:[personInCell valueForKey:@"name"]];
	
	if(General/[personName string] substringToIndex:6] isEqualToString:@"label;"])
		return NO;
	else
		return YES;
}


Any thoughts on how to change the above code to get the specified cell at rowIndex, and then check this cell to see if it is a label cell (by calling it's cellIsLabelCell method)?

[[TylerStromberg

----
This page is too long now... go to General/NSTableViewInFinderWindowsA
----

postmortem:
Well, _highlightColorForCell seems not to be around anymore in Leopard :-(