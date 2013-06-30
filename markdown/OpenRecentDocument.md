Hi,

I want to trap (General/NSDocumentController) _openRecentDocument in my document based application.

I known that this function is private but can I do that ?

-- Jean-Michel Marino

----

1) Creating a subclass of General/NSDocumentController like this :

    

#import "General/AMDocumentController.h"
#import "Controller.h"

@implementation General/AMDocumentController

-(General/IBAction) _openRecentDocument:(id)sender
{
	Controller *ctrl = (Controller *)General/[NSApp delegate];
	
	if([ctrl respondsToSelector:@selector(setFlagOpenRecentFile:)]){
		[ctrl setFlagOpenRecentFile:YES];
	}

	// ---- don't forget...
	[super _openRecentDocument:sender];
}

@end



2) add member m_flagOpenRecentFile and function setFlagOpenRecentFile into your controller class.

3) instantiate this new class into main nib.

-- Jean-Michel Marino