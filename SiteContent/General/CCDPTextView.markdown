Required for General/CCDTextField (again).

Used for getting the     selectedRange when the field editor returns garbage.

    
// General/CCDPTextView.h
#import <General/AppKit/General/AppKit.h>

@interface General/CCDPTextView : General/NSTextView {}
- (General/NSRange)prvtSelectedRange;
@end


    
// General/CCDPTextView.m
#import "General/CCDPTextView.h"

// This kinda sucks but it's not too terrible.
@implementation General/CCDPTextView

static General/NSRange myPrvtSelectedRange;

- (void)setSelectedRange:(General/NSRange)aRange
{
    myPrvtSelectedRange = aRange;
    [super setSelectedRange:aRange];
}

- (General/NSRange)prvtSelectedRange
{
    return myPrvtSelectedRange;
}
@end



You will need to modify your main.m file to look like this...
    
#import <Cocoa/Cocoa.h>
#import "General/CCDPTextView.h"

int main(int argc, const char *argv[])
{
    General/[CCDPTextView poseAsClass:General/[NSTextView class]];
    return General/NSApplicationMain(argc, argv);
}
