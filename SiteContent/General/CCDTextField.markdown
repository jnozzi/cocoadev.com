General/CCDTextField is similar to General/NSSearchField.

Want to do something similar to iChat's input field? This is a good jumping off point. I'll put up a screenshot when I get a chance unless someone else beats me to it.

Requires: General/CCDTextFieldCell and General/CCDPTextView

    
// General/CCDTextField.h
#import <General/AppKit/General/AppKit.h>
#import "General/CCDTextFieldCell.h"
#import "General/CCDPTextView.h"

@interface General/CCDTextField : General/NSTextField
{
    General/NSProgressIndicator *progressIndicator;
    General/NSTimer *progressTimer;
}

- (void)setProgressIndicator:(General/NSProgressIndicator *)indicator;
- (General/NSProgressIndicator *)progressIndicator;

// Use these to start/stop the progress animation, thanks.
- (void)startAnimation:(id)sender;
- (void)stopAnimation:(id)sender;

@end

// Feel free to expand this or link to related categories.
@interface General/CCDTextField(General/CCDTextFieldAdditions)
- (void)insertText:(General/NSString *)text;
- (General/NSRange)selectedRange;
- (void)replaceTextInRange:(General/NSRange)aRange withString:(General/NSString *)string;
@end


    
// General/CCDTextField.m
#import "General/CCDTextField.h"

@implementation General/CCDTextField

- (id)initWithCoder:(General/NSCoder*)coder {
    if (self = [super initWithCoder:coder]) {
        General/NSTextFieldCell *oldCell = [self cell];
        General/CCDTextFieldCell *myCell = General/[[CCDTextFieldCell alloc] initTextCell:[oldCell stringValue]];

        // Did I forget anything?...
        [myCell setAlignment:[oldCell alignment]];
        [myCell setFont:[oldCell font]];
        [myCell setControlSize:[oldCell controlSize]];
        [myCell setControlTint:[oldCell controlTint]];
        [myCell setEnabled:[oldCell isEnabled]];
        [myCell setBordered:[oldCell isBordered]];
        [myCell setBezeled:[oldCell isBezeled]];
        [myCell setBezelStyle:[oldCell bezelStyle]];
        [myCell setSelectable:[oldCell isSelectable]];
        [myCell setContinuous:[oldCell isContinuous]];
        [myCell setSendsActionOnEndEditing:[oldCell sendsActionOnEndEditing]];
        [myCell setEditable:[oldCell isEditable]];
        [myCell setTarget:[oldCell target]];
        [myCell setAction:[oldCell action]];

        // doesn't support a placeholderString..yet
        
        [self setCell:myCell];
        [myCell release];
    }
    {
        General/NSProgressIndicator *defaultIndicator = General/[[NSProgressIndicator alloc] initWithFrame:[self frame]];
        [defaultIndicator setStyle:General/NSProgressIndicatorBarStyle];
        [defaultIndicator setIndeterminate:YES];
        [defaultIndicator setBezeled:NO];
        [defaultIndicator setFrameOrigin:General/NSMakePoint(-600,-600)];
        [self setProgressIndicator:defaultIndicator];
        [defaultIndicator release];
    }

    return self;
}

- (void)dealloc
{
    [self setProgressIndicator:nil];
    [super dealloc];
}
 
- (void)setProgressIndicator:(General/NSProgressIndicator *)indicator
{
    [progressIndicator removeFromSuperview];
    progressIndicator = indicator;
    [self addSubview:progressIndicator];
}
- (General/NSProgressIndicator *)progressIndicator
{
    return progressIndicator;
}

- (void)startAnimation:(id)sender
{ // Game on
    progressTimer = General/[[NSTimer scheduledTimerWithTimeInterval:[progressIndicator animationDelay] target:self selector:@selector(animate:) userInfo:nil repeats:YES] retain];
    [progressIndicator startAnimation:sender];
    General/self cell] setAnimating:YES];
}
- (void)animate:(id)sender
{
    if ([[self cell] isAnimating]) [self display];
    else
    {
        [progressTimer invalidate];
        [progressTimer release];
         progressTimer = nil;
    }
}
- (void)stopAnimation:(id)sender
{ // Game off    
    [progressIndicator stopAnimation:sender];
    [[self cell] setAnimating:NO];
    [self removeFromSuperview];
}

