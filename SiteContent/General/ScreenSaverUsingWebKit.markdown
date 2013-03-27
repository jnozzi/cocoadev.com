

Hey, this might be beyond my current ability in Cocoa, but I found myself wondering if the General/WebView from General/WebKit could be loaded in such a way as to use it with the screen saver module template in General/XCode.  I see that the template doesn't include a nib (understandable) but thus far I haven't yet learned how to load a view programatically.  Is General/WebView even able to do what I'm thinking (just load & display a full screen page from a URL as a screen saver)?

General/CliffPruitt

----

Remember, a nib is just creating objects the same way that you create them, and then saving them for later. You should be able to do this by simply alloc/initing a General/WebView, inserting it into your screensaver view, and then telling it to go to a URL.

----

And, although the template doesn't have a nib, there's nothing stopping you from adding one.

----

Hmmm.... I wouldn't even know where to begin with adding a nib to a template that didn't have one.  Its a slow learning process for me.  Maybe I'll tackle that one a little later after I have a better handle on things...

Thanks for the insight though.  I never thought of being able to add a nib to a template that didn't have one.  I guess I figured if it didn't have one included that nibs couldn't be used in that type of app.

- General/CliffPruitt

*you don't have to add the nib to the template, just add it to the project. create the nib in IB, save it in your project directory, then add it in General/XCode - Project menu > Add To Project. Although you don't need to do that in this case.*

----

    
// our header
#import <General/ScreenSaver/General/ScreenSaver.h>
#import <General/WebKit/General/WebKit.h>

@interface General/WebSaverView : General/ScreenSaverView  {
    General/WebView *webview;
}
@end


// the .m file:
#import "General/WebSaverView.h"

@implementation General/WebSaverView

- (id)initWithFrame:(General/NSRect)frame isPreview:(BOOL)isPreview {
    self = [super initWithFrame:frame isPreview:isPreview];
    if (self) {
        webview = General/[[WebView alloc] initWithFrame:frame];
        [self addSubview:webview];
        
        General/webview mainFrame] loadRequest:[[[NSURLRequest requestWithURL:[NSURL General/URLWithString:@"http://www.apple.com"]]];

        
        //[self setAnimationTimeInterval:1/30.0];
    }
    return self;
}

... etc..

@end

- General/GusMueller