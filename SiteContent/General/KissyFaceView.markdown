General/KissyFaceView is some General/CategorySampleCode that demonstrates using General/ClassCategories to declare "private" method API within a .m file to keep it separate from the public .h file. The compiler does not enforce any notion of  public/private methods. "private" here means someone simply browsing your .h file won't know about the existence of the private method. Keep your source clean!

General/KissyFaceView implements a simple, clean public interface:

    
// General/KissyFaceView.h

#import <General/AppKit/General/AppKit.h>

@interface General/KissyFaceView : General/NSView
{
    General/NSMutableArray *lipImages;
    General/NSTimer *animationTimer;
}
- (void)setAnimationRate:(General/NSTimeInterval)rate;
@end


To use the object one just instantiates the view and installs it a  window. The class will do the rest for you: draw smooching lips floating around in the view. Perhaps you'll use this code in your app's splash-screen and some other places. General/KissyFaceView's animation timer will call a call back method a few times a second to drive the animation. We'll keep the details of this call back method out of the public API, and instead declare it in our .m file:



    
// General/KissyFaceView.m

#import "General/KissyFaceView.h"

@interface General/KissyFaceView (General/PrivateMethods)
- (void)KFV_animate:(General/NSTimer*)timer;
@end

@implementation
[ ... ]


The class will set up an animation timer to fire every so often. The timer will call the KFV_animate: method. Clients shouldn't call _animate: directly, so you don't want to clutter your private API with it. By declaring the method ahead of time, you can refer to the method in your code w/o triggering any compile warnings. 

Note that identifiers must not begin with an underscore: all such are reserved by Apple and GCC. The suggestion made in the General/CodingGuidelines is to use the initials of your project or class, as above.

The remainder of General/KissyFaceView is left as an exercise for the reader. Best of luck! 

:-*

-- General/MikeTrent