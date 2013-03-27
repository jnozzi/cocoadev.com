Basically, i'm trying to make an app which will take an array of the available fonts on the computer, and put them all in an General/NSTableView.  Simple enough, right?

Here's what I wrote.

    

#import "Controller.h"

@implementation Controller

-(void)awakeFromNib
{
    fontManager = General/[NSFontManager sharedFontManager];
    array = [fontManager availableFonts];
}
- (General/IBAction)update:(id)sender
{
}
- (int)numberOfRowsInTableView:(General/NSTableView *)aTableView
{
    return [array count];
}
- (id)tableView:(General/NSTableView *)aTableView objectValueForTableColumn:(General/NSTableColumn *)aTableColumn row:(int)rowIndex
{
    return [array objectAtIndex:rowIndex];
}
@end



General/FontManager is an General/NSFontManager pointer... Array is an General/NSArray pointer.  Can someone help me out here?  Here's what happens when I compile and run.  I see a few fonts, but font all of them... then it crashes and says this 

## Component Manager: attempting to find symbols in a component alias of type (regR/carP/x!bt)

Font Tester has exited due to signal 10 (SIGBUS).

Thanks.

--General/CharlieMiller

----

availableFonts is autoreleased... remember to retain it !

/General/PtxMac

----

Ah great, now I feel like an idiot.  Thanks :)

----

Cool. Now tell me what 

## Component Manager: attempting to find symbols in a component alias of type (regR/carP/x!bt) 

means. I get it when I build on my iBook but not when I build on my other platform, a G4 tower

----

Do you have Suitcase or anything else that messes with fonts installed on the iBook? (and not on the G4)

----

It's a bug in Roxio Toast 5 VCD plug-in. Either delete /Library/General/QuickTime/Toast Video CD Support.qtx or get Toast 6.