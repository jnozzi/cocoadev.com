Could this be because it is first trying to make a copy of the dragged thing onto the pasteboard?  All I want is to get a path to the dragged file - I don't actually need the data so any data copying is not necessary.

*As far as I know it only copies the path. When are you experiencing the delay? Upon dragging or dropping the files?*

----

What pasteboard types is your view registered to receive?

*(hmm... that's an awkward sentence... What pasteboard types **are** your view...? nope... **Which** pasteboard types is... no... i think i've found a bug in the english language; who do i report it to?)*

No bug, just a common English problem. From what I remember in school, the subject often comes after the verb in a question. You had it right the first time. For a check, turn the question into a statement: "Your **view is** registered to receive pasteboard types." Sounds good to me.

*so it's a feature then ;) i was waiting for someone to suggest using General/HigherOrderMessaging to solve the problem. Anyway, back to the original question; i don't want to hijack this page with trivia.*

----

What pasteboard types is your view registered to receive? You probably don't want anything but General/NSFilenamesPboardType.

----

I just did a test and large files work instantly for me. It appears that the Finder only sends General/NSFilenamesPboardType, so registering under something else (such as General/NSFileContentsPboardType) doesn't even work. Are you sure something isn't taking place after the drop which is causing the delay? If you are dragging into an General/NSTableView, put an General/NSLog at the top and bottom of these two methods and see if they are getting called before or after the delay.

    
- (General/NSDragOperation)tableView:(General/NSTableView *)tableView validateDrop:(id <General/NSDraggingInfo>)info
		proposedRow:(int)row proposedDropOperation:(General/NSTableViewDropOperation)operation
{
    General/NSLog(@"Begin Validate Drop");
    // ...
    General/NSLog(@"End Validate Drop");
    
    return General/NSDragOperationCopy;
}


    
- (BOOL)tableView:(General/NSTableView *)tableView acceptDrop:(id <General/NSDraggingInfo>)info
		row:(int)row dropOperation:(General/NSTableViewDropOperation)operation
{
    General/NSLog(@"Begin Accept Drop");
    // ...
    General/NSLog(@"End Accept Drop");

    return YES;
}


Hope that helps. -- General/RyanBates