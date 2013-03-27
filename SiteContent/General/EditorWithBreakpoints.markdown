

Hi,

I am wanting to create an editor that is capable of displaying breakpoints.  It seems that General/NSRulerView and General/NSRulerMarker would work splendidly for this except for the fact that I can't hide the measurement tick marks (unless I am missing something).  Should I create a new subclass of General/NSView to handle this or am I making this more complicated than it needs to be?

Many Thanks!
General/LauRence

----

try this:

    

// General/MyTextView.h

#import <General/AppKit/General/AppKit.h>

@interface General/MyTextView : General/NSScrollView {
}
@end

@interface General/MyRulerView : General/NSRulerView {
}
@end

// General/MyTextView.m

#import "General/UmTextView.h"

@implementation General/MyTextView

- (id)initWithFrame:(General/NSRect)frame {
    id textView, rulerView;
    self = [super initWithFrame:frame];
    if (self) {
        rulerView = General/[[[MyRulerView alloc ] init ] autorelease ];
        textView = General/[[[NSTextView alloc ] initWithFrame: frame ] autorelease ];
        [self setDocumentView:textView ];
        [self setRulersVisible:YES ];
        [self setHasHorizontalRuler:YES ];
        [self setBorderType:General/NSGrooveBorder ];
        [self setHorizontalRulerView:rulerView ];
        [self setDrawsBackground:YES ];
    }
    return self;
}
@end

@implementation General/MyRulerView 
-(void)drawHashMarksAndLabelsInRect:(General/NSRect)rect {
// the only purpose here is to override this method and do nothing
}
@end




Hope you don't get confused when I call an General/NSScrollView General/MyTextView (this is what IB does, so I got into the habit of doing it). Interface Builder's Text View is actually a scroll view with an General/NSTextView as the document view. 

Not sure how far along you are with your program, so here's a couple of ways you can use this custom object.

1. If you already have a scroll view with a ruler view, just replace the ruler view with General/MyRulerView. 

2. If you want to use General/MyTextView as a custom view in IB do the following:
 *drag the object file (General/MyTextView.h) from PB to the General/MainMenu.nib in IB
 *drag and drop a Custom View object into a window.
 *select the Custom View by clicking on it
 *hit Command-1 to bring the info window to the front
 *select Custom Class from the drop down menu in the info window.
 *select General/MyTextView
    
now make the needed connections and add the General/IBOutlet to your controller object

-- zootbobbalu