Cocoa provides only almost static tooltips. When you want to implement something like Keynote tooltips in a canvas while editing, in mouseDown events, you are out of luck. To remedy that, I created a small class to do it. It tries to imitate as much as possible the Keynote look and feels. -- [[EricForget]]

See also [[LittleYellowBox]].

----

I don't have Keynote. How are Keynote tooltips different from the standard ones?

----

Normal tooltips are for views, but mostly for controls. When the user move the cursor over it, wait a few seconds the tooltip appears for 10 seconds and then disappear. Keynote tooltips looks the same but are there for displaying the position of the moving object, the dimension of the resizing object or the angle for the rotation. Those tooltips appear only during mouseDown:/mouseDragged events. -- [[EricForget]]

<code>

----'''[[ToolTipTextField]] Interface'''

@interface [[ToolTipTextField]] : [[NSTextField]]
@end

----'''[[ToolTipTextField]] Implementation'''

@implementation [[ToolTipTextField]]

- (void) drawRect:([[NSRect]])aRect
{
    [super drawRect:aRect];
    
    [[[[NSColor]] colorWithCalibratedWhite:0.925 alpha:1.0] set];
    [[NSFrameRect]](aRect);
}

@end

----'''[[ToolTip]] Interface'''

@interface [[ToolTip]] : [[NSObject]]
{
    [[NSWindow]]                ''window;
    [[NSTextField]]             ''textField;
    [[NSDictionary]]            ''textAttributes;
}

+ (void) setString:([[NSString]] '')string forEvent:([[NSEvent]] '')theEvent;
+ (void) release;

@end

----'''[[ToolTip]] Implementation'''

static [[ToolTip]]	''sharedToolTip = nil;

@interface [[ToolTip]] (Private)

- (void) setString:([[NSString]] '')string forEvent:([[NSEvent]] '')theEvent;

@end

+ (void) setString:([[NSString]] '')string forEvent:([[NSEvent]] '')theEvent
{
    if (sharedToolTip == nil) {
        
        sharedToolTip = [[[[ToolTip]] alloc] init];
    }
    
    [sharedToolTip setString:string forEvent:theEvent];
}

+ (void) release
{
    [sharedToolTip release];
    sharedToolTip = nil;
}

- (id) init
{
    id        retVal = [super init];
    
    if (retVal != nil) {
        
        // These size are not really import, just the relation between the two...
        [[NSRect]]        contentRect       = { { 100, 100 }, { 100, 20 } };
        [[NSRect]]        textFieldFrame    = { { 0, 0 }, { 100, 20 } };
        
        window = [[[[NSWindow]] alloc]
                    initWithContentRect:    contentRect
                              styleMask:    [[NSBorderlessWindowMask]]
                                backing:    [[NSBackingStoreBuffered]]
                                  defer:    YES];
        
        [window setOpaque:NO];
        [window setAlphaValue:0.80];
        [window setBackgroundColor:[[[NSColor]] colorWithDeviceRed:1.0 green:0.96 blue:0.76 alpha:1.0]];
        [window setHasShadow:YES];
        [window setLevel:[[NSStatusWindowLevel]]];
        [window setReleasedWhenClosed:YES];
        [window orderFront:nil];
        
        textField = [[[[ToolTipTextField]] alloc] initWithFrame:textFieldFrame];
        [textField setEditable:NO];
        [textField setSelectable:NO];
        [textField setBezeled:NO];
        [textField setBordered:NO];
        [textField setDrawsBackground:NO];
        [textField setAlignment:[[NSCenterTextAlignment]]];
        [textField setAutoresizingMask:[[NSViewWidthSizable]] | [[NSViewHeightSizable]]];
        [textField setFont:[[[NSFont]] toolTipsFontOfSize:[[[NSFont]] systemFontSize]]];
        [[window contentView] addSubview:textField];
        
        [textField setStringValue:@" "]; // Just having at least 1 char to allow the next message...
        textAttributes = [[[textField attributedStringValue] attributesAtIndex:0 effectiveRange:nil] retain];
    }
    
    return retVal;
}

- (void) dealloc
{
    [window release];
    [textAttributes release];
    [super dealloc];
}

- (void) setString:([[NSString]] '')string forEvent:([[NSEvent]] '')theEvent
{
    [[NSSize]]        size                    = [string sizeWithAttributes:textAttributes];
    [[NSPoint]]       cursorScreenPosition    = [[theEvent window] convertBaseToScreen:[theEvent locationInWindow]];
    
    [textField setStringValue:string];
    [window setFrameTopLeftPoint:[[NSMakePoint]](cursorScreenPosition.x + 10, cursorScreenPosition.y + 28)];
    
    [window setContentSize:[[NSMakeSize]](size.width + 20, size.height + 1)];
}

----'''[[ToolTip]] Usage Sample'''

