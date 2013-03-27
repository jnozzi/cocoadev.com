Here's the implementation for a screen saver that blanks the screen and does no animation. It's kind of goofy now that we have energy saver, but some people insist on minimalism ... 

In General/BlackView.h:
    
#import <General/ScreenSaver/General/ScreenSaver.h>

@interface General/BlackView : General/ScreenSaverView
{
}
@end


In General/BlackView.m:
    
#import "General/BlackView.h"

@implementation General/BlackView

- (id)initWithFrame:(General/NSRect)frame isPreview:(BOOL)isPreview
{
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        [self setAnimationTimeInterval:-1];
    }
    return self;
}

@end


Note that we aren't doing any graphics ourselves. The General/ScreenSaverView base class will draw black. The only thing we're doing is disabling the animation timers by setting the animation time to -1.