- (void)mouseDown:([[NSEvent *)event
{
    General/NSPoint mouseLoc = [event locationInWindow];
    General/NSRect bounds = [self bounds];
        id cell = [self cell];

        if (!General/NSPointInRect(mouseLoc, [cell textRectForBounds:bounds])) {
            
            General/NSRect leftRect = [self convertRect:[cell leftButtonRectForBounds:bounds] toView:nil];
            General/NSRect rightRect = [self convertRect:[cell rightButtonRectForBounds:bounds] toView:nil];
                
                if (General/NSPointInRect(mouseLoc, leftRect)) {
                    id leftCell = [cell leftButtonCell];
                        [leftCell setHighlighted:YES];
                }
                else
                if (General/NSPointInRect(mouseLoc, rightRect)) {
                    id rightCell = [cell rightButtonCell];
                    [rightCell setHighlighted:YES];
                }
                return;
            }
     
     [super mouseDown:event];
}

- (void)mouseUp:(General/NSEvent *)event
{
    General/NSPoint mouseLoc = [event locationInWindow];
    General/NSRect bounds = [self bounds];
    id cell = [self cell];
    id leftCell = [cell leftButtonCell];
    id rightCell = [cell rightButtonCell];
    
        [leftCell setHighlighted:NO];
        [rightCell setHighlighted:NO];
    
    if (!General/NSPointInRect(mouseLoc, [cell textRectForBounds:bounds])) {
        General/NSRect leftRect = [self convertRect:[cell leftButtonRectForBounds:bounds] toView:nil];
        General/NSRect rightRect = [self convertRect:[cell rightButtonRectForBounds:bounds] toView:nil];
        
        if (General/NSPointInRect(mouseLoc, leftRect)) {
            if ([leftCell isKindOfClass:General/[NSActionCell class]])
                    [self sendAction:[leftCell action] to:[leftCell target]];
        }
        else
            if (General/NSPointInRect(mouseLoc, rightRect)) {
                if ([rightCell isKindOfClass:General/[NSActionCell class]])
                    [self sendAction:[rightCell action] to:[rightCell target]];
            }
    }
    
    [super mouseUp:event];
}

@end

#pragma mark (General/CCDTextFieldAdditions)
@implementation General/CCDTextField (General/CCDTextFieldAdditions)
- (void)insertText:(General/NSString *)text
{
    [self replaceTextInRange:[self selectedRange] withString:text];
}
- (General/NSRange)selectedRange
{
    id textObj = General/self window] fieldEditor:YES forObject:self];
    return [([[CCDPTextView*)textObj prvtSelectedRange];
}

- (void)replaceTextInRange:(General/NSRange)aRange withString:(General/NSString *)string
{
    General/NSMutableString *ourString = General/self stringValue] mutableCopy];
    [ourString replaceCharactersInRange:aRange withString:string];
    [self setStringValue:[[ourString copy] autorelease;
    [ourString release];
}
@end


----
11/21; The cell is highlighted and the action is sent in     mouseUp instead of     mouseDown:.
*This should be fixed to deal with different kinds of General/NSButtonCells - it's no good for General/NSPopUpButtonCells, for instance. Suggestions or fixes?*

11/25; Added the category to make inserting text easier. Getting the selectedRange requires posing as the field editor for some reason so General/CCDPTextView is required (unless you can find another way or want to rip it out).

11/29; Removed the conversation with myself and added the optional progress bar. Use     [textfield startAnimation:nil]; to start the progress bar and     [textfield stopAnimation:nil]; to stop it. Only tested with an indeterminate progress bar, you can fix the others, right?

Forgot     [myCell setAlignment:[oldCell alignment]];, seriously, are there more? Removed the placeholder stuff since it was being drawn over anyway.

4/8; General/CCDImageCategory wasn't needed, as described on its page.

----

Sorry to be a drag but ... what is General/CCDTextField for? What does it do? The explanation "Want to do something similar to iChat's input field?" doesn't tell me what this is, does. -- General/MikeTrent

It's a text field that allows for the additions of buttons in the right and left portions of the field, such as a search field or the iChat text field with the smiley face button on the right of the field.

----

The explanation can be misleading for some, especially those looking for a General/DynamicallyResizingTextViewOrField, another behavior of iChat's input field. 

----

Does this also work with a subclass of General/NSSecureTextField. I tried this with other examples, but the icon never appeared :(