

see also [[WhereIsCoolSystemPrefsWindowEffect]]

When you lay out windows in Cocoa, you can use autosizing springs to make your window content change size when you resize the windows, using the built in [[AppKit]] "Box & Spring" approach. What can you do when you want the opposite effect? ie, you want a window to change size when something inside it changes its size...

Here's a solution I came up with this week, after spending a few evenings persuing blind alleys. I'm not claiming it will work in all circumstances, but it seems pretty good for my purposes.

Lets start by explaining the problem with some code:

<code> 

@interface [[LineBoxField]] : [[NSTextField]]

@implementation [[LineBoxField]]
- (void) setFont: ([[NSFont]] '') a_font {
    [super setFont: a_font];
    [self sizeToFit];
}

- (void) sizeToFit {
    float oldHeight = [[NSHeight]]([self bounds]);
    [self setPostsFrameChangedNotifications: NO];
    [super sizeToFit];
    float heightDiff = oldHeight - [[NSHeight]]([self bounds]);
    [[NSPoint]] origin = [self frame].origin;
    [self setFrameOrigin: [[NSMakePoint]](origin.x, origin.y + heightDiff)];
    [[self superview] setNeedsDisplay: YES]; //needed to ensure we don't get garbage when the field shrinks

    //this actually causes a notification to be fired
    [self setPostsFrameChangedNotifications: YES];

}
@end
</code>


