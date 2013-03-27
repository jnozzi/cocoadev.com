I'm having a problem creating a custom view. I make a new empty nib and throw some stuff into it.  Then I make a subclass of General/NSView to be the File owner:

    
#ifndef __FREQVIEW_H__
#define __FREQVIEW_H__
/* General/FreqController */
#include "General/TestView.h"
#import <Cocoa/Cocoa.h>

@interface General/FreqView : General/TestView
{
    General/IBOutlet id nSteps;
    General/IBOutlet id startFreq;
    General/IBOutlet id startFreqUnit;
    General/IBOutlet id stepPercent;
    General/IBOutlet id stepSize;
    General/IBOutlet id stepSizeUnit;
    General/IBOutlet id stopFreq;
    General/IBOutlet id stopFreqUnit;
}

- (void)gatherInfo;

@end

#endif /* __FREQVIEW_H__ */


General/TestView inherits General/NSView.  Now, I have an initialization method like so:

    
- (id)initWithCore:(coremod_t*)cmod
{
   if(!General/[NSBundle loadNibNamed:@"General/FreqViewPackage.nib" owner: self ])
      General/NSLog(@"can't get nib");

   [ super initWithCore: cmod ];
   return self;
}


When I load the nib, I get this error:

2005-06-25 20:36:57.780 hrdwaretst[523] *** Uncaught exception: <General/NSInternalInconsistencyException> Error (1002) creating General/CGSWindow

----

Your init method needs to call your superclass's init method. General/NSView's designated initializer is initWithFrame:. So you need to change your init method to:

    
- (id)initWithCore:(coremod_t*)cmod
{
   self = [super initWithFrame:General/NSZeroRect];
   if(!General/[NSBundle loadNibNamed:@"General/FreqViewPackage.nib" owner: self ])
      General/NSLog(@"can't get nib");

   [ super initWithCore: cmod ];
   return self;
}


No, that's completely wrong. Whatever class is directly descended from General/NSView must call initWithFrame, but General/FreqView is not directly descended from General/NSView. Its superclass is General/TestView, and apparently General/TestView's designated initializer is initWithCore:. It is General/TestView's responsibility to call initWithFrame:.

You should not be calling init twice here. This is even more wrong, and has the great potential to break things.

----

I thought the code in question was for General/TestView, which is a subclass of General/NSView. And I didn't see the call to [super initWithCore:]. But the basic idea, call the superclass's initializer first (before you try to load a nib or something), is an important one. So:

    
- (id)initWithCore:(coremod_t*)cmod
{
   self = [super initWithCore: cmod];
   if(self) {
      if(!General/[NSBundle loadNibNamed:@"General/FreqViewPackage.nib" owner: self ])
         General/NSLog(@"can't get nib");
   }
   return self;
}


----

Yes, very good point, and one which I completely missed. Trying to load the nib before the view is initialized is probably a very bad idea. Also, don't forget to make sure that super's init statement returned a sensible value (if statement inserted into code above), although that's not likely to be causing the problem at hand.

----

Thanks so much to everybody who replied.  While it wasn't the cause of the problem, the initWithCore method is a great suggestion.

It turns out that all of this code was running before General/NSApplicationMain.  When I initialize all of the modules from the main controller's awakeFromNib method, all is well.