I tried to open a new sheet with:

General/[NSApp beginSheet:loeschenSheet modalForWindow:mainWindow modalDelegate:self didEndSelector:NULL contextInfo:nil];

It worked perfectly.


Then I tried to send an Action from another class to my sheetController, which should then open the sheet, but this is what I got:

2002-06-29 21:11:24.287 General/MyApp[6870] *** Assertion failure in -General/[NSApplication _commonBeginModalSessionForWindow:relativeToWindow:modalDelegate:didEndSelector:contextInfo:], General/NSApplication.m:2306
2002-06-29 21:11:24.299 General/MyApp[6870] Modal session requires modal window

Tried it with another action, and it worked, just not with this.


Hope this makes sense. *g*

-- General/MartinWeil

Hmmm can you be a little more detailed? what action did, what action didnt?

----

I am having the same issue, calling a sheet from a different class causes that. This is what I got:

General/DXTableViewController.m
    
#import "General/DXTableViewController.h"
#import "General/DXApplicationController.h"

General/DXApplicationController* dxAppControl;

@implementation General/DXTableViewController

- (General/IBAction)addNewTask:(id)sender {
dxAppControl = General/[[DXApplicationController alloc] init];
[dxAppControl beginSheetForTaksAddition];
}


General/DXApplicationController.m
    
#import "General/DXApplicationController.h"
#import "General/DXTableViewController.h"

- (void)beginSheetForTaskAddition {
General/[NSApp beginSheet:addSheet modalForWindow:General/[NSApp keyWindow] modalDelegate:NULL didEndSelector:NULL contextInfo:NULL];
}


I get the same error as our friend above:
    
2005-07-05 21:47:41.553 General/QuickTask[416] *** Assertion failure in -General/[NSApplication _commonBeginModalSessionForWindow:relativeToWindow:modalDelegate:didEndSelector:contextInfo:], General/AppKit.subproj/General/NSApplication.m:2763
2005-07-05 21:47:41.554 General/QuickTask[416] Modal session requires modal window


Any ideas? - General/FernandoLucasSantos

----

Normally this error occurs because your sheet is nil. Check in the debugger to make sure that     addSheet is actually a valid General/NSWindow.