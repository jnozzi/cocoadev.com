Required for [[CCDTextField]] (again).

Used for getting the <code>selectedRange</code> when the field editor returns garbage.

<code>
// [[CCDPTextView]].h
#import <[[AppKit]]/[[AppKit]].h>

@interface [[CCDPTextView]] : [[NSTextView]] {}
- ([[NSRange]])prvtSelectedRange;
@end
</code>

<code>
// [[CCDPTextView]].m
#import "[[CCDPTextView]].h"

// This kinda sucks but it's not too terrible.
@implementation [[CCDPTextView]]

static [[NSRange]] myPrvtSelectedRange;

- (void)setSelectedRange:([[NSRange]])aRange
{
    myPrvtSelectedRange = aRange;
    [super setSelectedRange:aRange];
}

- ([[NSRange]])prvtSelectedRange
{
    return myPrvtSelectedRange;
}
@end
</code>


You will need to modify your main.m file to look like this...
<code>
#import <Cocoa/Cocoa.h>
#import "[[CCDPTextView]].h"

int main(int argc, const char ''argv[])
{
    [[[CCDPTextView]] poseAsClass:[[[NSTextView]] class]];
    return [[NSApplicationMain]](argc, argv);
}
</code>