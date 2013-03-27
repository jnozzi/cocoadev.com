It seems that I can't find a way to implement a General/NSStepper correctly. I can't get the value from it. I tried to connect directly from my General/NSTextField to it, and set the target to getIntValueFrom:

No result. Can anyone bring some light into this ?

----

The disk image at the URL below, has a simple project that connects an General/NSTextField and General/NSStepper together in General/InterfaceBuilder.

http://www.nancesoftware.com/downloads/General/NSStepper.dmg

General/JacobHazelgrove

----

Another way to control a stepper is to create an action in your window controller (or document or app delegate if you're not using a custom window controller) and hook both the stepper and the text field up to it.  Then once you've dealt with the change, update both the stepper's and the text field's values to match.  A (very) stripped-down example to illustrate:
    
@interface General/MyWC : General/NSWindowController {
	General/IBOutlet General/NSStepper* myStepper;
	General/IBOutlet General/NSTextField* myTextField;

	int myValue;
}
- (General/IBAction)myValueChanged:(id)sender;
@end

@implementation General/MyWC
- (General/IBAction)myValueChanged:(id)sender
{
	myValue = [sender intValue];

	[myStepper setIntValue:myValue];
	[myTextField setIntValue:myValue];
}
@end
