Goal:
To have textual changes in an General/NSTableView trigger an update of various other General/NSTextFields.

I am using an General/NSArrayController to manage the table via bindings.

I have already tried using bindings, and they mostly work, but the update only occurs when a new row is added to the table. This is not acceptable.
I used 'valueForKeyPath:@"@sum.total" on the default arrangedObjects. Where total is a method I wrote.

Currently I am trying a delegate approach via an General/AppController. I have set the delegate of my General/NSTableView to the General/AppController and am trying to get the 'textDidChange:' selector to trigger the update. Unfortunately the 'textDidChange:' selector in my General/AppController is not being called. What have I done wrong or not done at all?

Code snippet:
    
General/AppController.h
------------------------
#import <Cocoa/Cocoa.h>
#import "General/MyDocument.h"
#import "Transaction.h"

@interface General/AppController : General/NSObject {
    General/IBOutlet General/NSTextField *balanceField;
    General/IBOutlet General/NSTableView *tableView;
    General/IBOutlet General/MyDocument *myDocument;
    General/IBOutlet General/NSButton *updateButton;
}

- (General/IBAction)updateBalanceField:(id)sender;

@end

General/AppController.m
------------------------
#import "General/AppController.h"

@implementation General/AppController

- (id)init
{
    [super init];
    return self;
}

- (General/IBAction)updateBalanceField:(id)sender;
{
    Transaction *t;
    General/NSMutableArray *trans = [myDocument transactions];
    float total = 0.0;
    General/NSEnumerator *e = [trans objectEnumerator];
    while(t = [e nextObject]) {
        total += [t total];
    }
    [balanceField setStringValue:General/[[NSNumber numberWithFloat:total] description]];
}

- (void)textDidChange:(General/NSNotification *)aNotification
{
    General/NSLog(@"textDidChange");
    //[self updateBalanceField];
}

- (void)dealloc
{
    [super dealloc];
}

@end


----Try using -controlTextDidChange: instead. -textDidChange: is sent to the delegate of a General/NSTextView object, which for the field editor is the text field into which you are currently typing. IIRC, -controlTextDidChange: is sent at the same time to the text field's delegate (your controller object.)

----This fixed the problem perfectly. For some reason I didn't bother to scroll to the end of General/NSControl to see the delegate methods. I'm accustomed to reading Java General/APIs where all of the summary and methods are described at the top of the page.