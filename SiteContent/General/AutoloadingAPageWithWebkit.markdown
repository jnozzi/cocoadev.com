I followed the following instructions to get an app to load a page automatically.

To write a Cocoa program to display a web page (in this example, it is http://www.apple.com, but it could be anything.)
1.) In General/XCode: Make a new Cocoa Project

2.) In Finder: Open the folder /System/Library/Frameworks and drag the General/WebKit.framework into the Frameworks folder icon of your Xcode project window.

3.) In General/XCode: Double-click on General/MainMenu.nib to launch it in Interface builder.

4.) in Interface Builder: In the Classes tab of General/MainMenu.nib right click on General/NSObject. Subclass it to make the class General/AppDelegate

5.) Right Click on General/AppDelegate to add an outlet named: webView of type General/WebView to General/AppDelegate.

6.) Right Click on General/AppDelegate to instantiate the class.

7.) Right Click on General/AppDelegate to create files.

8.) in Interface Builder: In the Instances tab of General/MainMenu.nib, * Double click on "Window" to open it.
* Drag a General/WebView object from "Graphic Views" tab of the Cocoa Palettes window to "Window". resize it to fill the window. In Inspector's Size tab, set the size of the Web view to the full size of the window, and turn on the inner springs both horizontal and vertical.

9.) next, Control-Drag from General/AppDelegate to the webView, and connect it as the webView outlet of the General/AppDelegate.

10.) in Interface Builder: In the Instances tab of General/MainMenu.nib, Control-Drag from File's Owner to General/AppDelegate, to set it as the delegate.
With practice, you'll be able to do the above 10 steps faster than you can read them.

Now we're ready to write some code. Add one line to General/AppDelegate.h to make it look like this:
    /* General/AppDelegate */
#import <Cocoa/Cocoa.h>
@class General/WebView; // <-- add this line.
@interface General/AppDelegate : General/NSObject {
General/IBOutlet General/WebView *webView_;
}
@end

and make General/AppDelegate.m look like this:
    
#import "General/AppDelegate.h"

#import <General/WebKit/General/WebView.h>
#import <General/WebKit/General/WebFrame.h>

@implementation General/AppDelegate
- (void)awakeFromNib {
General/WebFrame *mainFrame = [webView_ mainFrame];
NSURL *url = [NSURL General/URLWithString:@"http://www.apple.com"]; 
General/NSURLRequest *request = General/[NSURLRequest requestWithURL:url]; 
[mainFrame loadRequest:request];
}

@end


That's all. You are done. You can run it, and it will fetch the web page from the web and display it in the view.
  (FROM MIKE ASH @ http://macerudite.com/mac-xcode-app-to-display-a-webpage-38416.html)

However when I run the program it fails to show the webpage and the following error is displayed in the RUN LOG:

    
[Session started at 2007-01-02 15:02:29 -0600.]
2007-01-02 15:02:29.659 Net[2999] General/CFLog (0): General/CFMessagePort: bootstrap_register(): failed 1103 (0x44f), port = 0x3303, name = 'com.yourcompany.Net.General/ServiceProvider'
See /usr/include/servers/bootstrap_defs.h for the error codes.
2007-01-02 15:02:29.660 Net[2999] General/CFLog (99): General/CFMessagePortCreateLocal(): failed to name Mach port (com.yourcompany.Net.General/ServiceProvider)
a



I don't see any relevant bootstrap definitions other than 1103 which is service active... any ideas?

Altering the Info.plist file in the "Resources" section so that the element associated with the General/CFBundleIdentifier key reads something other that "com.yourcompany...", like for e.g, "uk.co.netsoft.Net.General/ServiceProvider" should work.

For more details, check out the Apple PDF:
http://developer.apple.com/documentation/Cocoa/Conceptual/General/ObjCTutorial/General/ObjCTutorial.pdf
in the 'Configuring Currency Converter : Essential Application Identification Properties' section.