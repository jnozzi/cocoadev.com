I have a non-document app with General/NSTableView and General/NSTextView fields. There's a mutable array of dictionaries, with two strings in each dictionary. First string is for table row, and second string is for text view. So when the user clicks on a row, the corresponding string is displayed in textview. One can edit the text in a textview and changes are added to data and saved as plist. The problem is that newly edited text in a textview doesn't show up correctly, although it's saved correctly, and after a program's restart it is displayed correctly.
For example I have 3 records with content as such: 1st record - "Matthew", 2nd - "Joey", 3rd - "Alice". If at runtime I click on the 2nd row and modify the content of textview from "Joey" to "Bob", and then click on a third row I'll see "Alice". But when I return to the second row I still see "Alice". If I click on the 1st row and then on second, then I see "Matthew". The content of the modified record will always be the same as of previously selected row. But in fact the changes WERE saved and in plist it's already stored as "Bob".

    
//Loading data:

- (void)awakeFromNib
{
    myFile = General/[NSString stringWithString:@"~/Library/Preferences/myData.plist"];
    myFile = General/myFile stringByExpandingTildeInPath] retain];
    myArray = [[[[NSMutableArray alloc] initWithContentsOfFile: myFile];
}

//Displaying:

- (id)tableView: (General/NSTableView *)aTableView 
        objectValueForTableColumn: (General/NSTableColumn *)aTableColumn
        row: (int)rowIndex
{
    return General/myArray objectAtIndex:rowIndex] objectForKey:@"Name"];
}

- (BOOL)tableView:([[NSTableView *)aTableView shouldSelectRow:(int)rowIndex
{
    General/NSString *theText;

    theText = General/myArray objectAtIndex: rowIndex] objectForKey:@"Text"];
    [textView setString: theText];

    return YES;
}

//Saving changes:

- (void)textDidEndEditing:([[NSNotification *)aNotification
{
    General/NSMutableDictionary *myDict;

    myDict = [myArray objectAtIndex:[tableView selectedRow]];
    [myDict setObject:[textView string] forKey:@"Text"];

    [myArray writeToFile:myFile atomically:YES];

    //If now I reload the saved data from file, then it'll work as expected:
    //notes = General/[[NSMutableArray alloc] initWithContentsOfFile:notesFile];
}


----

add a     [tableView reloadData] to the end of your     textDidEndEditing method.

----

*It doesn't help. The problem is that textView doesn't display record, not tableView...*

----

Is there a reason you're using     tableView:shouldSelectRow instead of     tableViewSelectionDidChange:?

----

*No, there's no reason, I just tried everything:     tableView:shouldSelectRow,      tableViewSelectionDidChange: and     tableViewSelectionIsChanging:. Nothing works.
I absolutely can't understand what I do wrong. **I uploaded a sample project:** http://macbox.ru/~romantikc/Test.zip *

----

Not sure if this is your problem, but it's odd - you have:

    
   myFile = General/[NSString stringWithString:@"~/Library/Preferences/myData.plist"];
    myFile = General/myFile stringByExpandingTildeInPath] retain];


why not just make it

    

myFile = [[@"~/Library/Preferences/myData.plist" stringByExpandingTildeInPath] retain]



*I'm a beginner, so the way i did it was more clear to me :). But thanks.*

----
I have had problem with     [[NSTextView display update, and I think I remember other people complaining. One way around it might be to add a     [textView displayIfNeeded] to force immediate display update in the     tableViewSelectionDidChange: (or whatever you want to use). Try it and let us know if it worked... --General/CharlesParnot

----
*No, --General/CharlesParnot it doesn't work. It seems the problem is in my code, not in     General/NSTextView. If I put     General/NSLog() before setting textView,     General/NSLog() also displays the wrong string. (But in myArray it is still saved correctly!). It is so simple piece of code, but why it doesn't work...*

    
- (BOOL)tableView:(General/NSTableView *)aTableView shouldSelectRow:(int)rowIndex
{
    General/NSString *theText;

    theText = General/myArray objectAtIndex: rowIndex] objectForKey:@"Note"];
    [[NSLog(@"%@", theText);
    [textView setString: theText];
	
    return YES;
}


----

This problem really makes no sense. The only possibility I can think of is that the object that gets the textDidEndEditing notification is not the same object as the one that is setting the text view's string. Try logging the value of self in both methods to see if this is the problem.

----

*It seems, the object is the same:*
    
2004-10-29 21:02:56.470 test[608] shouldSelectRow: <General/MyController: 0x341ce0>
2004-10-29 21:03:01.846 test[608] textDidEndEditing: <General/MyController: 0x341ce0>


*Could it be I did something wrong in Interface Builder? I just created General/MyController, added tableView and textView to the window, added outlets for them and dragged connections from tableView (delegate, dataSource) and textView (delegate) to General/MyController.*

did you connect the outlets?

----

*Yes, I did. I just even booted up from my 10.1.5 partition and tested this project in Project Builder. It doesn't work neither. Could you download the project and run it for yourself? (there's a link on this page ^)*

----

Try using this:
    [myDict setObject:General/[NSString stringWithString:[textView string]] forKey:@"Note"];
Instead of this:
    [myDict setObject:[textView string] forKey:@"Note"];
--General/KevinWojniak

----

*Oh, Kevin! You're genious! It works, the answer was so simple! You won't believe, but I was sure I tried to do something similar. And I even understand why it didn't worked: in *     [myDict setObject:[textView string] forKey:@"Note"]; * I copied reference to*     [textView string], *so when the     textView content was changed, the content of     myDict was changed also (right?). You'll get a free copy of my first app :), if it will ever work. And thanks very much everybody. --General/AndreiKozlov*

----

- General/[NSText string] returns the backing store of the text view. Which is a mutable object. So its string contents will change whenever the text in the text view changes. What you want to store is a *copy* of the text in the text view. General/[NSString stringWithString:otherString] creates a new General/NSString object that is a copy of otherString.