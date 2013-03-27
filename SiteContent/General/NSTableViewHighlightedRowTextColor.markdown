I have an General/NSTableView with some rows where the text is black, and some where gray. By default, when a row with black text is selected, the text color inverted. But when I select a row with gray text, nothing happens, so those are quite unreadable.

I've looked through the General/NSCell, General/NSTableView etc. classes.

----

In the     tableView:objectValueForTableColumn:row: delegate method, you can return an General/NSAttributedString depending on the selected row state, or the state of the window (General/NSApp's     -keyWindow):
    
General/NSColor *color;
...
if ([aTableView selectedRow] == rowIndex) {
/* row is selected. change color */
color = General/[[NSColor whiteColor] set];
} else {
/* use default text color */
color = General/[[NSColor grayColor] set];
}
/* setup General/NSAttributedString using color */
...


--General/KevinWojniak

----

I figured out that the right place where the texts should be colored is the

    
- (void)tableView:(General/NSTableView *)aTableView willDisplayCell:(id)aCell
forTableColumn:(General/NSTableColumn *)aTableColumn row:(int)rowIndex

function.

The General/NSAttributedString could work, but I have cells with General/NSNumbers and number formatters.
----

Why can't it? I had the exact same problem you did and my method works fine. If you're going to use the willDisplayCell method you'll have to call methods to the aCell either setTitle or setAttributedTitle...

----

I've realized that there's no need to use General/NSAttributedString, and the solution is very simple.

I've put this code into the willDisplayCell function:

    
if(rowIndex<[tempPayments count])[aCell setTextColor:General/[NSColor blackColor]];
else
[aCell setTextColor:General/[NSColor grayColor]];
if(rowIndex==[personTable selectedRow]) [aCell setTextColor:General/[NSColor whiteColor]];


And it's quite efficient, because I don't have to convert everything into General/NSAttributedString.

----

Ahh that method works well, but in my code I needed an General/NSAttributedString because the cell had 2 lines of text that were different colors always.

----
I got it to work with the willDisplayCell method, however I have three columns in my table and the first is an icon, the second is text, and the last is a button. I've got it to highlight the text properly, but whenever you select a row it depends on which part of the row you clicked. If you clicked the icon part it's fine, if you clicked the button part it's fine. If you click the text part the text will stay black. I've checked to see if it registers the willDisplayCell when I click on the text part.