This is code you could paste into pretty much any control to make it resize when its font is changed. As you can see it overrides the standard [[NSControl]]'s '''sizeToFit:''' method to resize the control and move it down by the amount the height changed. (As I'm sure you know Cocoa uses a bottom-left co-ordinate system, so if you want to top left corner of a view in the same place and resize it down and left, one has to adjust the origin like this - you'll see this theme repeated in other code in this article). I'm managing setPostsFrameChangedNotifications: (which is ON by default) to ensure the code only generates a single frame <code>[[NSViewFrameDidChangeNotification]]</code> If you don't do this, you get a Notification for <code>[super sizeToFit]</code> and for <code>[self setFrameOrigin: [[NSMakePoint]](origin.x, origin.y + heightDiff)]</code>

So far we have an [[NSControl]] with nice resize behaviour triggered when its font is changed, now we'll look at the source code for a panel that will listen for <code>[[NSViewFrameDidChangeNotification]]</code> and resize itself appropriately:


<code> 
#import <Cocoa/Cocoa.h>

@interface [[UFISpringyPanel]] : [[NSPanel]] {
@private
}

@end

#import "[[UFISpringyPanel]].h"
#import "[[UFIViewAdditions]].h"
#import "[[UFIWindowAdditions]].h"

@implementation [[UFISpringyPanel]]

- (void) awakeFromNib {
    [self contentResized: [[[NSNotification]] notificationWithName:
        [[NSViewFrameDidChangeNotification]] object: [self contentView]]];
}

- (void) setContentView: ([[NSView]] '') a_view {
    [super setContentView: a_view];
    [self observeSizeChanges: @selector(contentResized:)];
}

- (void) dealloc {
    [[[[NSNotificationCenter]] defaultCenter] removeObserver: self];
    [super dealloc];
}

@end

</code> 

That was fairly painless! Of course, all of the real code is hidden in the pair of Categories <code>[[UFIViewAdditions]]</code> and <code>[[UFIWindowAdditions]]</code>. I deliberately structured the code this way so if I ever need to create a <code>[[UFISpringyWindow]]</code> to complement this <code>[[UFISpringyPanel]]</code> I will only need to copy and paste the few lines above and reuse the Categories.

First, the view addition:

<code> 
#import <Cocoa/Cocoa.h>

@interface [[NSView]] ([[UFIViewAdditions]])
- (void) registerObserver: (id) a_observer forSizeChanges: (SEL) a_callback;
- ([[NSSize]]) checkIntersections: ([[NSRect]]) a_frame;
@end

#import "[[UFIViewAdditions]].h"
#define max(a,b) (((a)>(b))?(a):(b))

@implementation [[NSView]] ([[UFIViewAdditions]])

- (void) registerObserver: (id) a_observer forSizeChanges: (SEL) a_callback {
    [[NSNotificationCenter]] ''nc = [[[NSNotificationCenter]] defaultCenter];
    if ( [self postsFrameChangedNotifications] ) {
        [nc addObserver: a_observer
               selector: a_callback
                   name: [[NSViewFrameDidChangeNotification]]
                 object: self];
    }        
    [[NSArray]] ''children = [self subviews];
    if ( children != nil) {
        int childCount = [children count];
        int i=0;
        for (i=0; i < childCount; i++) {
            [[NSView]] ''child = ([[NSView]] '') [children objectAtIndex: i];
            [child registerObserver: a_observer forSizeChanges: a_callback];
        }
    }
}

- ([[NSSize]]) checkIntersections: ([[NSRect]]) a_frame {
    [[NSRect]] intersection = [[NSIntersectionRect]]([self frame], a_frame);
    [[NSSize]] delta = [[NSMakeSize]]([[NSWidth]]([self frame]) - [[NSWidth]](intersection),
                                  [[NSHeight]]([self frame]) - [[NSHeight]](intersection));
    [[NSArray]] ''children = [self subviews];
    if ( children != nil) {
        int childCount = [children count];
        int i=0;
        for (i=0; i < childCount; i++) {
            [[NSSize]] childDelta = [[children objectAtIndex: i] checkIntersections: a_frame];
            delta = [[NSMakeSize]](max(delta.width, childDelta.width), max(delta.height, childDelta.height));            
        }
    }
    return delta;
}

@end

</code>

These two methods walk the <code>[[NSView]]</code>'s subview heirarchy recursively. The first allows an object to register itself as an observer for <code>[[NSViewFrameDidChangeNotification]]</code>s coming from the view it applies to or any of its descendants. The second method looks for child views that are clipped by a rectangle <code>a_frame</code>.  It walks recursively through the children building up an <code>[[NSSize]] delta</code> that records the largest width and height that falls outside <code>a_frame</code>.

Now the window addition:

<code>
#import <Cocoa/Cocoa.h>

@interface [[NSWindow]] ([[UFIWindowAdditions]])
- (void) observeSizeChanges: (SEL) a_callback;
- (void) setFrameSizeMaintaingOrigin: ([[NSSize]]) a_newFrameSize;
- (void) contentResized: ([[NSNotification]] '') a_notification;
@end

#import "[[UFIWindowAdditions]].h"
#import "[[UFIViewAdditions]].h"

@interface [[NSWindow]] ([[UFIWindowAdditionsPrivateMethods]])
- (void) sizeToFit;
@end

@implementation [[NSWindow]] ([[UFIWindowAdditions]])

- (void) observeSizeChanges: (SEL) a_callback {
    [[NSView]] ''view = [self contentView];    
    if ( view == nil ) {
        [[[[NSNotificationCenter]] defaultCenter] removeObserver: self];
    } else {
        [view registerObserver: self forSizeChanges: a_callback];
    }
}

- (void) contentResized: ([[NSNotification]] '') a_notification {
    if ( [self contentView] != nil) {
        [[[[NSNotificationCenter]] defaultCenter] removeObserver: self];
        [self sizeToFit];
        [self observeSizeChanges: @selector(contentResized:)];
    }
}

- (void) sizeToFit {
    [[NSSize]] size = [self minSize];
    [[NSSize]] maxSize = [self maxSize];
    [[NSSize]] delta = [[NSMakeSize]](-1, -1);
    while ( size.width <= maxSize.width && size.height <= maxSize.height && ![[NSEqualSizes]](delta, [[NSZeroSize]]) ) {
        [self setFrameSizeMaintaingOrigin: size];
        delta = [[self contentView] checkIntersections: [[self contentView] bounds]];
        size.width += delta.width;
        size.height += delta.height;
    }
}

- (void) setFrameSizeMaintaingOrigin: ([[NSSize]]) a_newFrameSize {
    [[NSPoint]] origin = [self frame].origin;
    float originalHeight = [[NSHeight]]([self frame]);
    origin.y += (originalHeight - a_newFrameSize.height);
    [self setFrame: [[NSMakeRect]](origin.x, origin.y, a_newFrameSize.width, a_newFrameSize.height) display: YES animate: YES];
}

@end
</code>

The window addition is the core of the code. 

<code>observeSizeChanges:</code> � tells the window to begin listening for changes to the sizes of its <code>contentView</code>'s children


<code>setFrameSizeMaintaingOrigin:</code> � is a helper method that allows one to resize a window without its top left corner moving around

<code>contentResized:</code> � a public method that informs the window that its content has been resized and that it should recalculate it's size. It will usually be called when <code>[[NSViewFrameDidChangeNotification]]</code> is fired by one of the window's children, but other objects can explicitly call the method to force a recalculation of the size when they know one will be needed.

<code>sizeToFit</code> � is the private method that performs the actual work of resizing the window.

Firstly, this method is private for a particular reason. Note how <code>contentResized:</code> calls <code>sizeToFit</code> but it brackets the call with <code>[[[[NSNotificationCenter]] defaultCenter] removeObserver: self];</code> and <code>[self observeSizeChanges: @selector(contentResized:)];</code>, ie, it disables listening for <code>[[NSViewFrameDidChangeNotification]]</code>'s from the window's children before calling <code>sizeToFit</code> and then re-enables them after its done. This is necessary otherwise one will tend to get an infinite loop: calling <code>sizeToFit</code> will cause a resize, which will cause an <code>[[NSViewFrameDidChangeNotification]]</code> to be sent, which would call <code>contentResized:</code>, which would call <code>sizeToFit</code> again, making a loop. Temporarily disabling observing the <code>[[NSViewFrameDidChangeNotification]]</code>'s prevents the loop.

Here's the algorithm that causes the window to resize itself:


*set the window to its <code>minSize</code> as defined in [[InterfaceBuilder]] or via code
*loop while the window is less than its <code>maxSize</code>
    
    *use <code>checkIntersections</code> to see if all of the children fit within the current <code>bounds</code> of the window
    *if all children fit, stop
    *otherwise make the window larger by the amount indicated by <code>checkIntersections</code>



This algorithm allows the window to grow if it is too small for its current contents. If the window is too large for its contents, the algorithm works by first setting it to its mimimum size at the begining. It then grows, finding the smallest possible size that can work: this allowing the window to shrink if its contents has shrunk. The size is re-evaluated every time a child view changes size, as we are listening for <code>[[NSViewFrameDidChangeNotification]]</code> from all of the children.

For this to work correctly and look good you have to have a window which reflows nicely when it is resized. You can achieve this in the usual way by using <code>[[NSBox]]</code>es and setting up the autosizing springs in [[InterfaceBuilder]]. Make your window resizable and use IB's test mode to ensure your window reflows nicely when you drag it by its corner. If you do not want users to be able to resize the window by hand when your application is finished, you can disable manual resizing by the grow box once you are happy with the behaviour.

Aside: You might be wondering why we actually have to resize the window to its minimum size and grow it outwards again. Wouldn't it be simpler to just pass <code>self minSize</code> into <code>checkIntersections</code>, and go around the loop until the correct size has been determined, then just call <code>setFrame:</code> on the window with the final calculated size at the end? You'd think this would work, but it turns out to fail in many cases because of the autosizing springs. Consider a case where your window is too large: one of its children just became smaller and you want the window to shrink to the smallest size it can be given the new smaller contents. The trouble comes from the way one usually nests boxes in Cocoa. Its true that one child has just shrunk, but what it its previous larger size had caused some other springy component in the window to also be large? Well, then the window would never shrink because the large sibling would keep the window large, even though the view that triggered the resize has shrunk. Therefore it is necessary to actually shrink the window so all children with their autosizing springs set are forced to be as small as they can be. (Don't worry if you can't follow this paragraph: its not important to understand this to actually use the code and its difficult to put into words.)

Well, that's the algorithm. It works for me in the case I need it too. As my text field's font changes, the window containing the field resizes itself, growing and shrinking to fit.

Comments please!

----

That's cool but applications that do that can be annoying when you have other windows that you don't want covered (for an example see Apple's iCal - annoys the hell out of me - 3 different sizes depending on day|week|month view? Growl!). It goes against style guidelines. Users should have the power to fix the size and location of the windows. If you have behaviour like this, perhaps consider making it optional using preferences. --   [[MikeAmy]]

----

If you notice with iCal, you can set the size of the 3 different views and they'll each remember their respective sizes. If you want them all to be the same, set them the same. A possible preference for iCal would be "Retain separate window sizes per calendar view" or the like.  --Arbini