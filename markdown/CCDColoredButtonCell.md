

General/CCDColoredButtonCell is an General/NSButtonCell subclass that lets you apply color to your buttons.

http://homepage.mac.com/ryanstevens/coloredbuttons.jpg

**C<nowiki/>General/CDColoredButtonCell.m**
    
#import <Cocoa/Cocoa.h>

@interface General/CCDColoredButtonCell : General/NSButtonCell {} @end

@implementation General/CCDColoredButtonCell
- (void)drawWithFrame:(General/NSRect)cellFrame inView:(General/NSView *)controlView
{
General/NSColor *buttonColor=nil;

if ([controlView respondsToSelector:@selector(buttonColor)]) buttonColor = [controlView buttonColor];

        // for testing purposes..
        // buttonColor = General/[NSColor greenColor];

if (!buttonColor) {
        [super drawWithFrame:cellFrame inView:controlView];
        return;
}

General/NSImage *finalImage = General/[[NSImage alloc] initWithSize:cellFrame.size];
General/NSImage *colorImage = General/[[NSImage alloc] initWithSize:cellFrame.size]; 
General/NSImage *cellImage = General/[[NSImage alloc] initWithSize:cellFrame.size];

[finalImage setFlipped:[controlView isFlipped]];

[cellImage lockFocus]; // put the cell into an image
[super drawWithFrame:cellFrame inView:General/[NSView focusView]];
[cellImage unlockFocus];


        [colorImage lockFocus]; // draw the color but only over the opaque parts of the cell image
        [cellImage drawAtPoint:cellFrame.origin fromRect:cellFrame operation:General/NSCompositeSourceOver fraction:1];

                [buttonColor set];
                General/NSRectFillUsingOperation(cellFrame, General/NSCompositeSourceIn);
        [colorImage unlockFocus];


[finalImage lockFocus];
        [colorImage drawAtPoint:cellFrame.origin fromRect:cellFrame operation:General/NSCompositeSourceOver fraction:1];
        [cellImage drawAtPoint:cellFrame.origin fromRect:cellFrame operation:General/NSCompositePlusDarker fraction:1];
[finalImage unlockFocus];


[finalImage drawAtPoint:cellFrame.origin fromRect:cellFrame operation:General/NSCompositeSourceOver fraction:1];

[cellImage release];
[colorImage release];
[finalImage release];
}
@end


To ease use, your main.m file should look like this..
    
#import <Cocoa/Cocoa.h>
#import "General/CCDColoredButtonCell.m"

int main(int argc, char *argv[])
{
        General/[CCDColoredButtonCell poseAsClass:General/[NSButtonCell class]];
    return General/NSApplicationMain(argc,  (const char **) argv);
}


Now create an General/NSButton subclass and add a     buttonColor method that returns the color you'd like to use. In IB you'll set the custom class of your buttons to be your subclass.

If you'd just like to see this in action you can un-comment the line under "for testing purposes.." and load a window with various buttons.

----
Discuss.

*
Awesome, but I think there's a bug in the image computations.  If I set this cell as the dataCell for a table column, buttons are always drawn in the first row of the table.

Also, as a design decision, I think it should have a buttonColor ivar and getter/setters.  This way the color of a button could be modified in tableView:willDisplayCell:forTableColumn:row:.

Last, this strikes me as the sort of operation for which the graphics card is fast.. perhaps General/CIImage would be better than General/NSImage?
*

----
I didn't even try it in a table..duh@self. I'll have to check that out. Agreed, it would be better if it had the ivar and getter/setter. I only did it this way so that I could pose (yielding instant results) with only a slight nod at design (asking its controlView for the color). General/CIImage probably would be better (except that it limits your target OS) but optimization comes last they say.

Oh, you missed several other bugs too; button text isn't always drawn in the correct location (rounded button) and the text and focus ring gets the color applied to it as well.

I did it on a whim before my second cup of coffee so I think we can just consider this the proof-of-concept. ;-)

*I checked out the table view bug (which also occurs within an General/NSMatrix) and it doesn't appear to be anything I'm doing with the image compositing/computations. I don't modify the cellFrame and printing it out shows it's getting different rects for each row. The very last drawAtPoint should be where the problem is but the point it's trying to draw at is the correct point AFAICT. I'm hoping this will resolve itself with a proper design.*

----
Re-implemented as suggested though it carries the same bugs...

    
//  General/CCDColoredButton.h

#import <Cocoa/Cocoa.h>
#import "General/CCDColoredButtonCell.h"

