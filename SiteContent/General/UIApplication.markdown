

Part of the iPhone [[UIKit]] framework.

iPhone applications must (?) have a [[UIApplication]] subclass, which is specified in the UIA<nowiki/>pplicationMain() call.

<code>
int main(int argc, char '''argv)
{
    [[NSAutoreleasePool]] ''pool = [[[[NSAutoreleasePool]] alloc] init];
    return [[UIApplicationMain]](argc, argv, [[[SampleApp]] class]);
}
</code>

These callbacks do exactly what they say they do. That's why we love Cocoa.

%%BEGINCODESTYLE%%- (void)applicationDidFinishLaunching:(id)unused;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)applicationWillTerminate;%%ENDCODESTYLE%%
is to end the application.

No idea what the argument is for..

%%BEGINCODESTYLE%%- (void)applicationWillSuspend;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)deviceOrientationChanged:([[GSEvent]]'')event;%%ENDCODESTYLE%%

Wouldn't this be called when the iPhone is rotated to the horizontal or vertical position? Then call + (int)deviceOrientation:(BOOL)flag; from [[UIHardware]] to get the current position and update your app's display accordingly?

%%BEGINCODESTYLE%%- (void)applicationResume:([[GSEvent]]'')event;%%ENDCODESTYLE%%

Called when the user selects the icon for a suspended application (also when a call ends?).

%%BEGINCODESTYLE%%- (void)applicationSuspend:([[GSEvent]]'')event;%%ENDCODESTYLE%%

Called when the phone switches back to the Springboard in response to the menu button (also when it switches to a call?). The app can call [self terminate] here if it doesn't need to keep running.

// ???

%%BEGINCODESTYLE%%- (void)menuButtonUp:([[GSEvent]]'')event;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)menuButtonDown:([[GSEvent]]'')event;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (BOOL)launchApplicationWithIdentifier:([[NSString]]'')identifier suspended:(BOOL)flag;%%ENDCODESTYLE%%

Launches the specified application.

%%BEGINCODESTYLE%%- (void)openURL:(NSURL'')url;%%ENDCODESTYLE%%

openURL can be used to open a browser, or to make a call:

<code>
[self openURL: [[NSURL alloc] initWithString: @"http://google.com"]]
[self openURL: [[NSURL alloc] initWithString: @"tel://650-555-1234"]]
</code>

%%BEGINCODESTYLE%%- (void)openURL:(NSURL'')url asPanel:(BOOL)flag;%%ENDCODESTYLE%%

----

[[UIApplicationMain]]() expects an [[NSString]] (or nil, if using [[UIApplication]]), not a class for its third argument. Also, the thing about how iOS apps ''must'' have a [[UIApplication]] subclass is wrong - [[UIApplicationDelegate]] is there to minimize the need for subclassing. Like a lot of classes in Cocoa and Cocoa Touch, just use it as-is. Finally, [[UIApplicationMain]]() is missing its fourth argument, an [[NSString]] describing the delegate class name (or nil if specified elsewhere). --lowell