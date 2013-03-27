Short Answer:

    
- (General/NSSize)windowWillResize:(General/NSWindow *)sender toSize:(General/NSSize)frameSize
{
    General/NSSize currentSize = [self.window frame].size;
    General/NSSize scaledSize = frameSize;
    General/CGFloat scaleFactor = ( currentSize.width > currentSize.height )
    	? (frameSize.width/currentSize.width)
        : (frameSize.height/currentSize.height); // tall
    scaledSize.width = (currentSize.width * scaleFactor);
    scaledSize.height = (currentSize.height * scaleFactor);
//    General/NSLog(@"windowWillResize:%p %f%% from: %@ to: %@", self.window, scaleFactor, General/NSStringFromSize(frameSize), General/NSStringFromSize(scaledSize));
    return scaledSize;
}



----

While implementing (or should I say attempting to implement) a window that can only be resized in a 1:1 aspect, I added the following code:

    
    General/NSWindow *mainWindow = General/self window] autorelease];
    [mainWindow setAspectRatio:[[NSMakeSize(1.0, 1.0)];


This code is the first two lines of the drawRect method of the only thing in the window, an General/NSView subclass. Needless to say it doesn't work quite right. The first time -- and only the first time -- that I go to manually resize the window, I can for a fraction of a second resize the window to a non 1:1 size, then it seems to 'snap' and then work properly for the rest of that and all subsequent resizes. It works, but that snapping is obnoxious and being as I have seen many apps that do this properly, I'm sure I have a mistake.

So, the questions are:

* Is there a correct way or location for this code so that it works properly?
* Since I'm asking questions, should the autorelease to be there, considering the app compiles and runs just fine without it?


General/NedO

----

Look at General/NSWindow's     - (General/NSSize)windowWillResize:(General/NSWindow *)sender toSize:(General/NSSize)proposedFrameSize delegate message.

http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Classes/General/NSWindow.html#//apple_ref/doc/uid/20000013/BCICGJBG

You didn't alloc, copy or retain this object, so no, you don't need the autorelease.

----

Thanks for the help.

I added a Delegate for the window, subclassed from General/NSObject. I instantiated it and connected it in IB. Here's the code I have in it right now:

    
- (id)init
{
    General/NSNotificationCenter *center = General/[NSNotificationCenter defaultCenter];
    [center addObserver:self
               selector:@selector(windowWillResize:toSize:)
                   name:nil
                 object:nil];
    return self;
}

- (General/NSSize)windowWillResize:(General/NSWindow *)sender toSize:(General/NSSize)proposedFrameSize
{
    General/NSLog(@"resize");
    // Commenting out the next line makes no difference, there's an error either way.
    // [sender setAspectRatio:General/NSMakeSize(1.0, 1.0)];

    return proposedFrameSize;
}


The app compiles, logs the "resize message" and promptly dies with signal 10 (SIGBUS). I'll look at it some more tomorrow and see what can be seen. I did try the delegate unsuccessfully with the relevant named notifications -- General/NSWindowDidBecomeKeyNotification, General/NSWindowDidBecomeMainNotification, General/NSWindowDidBecomeKeyNotification and General/NSWindowDidResizeNotification. Those didn't die as the above code did (each was coded slightly differently), but none of them worked.

I suppose I could create the window programatically or even subclass General/NSWindow, but those sure seem like rather byzantine approaches.

General/NedO

----
As a last try for the night, I commented out all of the delegate code and subclassed General/NSWindow. I overrode the default initialization method with:

    
-(id)initWithContentRect:(General/NSRect)contentRect styleMask:(unsigned int)styleMask backing:(General/NSBackingStoreType)backingType defer:(BOOL)flag
{
    if (self = [super initWithContentRect:contentRect styleMask:styleMask backing:backingType defer:flag])
    {
        [self setAspectRatio:General/NSMakeSize(1.0, 1.0)];
    }
    return self;
}

No love there, it runs but with the same problem as in the original. Hmmm......

General/NedO
----
I think you missed the point of the delegate method.

The delegate method allows you to constrain the window's size arbitrarily during a resize operation. You can constrain it to a certain aspect ratio, or make sure that the y size is always the square of the x size, or anything else. The idea was not to call     -setAspectRatio: from there, as that pretty much makes no sense.

----
No, I understand that when using a delegate for the windowWillResize:sender toSize:, I need to use code that transforms the proposed size to the correct aspect. I just simply didn't get that far last night because of the the runtime error I was getting. Since it was late, I thought I'd try a subclass really quick before calling it a night. As the subclass didn't work as hoped, this morning I'm back to the delegate to a) figure out why I was getting an error and b) then add in some aspect control code.

