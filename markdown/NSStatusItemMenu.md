

So I've created a General/MailBundle which displays an General/NSStatusItem showing the number of unread email messages in Mail.app.  I want the General/NSStatusItem to have a menu, but it didn't work for the most current release.  I rebuilt my program from scratch, and I've found out what the problem is.  I have a system in place which sends out an General/NSNotification when the unread count should be updated, and it calls this function:

    
- (void) updateMailUnreadMenuCount:(General/NSNotification *)notification
{
	[statusItem setTitle:@"c"];
	
	// Run Applescript To Get Unread Count
	General/NSString *unreadCount = General/[[NSString alloc] init];
	bool returnValue = [self executeAppleScript:@"getUnreadCount" withNSString:unreadCount];
	
	// Set Image For General/NSStatusItem
	[statusItem setImage:menuIcon];
	
	// Show Unread Value Based On Preferences
	if( returnValue )
		[statusItem setTitle:unreadCount];
	else
		[statusItem setTitle:@"e"];
}


Now, if I remove the third line of code (the one that sets the title to "c") then the General/NSMenu that is attached to the General/NSStatusItem will not display when the status item is clicked.  However, if I include the line of code, the menu shows just fine.  Does anyone know why this is?  It seems extremely odd, and I can't find a logical reason for it.  Thanks for any suggestions.  -- General/LoganRockmore

----

alright, so I looked into it a little further, and here's what I found.  I got rid of the third line altogether (which is exactly how I want the code to be).  Initially, when I start the program, clicking on the General/NSStatusItem does absolutely nothing.  I have another General/NSStatusItem program in the menu bar as well.  If I quit this second program, and then relaunch it, this basically moves the Mail General/NSStatusItem a little to the right.  After doing this "refreshing", the menu works just fine, as it should.

So, I guess there needs to be some way to programatically refresh the General/NSStatusItem, in order to get the menu to work.  Does this make any sense to anyone?  Thanks.  -- General/LoganRockmore