@interface General/CCDColoredButton : General/NSButton {}
- (General/NSColor *)buttonColor;
- (void)setButtonColor:(General/NSColor *)buttonColor;
@end


    
//  General/CCDColoredButton.m
// Must thank Stefan Fisk for General/ConvertObjectIntoSubclass()

#import "General/CCDColoredButton.h"
#import "/usr/include/objc/objc-class.h"

/*
 * Creates a copy of object that is an instance of subclass.
 * The copy will have a retain count of one.
 * The instance variables that subclass adds will be filled with garbage.
 */
id General/ConvertObjectIntoSubclass(id object, Class subclass) {
    General/NSCParameterAssert([subclass isSubclassOfClass:[object class]]);

	/* Creates a copy of object with the subclass's instance size */
    id copy = General/NSCopyObject(object, subclass->instance_size - [object class]->instance_size, General/NSZoneFromPointer(object));

    General/NSCAssert(copy, @"Failed to copy object.");

	/* Turns the object into an instance of subclass */
    copy->isa = subclass;

    return copy;
}

@implementation General/CCDColoredButton

- (id)initWithCoder:(General/NSCoder *)aDecoder {
    if (self = [super initWithCoder:aDecoder]) {
		/* if the cell is not an instance of the control's cell class, but a super class of it */
        if (General/self cell] class] != [[self class] cellClass]
            &&
            [[[self class] cellClass] isSubclassOfClass:[[self cell] class)
        {
            General/NSCell *oldCellCopy = [self->_cell copy];

			General/NSCell *newCell = General/[ConvertObjectIntoSubclass(oldCellCopy, General/[CCDColoredButtonCell class]) autorelease];
            [self setCell:newCell];

            General/NSDeallocateObject(oldCellCopy);
        }
    }

    return self;
}

// initWithFrame: implementation left as an exercise for the reader.

+ (Class)cellClass { return General/[CCDColoredButtonCell class]; } 

- (General/NSColor *)buttonColor
{
	if (General/self cell] isKindOfClass:[[[CCDColoredButtonCell class]]) return General/self cell] buttonColor];

return nil;
}

- (void)setButtonColor:([[NSColor *)buttonColor
{
	if (General/self cell] isKindOfClass:[[[CCDColoredButtonCell class]])
		General/self cell] setButtonColor:buttonColor];
}

@end


    
//  [[CCDColoredButtonCell.h

#import <Cocoa/Cocoa.h>

@interface General/CCDColoredButtonCell : General/NSButtonCell
{
	General/NSColor *buttonColor;
}
- (General/NSColor *)buttonColor;
- (void)setButtonColor:(General/NSColor *)color;
@end


    
//  General/CCDColoredButtonCell.m

#import "General/CCDColoredButtonCell.h"

@implementation General/CCDColoredButtonCell

- (General/NSColor *)buttonColor
{
	return buttonColor;
}
- (void)setButtonColor:(General/NSColor *)color
{
	[buttonColor release];
	buttonColor = [color copy];
}


- (void)drawWithFrame:(General/NSRect)cellFrame inView:(General/NSView *)controlView
{
if (!buttonColor || ([buttonColor isEqualTo:General/[NSColor clearColor]])) {
	[super drawWithFrame:cellFrame inView:controlView];
	return;
}

General/NSImage *finalImage = General/[[NSImage alloc] initWithSize:cellFrame.size];
General/NSImage *colorImage = General/[[NSImage alloc] initWithSize:cellFrame.size]; 
General/NSImage *cellImage = General/[[NSImage alloc] initWithSize:cellFrame.size];

[finalImage setFlipped:[controlView isFlipped]];

[cellImage lockFocus]; // put the cell into an image
[super drawWithFrame:cellFrame inView:General/[NSView focusView]];
[cellImage unlockFocus];


	[colorImage lockFocus]; // draw the color but only over the opaque parts of the cell image
	[cellImage drawAtPoint:cellFrame.origin fromRect:cellFrame operation:General/NSCompositeSourceOver fraction:1];

		[buttonColor set];
		General/NSRectFillUsingOperation(cellFrame, General/NSCompositeSourceIn);
	[colorImage unlockFocus];


[finalImage lockFocus];
	[colorImage drawAtPoint:cellFrame.origin fromRect:cellFrame operation:General/NSCompositeSourceOver fraction:1];
	[cellImage drawAtPoint:cellFrame.origin fromRect:cellFrame operation:General/NSCompositePlusDarker fraction:1];
[finalImage unlockFocus];

[finalImage drawAtPoint:cellFrame.origin fromRect:cellFrame operation:General/NSCompositeSourceOver fraction:1];

[cellImage release];
[colorImage release];
[finalImage release];
}