General/NedO

----
I think the goal of the delegate method is to return an General/NSSize object that represents your desired size for the window. So, instead of trying to set the windows size in the method, simply return an General/NSSize object that is the proper aspect ratio. The window will constrain itself to that size automatically. Hope that helps.

-Doug
----
I deleted the addObserver code to remove the error. Then I tried two different versions of windowWillResize:toSize:. Neither worked.

**The addObserver code was your problem in the first place. All General/NSNotification methods must be of the form     -(void)function:(General/NSNotification *)note. The problem with your code was that General/NSNotificationCenter was trying to send an General/NSNotification to windowWillResize:toSize:, instead of the General/NSWindow and an General/NSSize. When you register as the window's delegate, you are automatically set up to respond to all of the delegate methods, if you implement them. Notifications are separate from delegate methods -- although you are registered for those as well, such as windowDidBecomeKey:. --General/JediKnil**

In the first, I merely set the height of General/NSSize, proposedFrameSize, to equal the width. Real simple, one line:
    
- (General/NSSize)windowWillResize:(General/NSWindow *)sender toSize:(General/NSSize)proposedFrameSize
{
        proposedFrameSize.width = proposedFrameSize.height;
}

This merely had the 'snap' going outwards instead of inwards. Reversing the assignment made no difference.

Then I tried setting the new size to a 1:1 aspect using the minimum dimension (and after that, the maximum) of the two proposed dimensions:
    
- (General/NSSize)windowWillResize:(General/NSWindow *)sender toSize:(General/NSSize)proposedFrameSize
{
    // this choses the minimum, > choses the maximum
    if (proposedFrameSize.width < proposedFrameSize.height) {
        proposedFrameSize.width = proposedFrameSize.height;
    } else {
        proposedFrameSize.height = proposedFrameSize.width;
    }
            
    return proposedFrameSize;
}

This doesn't work either. The window still 'snaps' slightly in some direction (in or out depending on the resize code) the first time it is manually resized. If the window has been manually resized or maximized, the snapping never occurs again. There has to be some way to stop this rather trivial visual irritation...doesn't there?

General/NedO

----

How about just setting the window's size to its current size somewhere early in your code? Not at a Mac right now so I can't test this.

----
That works. I'm in a doc-based app right now, so I just used something like:
    
- (void)windowControllerDidLoadNib:(General/NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];

    General/NSWindow *newWindow;
    newWindow = [aController window];
    [newWindow setAspectRatio:General/NSMakeSize(1.0, 1.0)];
    [newWindow setFrame:General/NSMakeRect(0, 0, 500, 500) display:YES];
}

This works perfectly for me, with no more 'snapping' with any resize. Thanks for all the help.

General/NedO

*You should probably be nice to your users and take the initial size from their preferences. You'd only have to store one component (height or width) and restore both components to that size during didLoadNib ... *

Or just save the window's size with     setFrameAutosaveName: and do something like
    
General/NSWindow *newWindow = [aController window];
General/NSRect sameFrame = [newWindow frame];
[newWindow setFrame:sameFrame display:YES];


----
I'll use prefs to set the size. I was mainly using the numbers as a test to see if it worked before I went to the touble to set up the prefs and such.

BTW, the setFrameAutosaveName:, and subsequent block of code does not eliminate the snapping visual defect.  Using that code, it's still there on the first resize. It is slightly different, as I am now something of an old hand at watching my window snap around. It appears to snap in from right to left, with little or no bottom to top snapping. Perhaps noticing that is a sign I have spent too much time staring at the screen today. :)

General/NedO

*edit collision - i forgot the display part of the window setFrame message. maybe that's why it didn't work.*