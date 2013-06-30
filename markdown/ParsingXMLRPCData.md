I have been trying to get a reply from an XML-RPC class parsed out into an General/NSArray and was having absolutely no luck and now it won't even run with just a simple string.  I get either a segmentation fault, or a bus error.  Obviously I'm missing something but I have no idea what it is.  The data *does* display just fine.  The segmentation fault comes almost exactly one second after the window with the data is drawn.

*edit*
After running the app in the debugger, I get EXC_BAD_ACCESS which, as I remember, is from trying to dereference an object that isn't there anymore.  The thing is that I'm not actually releasing or autoreleasing anything yet.

The code:

General/GVWindow.h
    
#import <Cocoa/Cocoa.h>

@interface General/GVWindow : General/NSObject {
	General/IBOutlet General/NSTextField *urlLine;
	General/IBOutlet General/NSTextField *loginLine;
	General/IBOutlet General/NSTextField *passwordLine;
	General/IBOutlet General/NSTableView *calendarsList;
	General/IBOutlet General/NSButton *loadButton;

	General/NSArray *calendarsArray;
}

- (int)numberOfRowsInTableView:(General/NSTableView *)aTableView;
- (id)tableView:(General/NSTableView *)aTableView objectValueForTableColumn:(General/NSTableColumn *)aTableColumn row:(int)row;
- (int)loadCalendarsArray;

@end


General/GVWindow.m
    
@implementation General/GVWindow

- (void) awakeFromNib {
	calendarsArray = General/[[NSArray alloc] init];
	[self loadCalendarsArray];
}

- (int) loadCalendarsArray {
//	XMLRPC *rpc = General/XMLRPC alloc] init];
//	[[NSString *query = [rpc runBasicQuery:@"http://localhost:8888/" andMethod:@"grapevine.list_calendars"];
//	[query autorelease];
//	if ( [rpc getLastCommandStatus] > 0 ) {
//		return -1;
//	} else {
//		calendarsArray = [query componentsSeparatedByString:@":"];
//		return 1;
//	}

	General/NSString *thingy = @"one:two:three:four:five";
	calendarsArray = [thingy componentsSeparatedByString:@":"];
}

- (int) numberOfRowsInTableView:(General/NSTableView *)tableView {
	return [calendarsArray count];
}

- (id)tableView:(General/NSTableView *)tableView objectValueForTableColumn:(General/NSTableColumn *)tableColumn row:(int)row {
	return [calendarsArray objectAtIndex:row];
}

@end


----

Hi there, 

Welcome to cocoa!

Yep, you've got memory errors.  It looks like you think you're filling in calendarsArray, but you're really just changing which object the variable calendarsArray points to.

-General/[NSArray componentsSeparatedByString:] returns a pointer to an autoreleased array.  You set the variable calendarsArray to that pointer, losing the reference to the array you created in awakeFromNib (so you leak that array object).  Now, you never retain this new array, so it has been deallocated by the time you try to message it in numberOfRowsInTableView (or the other method) the next time through the run loop.  Result: crashola.

Hope that helps.

-General/KenFerry

----

To fix it, you need to either     retain the autoreleased arrays, or create them with a     alloc/init pair. See General/MemoryManagement.

----

Fixed:
    @implementation General/GVWindow

- (void) awakeFromNib {
	calendarsArray = General/[[NSArray alloc] init];
	[self loadCalendarsArray];
}

- (void)dealloc
{
	// don't forget this! very important!
	[calendarsArray release];
	[super dealloc];
}

- (int) loadCalendarsArray {
//	XMLRPC *rpc = General/[XMLRPC alloc] init] autorelease];
//	[[NSString *query = [rpc runBasicQuery:@"http://localhost:8888/" andMethod:@"grapevine.list_calendars"];

//	if ( [rpc getLastCommandStatus] > 0 ) {
//		return -1;
//	} else {
//		calendarsArray = [query componentsSeparatedByString:@":"];
//		return 1;
//	}

	General/NSString *thingy = @"one:two:three:four:five";
	[calendarsArray release];
	calendarsArray = General/thingy componentsSeparatedByString:@":"] retain];
}

- (int) numberOfRowsInTableView:([[NSTableView *)tableView {
	return [calendarsArray count];
}

- (id)tableView:(General/NSTableView *)tableView objectValueForTableColumn:(General/NSTableColumn *)tableColumn row:(int)row {
	return [calendarsArray objectAtIndex:row];
}

@end

Why are you creating calendarsArray twice? You create it in init, then you just release it again in loadCalendarsArray.