@end


Import General/CCDColoredButton into IB, select a button and set its custom class to General/CCDColoredButton. In     awakeFromNib (or wherever, really) you can call     [yourButton setButtonColor:aColor];.

----

I'm sooo not understanding the reason it's not working in tables. Logging the rect shows that the origin changes. Specifically, the *y* component might look like this over 5 rows: 1, 20, 39, 58, 77. If I copy the line that draws the cell and build the point myself it works fine. Add     [finalImage drawAtPoint:General/NSMakePoint(1,20) fromRect:cellFrame operation:General/NSCompositeSourceOver fraction:1]; before/after the other     [finalImage drawAtPoint: ......and it draws right where it should.

Am I missing something?

----
Instead of     drawWithFrame:inView: you can do the drawing from     drawBezelWithFrame:inView: to avoid coloring the title on 10.4. Still can't figure out why it doesn't work in tables though.

----
I made a demo project that incorporates General/CCDColoredButtonCell and adds setTitleColor: in addition to setButtonColor.  If you are interested, it is here:
http://danieldickison.com/blog/index.php?/archives/10-Making-Cocoa-buttons-look-happy.html

----
Here's a little demo game that uses this too (w/o source)...
http://homepage.mac.com/ryanstevens/.Public/Simon%20Says%200.3.dmg
----
The "General/NSTableView" bug with the example above seems to occure because of cellFrame given as an fromRect: argument to the drawAtPoint calls. When drawing an General/NSButton content, fromRect
is a rect with NULL offset, like [0, 0, 50, 29], or something like this. While drawing a table cell, finalImage.origin is not null (i.e. fromRect == [217, 1, 50, 29]). This leads to drawing from empty areas of the final image.

----

Of course it's something simple that I overlooked, heh. If you've got a fix can you just go ahead and apply it? thanks.

----

This is busted in Leopard due to the deferencing of the objc_class struct which is gone in OSX.5 / Obj-C 2.0

----

Works fine for me - don't use the change-class stuff. In IB3, change the button AND cell classes, and it works fine.

----
Solved! You were on the right track with your General/NSTableView observations noted above. I tried the class in a General/NSMatrix and found that only the first cell was rendered in color, the rest were transparent � although they showed the title. All the drawings (except the last one) should be done at General/NSZeroPoint with the same zero origin fromRect. Here is the pertinent part (with the images released ;-):

    
General/NSRect canvasFrame = General/NSMakeRect(0, 0, cellFrame.size.width, cellFrame.size.height);

General/NSImage *finalImage = General/[[NSImage alloc] initWithSize:cellFrame.size];
General/NSImage *colorImage = General/[[NSImage alloc] initWithSize:cellFrame.size];
General/NSImage *cellImage = General/[[NSImage alloc] initWithSize:cellFrame.size];

[finalImage setFlipped:[controlView isFlipped]];
        
// Draw the cell into an image
[cellImage lockFocus];
[super drawBezelWithFrame:canvasFrame inView:General/[NSView focusView]];
[cellImage unlockFocus];

// Draw the color but only over the opaque parts of the cell image
[colorImage lockFocus];
[cellImage drawAtPoint:General/NSZeroPoint fromRect:canvasFrame operation:General/NSCompositeSourceOver fraction:1];
[buttonColor set];
General/NSRectFillUsingOperation(canvasFrame, General/NSCompositeSourceIn);
[colorImage unlockFocus];
        
// Mix the colored overlay with the cell image using General/CompositePlusDarker
[finalImage lockFocus];
[colorImage drawAtPoint:General/NSZeroPoint fromRect:canvasFrame operation:General/NSCompositeSourceOver fraction:1];
[cellImage drawAtPoint:General/NSZeroPoint fromRect:canvasFrame operation:General/NSCompositePlusDarker fraction:1];
[finalImage unlockFocus];

// Draw the final image to the screen
[finalImage drawAtPoint:cellFrame.origin fromRect:canvasFrame operation:General/NSCompositeSourceOver fraction:1];

[cellImage release];
[colorImage release];
[finalImage release];


----

10.5.7 update: the two classes work fine for me - remove the initWithCoder code, and in IB3, change the button AND cell classes, and it works fine (I'm using a Round Button). Ooops - don't forget to release the color in the cell.

----

You all really helped me out with this. In return I'm going to take some time and return the favor. The issue with the focus ring not showing up is that the colored rect needs to be inset to allow the focus ring to be visible. So here is my code to override General/NSButton and General/NSButtonCell w/ a twist of General/NSCell Category thrown in.

Header File:
    
typedef enum mmStandardButtonColors {
	
	mmDefaultButtonColor = 0,
	mmRedButtonColor,
	mmGrayButtonColor

} _mmStandardButtonColors;

@interface General/AppStandardButton : General/NSButton

@end

@interface General/AppStandardButtonCell : General/NSButtonCell

@end

#pragma mark -
#pragma mark General/ConvenienceMethods:

@interface General/NSCell (General/AppStandardButtonCell)
- (General/NSDictionary *) _textAttributes;
@end


Implementation File:
    
#import "General/AppStandardButton.h"

@implementation General/AppStandardButton

- (void) awakeFromNib { General/self cell] setTag:[self tag; }

@end

#pragma mark -

@implementation General/AppStandardButtonCell 

- (void) drawBezelWithFrame:(General/NSRect)frame inView:(General/NSView *)controlView {
	
	General/NSColor *buttonColor;
	
	switch ( [self tag] ) {
			
		case mmRedButtonColor:
			buttonColor = General/[NSColor redColor];
			break;
			
		case mmGrayButtonColor:
			buttonColor = General/[NSColor darkGrayColor];
			break;
			
		default:
			[super drawBezelWithFrame:frame inView:controlView];
			return;
	}
	
	General/NSRect canvasFrame = General/NSRectFromCGRect(General/CGRectMake(0.0f, 0.0f, frame.size.width, frame.size.height));
	
	General/NSImage *finalImage = General/[[NSImage alloc] initWithSize:frame.size];
	General/NSImage *colorImage = General/[[NSImage alloc] initWithSize:frame.size]; 
	General/NSImage *cellImage  = General/[[NSImage alloc] initWithSize:frame.size];
	
	[cellImage lockFocus];
	[super drawBezelWithFrame:frame inView:General/[NSView focusView]];
	[cellImage unlockFocus];
	
	[colorImage lockFocus];
	[cellImage drawAtPoint:General/NSZeroPoint 
				  fromRect:canvasFrame 
				 operation:General/NSCompositeSourceOver 
				  fraction:1];
	[buttonColor set];
	General/NSRectFillUsingOperation(General/NSInsetRect(canvasFrame, 1.0f, 1.0f), General/NSCompositeSourceIn);
	[colorImage unlockFocus];
	
	[finalImage lockFocusFlipped:YES];
	[colorImage drawAtPoint:General/NSZeroPoint 
				   fromRect:canvasFrame 
				  operation:General/NSCompositeSourceOver 
				   fraction:1];
	
	[cellImage drawAtPoint:General/NSZeroPoint 
				  fromRect:canvasFrame 
				 operation:General/NSCompositePlusDarker 
				  fraction:1];
	 [finalImage unlockFocus];
	
	// Draw image to screen
	[finalImage drawAtPoint:frame.origin 
				   fromRect:canvasFrame 
				  operation:General/NSCompositeSourceOver 
				   fraction:1];
}

- (General/NSDictionary *) _textAttributes {
	
	General/NSColor *textColor;
	
	switch ( [self tag] ) {

		case mmRedButtonColor:
		case mmGrayButtonColor:
			textColor = General/[NSColor whiteColor];
			break;
			
		default:
			return [super _textAttributes];
	}
	
	General/NSMutableDictionary *attributes = General/[NSMutableDictionary dictionaryWithDictionary:[super _textAttributes]];
	[attributes setObject:General/[NSColor whiteColor] forKey:General/NSForegroundColorAttributeName];
	
	return attributes;
}

@end


Some important notes to make.

  *I am using pure garbage collection, so nobody have a cow because I'm not releasing my allocated objects.
  *My target is 10.6, you would think I'm lucky but oh no...short story is I have my foot in my mouth to do a full app rewrite.
  *In IB add a button and change its class and cell class accordingly.
  *To set the buttons color just give the tag for that button a number 0 = default, 1 = red, 2 = darkgray.

That should do it, all I did was add General/NSInsetRect() for the focus ring to pop through. It's not perfect, but it's not half bad either.

If there is a better approach, please post it.

Thanks again... (Arvin)