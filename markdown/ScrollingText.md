In a recent project (remaking the iTunes controller window for my brother), I needed to have a view with scrolling text, so that if you shrunk the window, the song title would scroll across it. After much trial and error with General/NSTextField, I declared it impossible...using those ideas. Instead, I created a new subclass of General/NSView called (what else) General/ScrollingText. I didn't choose S<nowiki/>crollingTextView because that sounds like a subclass of General/NSTextView. It basically works by eating a character for each increment (calling the     scrollOneGlyph method increases the offset), and stopping once the offset goes past the edge of the view. I had to learn about the Cocoa Text System to finish this, basically creating my own General/NSTextView (that didn't subclass General/NSText).

Someone might point out that it is more economic to use the     mutableString function of General/NSTextStorage (really of General/NSMutableAttributedString). I agree; so if someone figures out why it crashes every time I try, then please update the code accordingly (test your solution first!)

If someone (maybe me) ends up implementing this as an General/NSText subclass, it would become that much more useful.

--General/JediKnil

**General/ScrollingText.h**
    
#import <Cocoa/Cocoa.h>

@interface General/ScrollingText : General/NSView {
    General/NSTextContainer *textContainer;
    General/NSTextStorage *textStorage;
    General/NSLayoutManager *layoutManager;
    General/NSMutableString *string;
	
    unsigned offset;
    BOOL shouldAdd;
}
- (void)setup;
- (General/NSString *)string;
- (void)setString:(General/NSString *)newString;
- (void)setString:(General/NSString *)value resettingScroll:(BOOL)shouldReset;
- (void)scrollOneGlyph;
@end


**General/ScrollingText.m**
    
#import "General/ScrollingText.h"

static General/NSDictionary *defaultAttributes = nil;

@implementation General/ScrollingText

- (id)initWithFrame:(General/NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self != nil) {
        [self setup];
    }
	
    return self;
}

- (BOOL)isFlipped
{
    return YES;
}

- (void)setup
{
    General/NSMutableParagraphStyle *style;

    textStorage = General/[[NSTextStorage alloc] init];
    layoutManager = General/[[NSLayoutManager alloc] init];
    textContainer = General/[[NSTextContainer alloc] init];
	
    [layoutManager addTextContainer:textContainer];
    [textContainer release];
    [textStorage addLayoutManager:layoutManager];
    [layoutManager release];
	
    style = General/[[NSMutableParagraphStyle alloc] init];
    [style setAlignment:General/NSCenterTextAlignment];
    [style setLineBreakMode:General/NSLineBreakByCharWrapping];
	
    if (defaultAttributes == nil) {
        defaultAttributes = General/[[NSDictionary alloc] initWithObjectsAndKeys:General/[NSFont userFixedPitchFontOfSize:0.0], General/NSFontAttributeName,
                                    [style autorelease], General/NSParagraphStyleAttributeName,
                                    nil];
    }
		
    [textContainer setContainerSize:[self frame].size];
		
    string = General/[[NSMutableString alloc] init];
    offset = 0;
}

- (void)drawRect:(General/NSRect)rect
{
    General/NSRange glyphRange;
    General/NSPoint origin = [self bounds].origin;
    General/NSString *scrollStr;
    unsigned length = [string length];
		
    glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
	
    if (offset + [layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:nil].length >= length) {
        shouldAdd = NO;
    }
    scrollStr = [string substringFromIndex:offset];
	
    [textStorage setAttributedString:General/[[[NSAttributedString alloc] initWithString:scrollStr attributes:defaultAttributes] autorelease]];
					
    glyphRange = [layoutManager glyphRangeForTextContainer:textContainer];
	
    [layoutManager drawGlyphsForGlyphRange:glyphRange atPoint:origin];
	
    [super drawRect:rect];
}

- (void)viewDidEndLiveResize
{
    [textContainer setContainerSize:[self frame].size];
    [self setNeedsDisplay:YES];
}

- (BOOL)inLiveResize
{
    if ([super inLiveResize]) {
        [textContainer setContainerSize:[self frame].size];
        return YES;
    } else return NO;
}

- (void)setString:(General/NSString *)value
{
    [self setString:value resettingScroll:YES];
}

- (void)setString:(General/NSString *)value resettingScroll:(BOOL)shouldReset
{
    if (value == nil || [value isEqualToString:string]) {
        // If the new string is nil OR is the same as the old string...
        // ...just redisplay and return
        [self setNeedsDisplay:YES];
        return;
    }
	
    [string setString:value];
	
    if (shouldReset)
        offset = 0;
	
    [self setNeedsDisplay:YES];
}

- (General/NSString *)string
{
    return string;
}

- (void)scrollOneGlyph
{
    if (shouldAdd) {
        offset++;
    } else {
        offset = 0;
        shouldAdd = YES;
    }
}

- (void)dealloc
{
    [textStorage release];
    [string release];
    [super dealloc];
}
@end

----
I would render the text once onto an General/NSImage then only render a peice of it at a time, aka moving the rendering rectangle to the right instead of the text to the left.  That'll save you from using all those costly text functions.

- General/FranciscoTolmasky

**Yeah, I looked into that, but that's also pretty costly for my purpose: an iTunes controller. Whenever the song information changes, you would have to update the General/NSImage...which looked worse to me for some reason (maybe you're right). If you come up with a working version of your idea, please post the code up here. --General/JediKnil**

Writing to a view or to an General/NSImage is equally costly. - General/FranciscoTolmasky

**I meant drawing the General/NSImage to the view *as well as* writing the text to the General/NSImage. The difference is that the text has to be written to the view every time in my solution, whereas only a pre-rendered image has to be written to the view in yours. So even though I have to keep track of the image as well, you're probably right. --General/JediKnil**

----

Is it just me or could you just use an General/NSScrollView, put your view inside that, and then use General/NSClipView's scrollToPoint: ?

**Again, yeah, but I didn't exactly know how to do that in IB without the scroll bars, etc. Besides, the problem with all of this is it won't always scroll by one character (although this might be considered a feature). Anyway, it was a learning experience for me... --General/JediKnil**

Thats cool :^), that is what makes programming worth while hehe.

You can do it kind of that way, but you don't need a General/NSScrollView, just a General/NSClipView with a General/NSImageView or General/NSTextView inside it - Create a General/NSImage/General/NSTextView in interface builder and select it, then go to the Layout menu and click Make Subviews Of -> Custom View then select General/NSClipView as its custom class then use scrollToPoint to move it around!  This approach needs very little code but may not be the most efficient way of doing things :) -- Tim Ellis

----

Why not call it General/MarqueeView

*Yes, yes, it seems like people are more interested in this than I would have thought (and also much smarter than I am). Maybe we should make this a discussion, or something -- the best way to animate scrolling text. General/MarqueeView is also probably a better name than General/ScrollingText. Anyone want to post some more efficient code for the General/CocoaDev community? --General/JediKnil*

----

I modified the rect before passing to super in     drawWithFrame:General/InView: of General/NSTextFieldCell and got decent results. Nothing I would share (or use) but not terrible for a 5 minute distraction. *shrug*