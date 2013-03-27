

I'm fairly new to Cocoa so I apologize if this is an obvious one ...

Is there any simple way to control/configure the behavior of what an General/NSTableView does after a cell has been edited - normally when you hit RETURN control is automatically passed to the next cell below, or if TAB is pressed control is passed to the cell to the right, but can this be configured ? Most of the time this behavior is OK but the problem I have is that after editing a cell on the bottom row control is then passed back up to the top row which isn't really what I want to happen as I'd like it just to remain on the bottom line.

I suspect I might have to subclass General/NSTableView and tackle the problem that way.

Thanks in advance for any suggestions.

Fraz(UK)

----
Yes, does anybody know how to alter RETURN key behavior in General/NSTableView? Ususally when you hit return (while editing cell) it stops editing for that cell and starts editing for the next one. But I want just to stop editing and select current cell.

----

The following "Ugly Hack (TM)" works just fine for me. It could probably be tightened up, but oh well. Drop this in an General/NSTableView subclass.

< UGLY HACK >

    
// Override default 'edit next' action with 'done editing'
- (void)textDidEndEditing:(General/NSNotification *)notification
{ 
    if (General/[notification userInfo] objectForKey:@"[[NSTextMovement"] intValue] == General/NSReturnTextMovement)
    {
        General/NSMutableDictionary * newUserInfo;
        General/NSNotification * newNotification;
        newUserInfo = General/[NSMutableDictionary dictionaryWithDictionary:[notification userInfo]]; 
        [newUserInfo setObject:General/[NSNumber numberWithInt:General/NSIllegalTextMovement] forKey:@"General/NSTextMovement"];
        newNotification = General/[NSNotification notificationWithName:[notification name] object:[notification object] userInfo:newUserInfo];
        [super textDidEndEditing:newNotification];
        General/self window] makeFirstResponder:self]; 
    } else {
        [super textDidEndEditing:notification]; 
    }
}

< /UGLY HACK >


----
I've implemented the code you have above in what I think is a subclass of [[NSTableView, however, the line:
[super textDidEndEditing:newNotification];
is giving me the following error:
2005-10-14 14:47:37.144 General/MountWatcher[17515] *** -General/[NSTableView textDidEndEditing:]: selector not recognized [self = 0x347e60]
2005-10-14 14:47:37.144 General/MountWatcher[17515] Exception raised during posting of notification.  Ignored.  exception: *** -General/[NSTableView textDidEndEditing:]: selector not recognized [self = 0x347e6

Here is the subclass that I've entered in my .h file:
    
@interface General/NSTableView (textDidEndEditing)
- (void) textDidEndEditing:(General/NSNotification *)notification;
@end

@implementation General/NSTableView (textDidEndEditing)
- (void) textDidEndEditing: (General/NSNotification *) notification
{
	printf("Entered tv tdee\n");
	// This is ugly, but just about the only way to do it. 
	//General/NSTableView is determined to select and edit something else, even the 
	//	text field that it just finished editing, unless we mislead it about 
	//	what key was pressed to end editing. 
	if (General/[notification userInfo] objectForKey:@"[[NSTextMovement"] intValue] == General/NSReturnTextMovement) 
    {
        General/NSMutableDictionary * newUserInfo;
        General/NSNotification * newNotification;
        newUserInfo = General/[NSMutableDictionary dictionaryWithDictionary:[notification userInfo]]; 
        [newUserInfo setObject:General/[NSNumber numberWithInt:General/NSIllegalTextMovement] forKey:@"General/NSTextMovement"];
        newNotification = General/[NSNotification notificationWithName:[notification name] object:[notification object] userInfo:newUserInfo];
        [super textDidEndEditing:newNotification];
        General/self window] makeFirstResponder:self]; 
    } else {
        [super textDidEndEditing:notification]; 
    }
	 
	
} // textDidEndEditing


Can anyone explain why I can't call the superclasses textDidEndEditing???  When I edit the cell data, my textDidEndEditing method is called, I get the above mentioned error, and the text does not change in the table.

Thanks

*Because [[NSTableView's super class is General/NSView. You put this in as a category. Make an actual subclass. Create a new file called soemthing like* "My<nowiki/>General/TableView" *and* **OVERRIDE** *the above method.*

For information on subclassing, see: http://developer.apple.com/documentation/Cocoa/Conceptual/General/AddingBehaviorToCocoa/Articles/General/BasicSubclassDesign.html