- (void) mouseDown:([[NSEvent]] '')theEvent
{
    [[NSPoint]]        where = [self convertPoint:[theEvent locationInWindow] fromView:nil];
    [[NSPoint]]        objectOrigin;
    
    // objectClicked is a object variable
    objectClicked    = [self objectClicked:where];
    
    // Do your mouseDown: job...
    
    
    // Setup Tooltip
    objectOrigin = [objectClicked bounds].origin;
    
    [[[ToolTip]]
            setString:  [[[NSString]] stringWithFormat:@"x: %.2f  y: %.2f", objectOrigin.x, objectOrigin.y]
             forEvent:  theEvent];
}

- (void) mouseDragged:([[NSEvent]] '')theEvent
{
    [[NSPoint]]        objectOrigin;
    
    // Do your mouseDragged: job...
    
    
    // Update Tooltip
    objectOrigin = [objectClicked bounds].origin;
    
    [[[ToolTip]]
            setString:  [[[NSString]] stringWithFormat:@"x: %.2f  y: %.2f", objectOrigin.x, objectOrigin.y]
             forEvent:  theEvent];
    
    return retVal;
}

- (void) mouseUp:([[NSEvent]] '')theEvent
{
    // Do your mouseUp: job...
    
    // Release Tooltip
    [[[ToolTip]] release];
}

</code>

-- [[EricForget]]

----

----

How 'bout something like this?...

<code>

#import <[[AppKit]]/[[AppKit]].h>

@interface [[TooltipWindow]] : [[NSWindow]]
{
    [[NSTimer]] ''closeTimer;
    id tooltipObject;
}
+ (id)tipWithString:([[NSString]] '')tip frame:([[NSRect]])frame display:(BOOL)display;
+ (id)tipWithAttributedString:([[NSAttributedString]] '')tip frame:([[NSRect]])frame display:(BOOL)display;

// returns the approximate window size needed to display the tooltip string.
+ ([[NSSize]])suggestedSizeForTooltip:(id)tooltip;

// setting and getting the default duration..
+ (void)setDefaultDuration:([[NSTimeInterval]])inSeconds;
+ ([[NSTimeInterval]])defaultDuration;

// setting and getting the default bgColor
+ (void)setDefaultBackgroundColor:([[NSColor]] '')bgColor;
+ ([[NSColor]] '')defaultBackgroundColor;

- (id)init;

- (id)tooltip;
- (void)setTooltip:(id)tip;

- (void)orderFrontWithDuration:([[NSTimeInterval]])seconds;

@end

</code>
<code>
#import "[[TooltipWindow]].h"

float defaultDuration;
BOOL doneInitialSetup;
[[NSDictionary]] ''textAttributes;
[[NSColor]] ''backgroundColor;

@implementation [[TooltipWindow]]

+ (void)setDefaultBackgroundColor:([[NSColor]] '')bgColor
{
          [backgroundColor release];
    backgroundColor = [bgColor retain];
}
+ ([[NSColor]] '')defaultBackgroundColor
{
    if (!backgroundColor)
        [[[TooltipWindow]] setDefaultBackgroundColor: [[[NSColor]] colorWithDeviceRed:1.0 green:0.96 blue:0.76 alpha:1.0]];

    return backgroundColor;
}

+ (void)setDefaultDuration:([[NSTimeInterval]])inSeconds
{
    doneInitialSetup = YES;
    defaultDuration = inSeconds;
}

+ ([[NSTimeInterval]])defaultDuration
{
    return defaultDuration;
}

+ (id)tipWithString:([[NSString]] '')tip frame:([[NSRect]])frame display:(BOOL)display
{
    return [[[TooltipWindow]] tipWithAttributedString:[[[[[NSAttributedString]] alloc] initWithString:tip] autorelease] frame:frame display:display];
}

+ (id)tipWithAttributedString:([[NSAttributedString]] '')tip frame:([[NSRect]])frame display:(BOOL)display
{
    [[TooltipWindow]] ''window = [[[[TooltipWindow]] alloc] init]; // blank slate
            
    // if the defaultDuration hasn't been set we set it to a default of 5 seconds
    // we like to cache the text attributes used for plain string drawing..
    if (!doneInitialSetup) {
            [[[TooltipWindow]] setDefaultDuration:5];
            [window setTooltip:@" "]; // Just having at least 1 char to allow the next message...
            textAttributes = [[[[window contentView] attributedStringValue] attributesAtIndex:0 effectiveRange:nil] retain];
    }
    
            [window setTooltip:tip]; // set the tip
            [window setReleasedWhenClosed:display]; // if we display right away we release on close
            [window setFrame:frame display:YES];

        if (display) {
            [window orderFrontWithDuration:[[[TooltipWindow]] defaultDuration]]; // this is affectively autoreleasing the window after 'defaultDuration'
            return window;
       } else // it's not set to auto-magically go away so make the caller responsible..
            return [window autorelease];

    return nil; // should never get here
}

