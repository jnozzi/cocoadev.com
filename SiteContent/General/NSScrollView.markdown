[https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/ApplicationKit/Classes/nsscrollview_Class/Reference/Reference.html NSScrollView Class Reference]

[Topic]

----

Hello All,

I am wanting to make a list of files and folders, using the arrows for next folder as the finder does. Must this be one using a General/NSScrollView or can i do it with a General/NSTableView?

Anyway, how can i take an array, and then add a new arrow and sublist for a folder?

Thanks...

----

You'll want to use an General/NSOutlineView to get results like the Finder.

Check out the example Apple provides at: file:///Developer/Examples/General/AppKit/General/DragNDropOutlineView

-- General/JacobHazelgrove

----

Thanks, found file:///Developer/Examples/General/AppKit/General/OutlineView/ most use. now just got to work out how to transfer all the file names from the array into it, making the folders parents...hrm

----

It wasn't immediately obvious to me just how you go about making an General/NSScrollView with something inside of it. As it turns out, in General/InterfaceBuilder you can simply select any item and from the menus select:

    Layout->Make subviews of->Scroll View

This will create an General/NSScrollView that contains the item you had selected when you chose the menu item.

----

**Another Question**

I have a custom "navigation" view on the side of my window (a la Mail 2.0) which is all created in code. In that view I have a tabless tab view for various ways to present the data. In the one tab I have a tabviewitem whose view is a scroll view that autosizes with its parent. Peachy. The scroll view's document view contains a conglomeration of tableviews and other controls whose size and positioning I manually control (ie, they have no scrollviews of their own; they're all contained in the 'peachy' scrollview reference above). All the sizing and positioning is working just fine (ie, the document view grows and shrinks, my scroll view's bar appears and disappears as needed, etc.). The problem is when I'm scrolled to the top (the beginning of my custom list) and I resize the window to make it larger, the scrollview's clip view ends up half-way down my custom view. In other words, it doesn't anchor from the top. It's worth mentioning that my custom view (the scroll view's document view) *is* a flipped view. How can I anchor the scroll view's clip view to the top while resizing?

----

My solution to a similar problem was to resize the view as you have done and to also move the origin up accordingly.  Once you have the height you want, just use:

    
	General/NSRect newFrame = [self frame];
	newFrame.origin.y += minFrame.size.height - newHeight;
	newFrame.size.height = newHeight;
	[self setFrame:newFrame];


----

My solution for keeping a scroll view's document view anchored to the top:
    
@interface General/TopAnchoredView : General/NSView {
	float startHeight;
}
@end
@implementation General/TopAnchoredView
- (id)initWithFrame:(General/NSRect)frame {
	if ([super initWithFrame:frame]) {
		startHeight = General/NSHeight(frame);
	}
	return self;
}
- (void)setFrame:(General/NSRect)frame {
	frame.size.height = MAX(General/[self enclosingScrollView] contentView] frame].size.height, startHeight);
	[super setFrame:frame];
}
@end


Your document view should be a subclass of [[TopAnchoredView. It will then fill itself to the full height of the scroll view. If someone has a smarter approach, I'm all ears. -KSW

----

Concerning the problem to top-anchor the document of an <code>General/NSScrollView</code> � This is what worked for me:

*Creating a category on <code>General/NSClipView</code> (the class of the scrollview�s content view) with <code>-(BOOL)isFlipped</code> implemented and returning YES (and thus hiding and replacing the original method <code>isFlipped</code>)
*Overriding the document view�s (a subclass of <code>General/NSView</code>) <code>-(void)setFrame:(General/NSRect)frameRect</code> with one calling <code>[super setFrame:]</code>, but with an <code>General/NSRect</code> containing <code>General/NSZeroPoint</code> as origin, regardless of which origin was intended to set

For example NSC<nowiki/>lipView+M<nowiki/>yAdditions.h
    
#import <Cocoa/Cocoa.h>
#import "General/MyDocumentView.h"


@interface General/NSClipView (General/MyAdditions)

- (BOOL)isFlipped;

@end

and NSC<nowiki/>lipView+M<nowiki/>yAdditions.m
    
#import "General/NSClipView+General/MyAdditions.h"

@implementation General/NSClipView (General/MyAdditions)

- (BOOL)isFlipped
{
	return General/self documentView] isKindOfClass:[[[MyDocumentView class]];
}

@end

This replacement implementation of the original <code>isFlipped</code> checks, whether the document view is the custom document view, in order not to influence other scrollviews (identified by having document views of a different class).

And then the <code>setFrame:</code>-implementation of your custom document view:
M<nowiki/>yDocumentView.m
    
// ...
- (void)setFrame:(General/NSRect)frameRect
{
	/* let self (= document view of the scroll view) always stay
	 at zero/zero position within the content view�s coordinate system;
	 the scrolling is done anyway just by moving the content view�s bounds */
	frameRect.origin = General/NSZeroPoint;
	[super setFrame:frameRect];
}
// ...



For better understanding: The scrollview usually (unless you use rulers) contains three subviews, the two scrollers and the content view (an instance of <code>General/NSClipView</code>), which itself then contains the document view (an instance of a subclass of <code>General/NSView</code>).

For some (to me not clear) reasons the scrollview�s mechanisms set the document view�s frame origin to a negative y-coordinate (in some way but not easily predictably related to the scrollview�s size) and then achieves scrolling by setting the content view�s bounds origin to some value between the document view�s frame origin and higher.

If you just set the flipped of the content view, the scrollbars would stay bottom-anchored when the view is resized. (Imagine seeing the whole document view (so the scrollbars are disabled), and then making the scrollview smaller � you will see the bottom portion instead of the top portion of the document as the scrollview gets too small for the document view). The scrollview�s mechanisms do explicitly set the document view�s frame origin to that negative y-coordinate, resulting in this effect (it probably has to do with the content view being expected to have non-flipped coordinates).
However, if you (as I did above) prevent the document view from having a frame y-coordinate other than zero, the scrollview accepts everything and the document stays top-anchored as the scroll view�s size is decreased. 


For more information on the relation between a view�s frame and it�s bounds see http://developer.apple.com/mac/library/documentation/Cocoa/Conceptual/General/CocoaViewsGuide/Coordinates/Coordinates.html .

By the way, when digging deeper into the magic of scrollviews consider that the scrollview itself already uses flipped coordinates by default.

-GP from Austria


----

Useful to for adding headers/corners to General/NSScrollView's.

http://codehackers.net/blog/?p=10

JP