+ ([[NSSize]])suggestedSizeForTooltip:(id)tooltip
{
    [[NSSize]] tipSize = [[NSZeroSize]];

    if ([tooltip isKindOfClass:[[[NSAttributedString]] class]]) tipSize = [tooltip size];
    else
    if ([tooltip isKindOfClass:[[[NSString]] class]]) tipSize = [tooltip sizeWithAttributes:textAttributes];
    else
        return tipSize; // we don't know how to get the size of 'tooltip'

        if (![[NSEqualSizes]](tipSize, [[NSZeroSize]]))
            tipSize.width += 4;

return tipSize;

}


- (id)init
{
    self = [super initWithContentRect:[[NSMakeRect]](0,0,0,0)
                              styleMask:[[NSBorderlessWindowMask]]
                                backing:[[NSBackingStoreBuffered]]
                                  defer:NO];
     { // window setup...
        [self setAlphaValue:0.90];
        [self setOpaque:NO];
        [self setBackgroundColor:[[[TooltipWindow]] defaultBackgroundColor]];
        [self setHasShadow:YES];
        [self setLevel:[[NSStatusWindowLevel]]];
        [self setHidesOnDeactivate:YES];
        [self setIgnoresMouseEvents:YES];
     }

     { // textfield setup...
        [[NSTextField]] ''field = [[[[NSTextField]] alloc] initWithFrame:[[NSMakeRect]](0,0,0,0)];

            [field setEditable:NO];
            [field setSelectable:NO];
            [field setBezeled:NO];
            [field setBordered:NO];
            [field setDrawsBackground:NO];
            [field setAutoresizingMask:[[NSViewWidthSizable]] | [[NSViewHeightSizable]]];
            [self setContentView:field];
            [self setFrame:[self frameRectForContentRect:[field frame]] display:NO];
            
                if (!doneInitialSetup) {
                    [[[TooltipWindow]] setDefaultDuration:5];
                    [field setStringValue:@" "]; // Just having at least 1 char to allow the next message...
                    textAttributes = [[[field attributedStringValue] attributesAtIndex:0 effectiveRange:nil] retain];
                }
            
            [field release];
        }

    return self;
}


- (void)dealloc
{
        if (closeTimer) {
            [closeTimer invalidate];
            [closeTimer release];
        }
    [tooltipObject release];
    [super dealloc];
}

- (id)tooltip { return tooltipObject; }

- (void)setTooltip:(id)tip
{
    id contentView = [self contentView];
    
    [tooltipObject release];
    tooltipObject = [tip retain];
    
    if ([contentView isKindOfClass:[[[NSTextField]] class]]) {
        if ([tip isKindOfClass:[[[NSString]] class]]) [contentView setStringValue:tip];
        else
        if ([tip isKindOfClass:[[[NSAttributedString]] class]]) [contentView setAttributedStringValue:tip];
    }
}

- (void)orderFrontWithDuration:([[NSTimeInterval]])seconds
{
    [super orderFront:nil];
    
    if (closeTimer) { [closeTimer invalidate]; [closeTimer release]; }
    closeTimer = [[[[NSTimer]] scheduledTimerWithTimeInterval:seconds target:self selector:@selector(close) userInfo:nil repeats:NO] retain];
}


- ([[NSString]] '')description
{
    return [[[NSString]] stringWithFormat:@"[[TooltipWindow]]:\n%@", [[self contentView] stringValue]];
}


@end
</code>

I stuck a demo project that uses that there [[TooltipWindow]] class here: http://homepage.mac.com/ryanstevens/.Public/[[TooltipWindowDemo]].zip

Maybe someone will find it useful. :)

----

What are the differences between your implementation and the one from Cocoa, outside that you have to do everything by hand? What is the intent of your implementation, which doesn't seems to serves the same needs as the one I provided? --[[EricForget]]

----
I think my implementation serves the same needs, just in a different way.

I really just wanted more control over the window itself, that and attributed tooltips.

----
I tried out Ryan's version and it works beautifully. Thanks! --Daniel

----
It's been ages since I've looked back at this...wow. I guess the demo link was broken (or was never right in the first place) - that should be fixed now.

Just glad I could contribute back. --[[RyanStevens]]

----
Thanks for showing me how to create handy little windows; I've wondered how to do this for quite some time, and I'm sure the knowledge will be dangerous in my hands :)

I used Eric's implementation because it was less reading for me to understand.  I like the way that Eric uses class methods to communicate with his singleton, instead of the way Apple does it with stuff like their -sharedDocumentController.  Alot of brain-power and screen real estate is wasted when Apple makes us do:
<code>
    [[[[NSGobbleDeeGookManager]] sharedGobbleDeeGookManager] canYouPleaseDoSomething] ;
</code>

You can also attach these tool tips to dragged rows of [[NSTableView]] or [[NSOutlineView]].  To do that, referring to Eric's "Tool Tip Usage Sample" above, move his code

*from Eric's mouseDown: to your draggingEntered:
*from Eric's mouseDragged: to your draggingUpdated:
*from Eric's mouseUp: to your draggingExited:, draggingEnded: and acceptDrop:::

The last one goes to three places because there are several ways that a dragging session can end.

 -- Jerry Krinock   2007 Oct 08