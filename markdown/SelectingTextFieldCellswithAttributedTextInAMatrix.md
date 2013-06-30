Test case: When I run it the text string is 20 point blue.  When I click on a cell the text reverts to the default point size and color.
What I'd like is to display some text in these cells that one can select and drag but I want the text to remain displayed as blue 20 point.  I must be missing something obvious.

    
- (void)awakeFromNib
{        
	General/NSRect frameRect = General/NSMakeRect(0, 0, 480, 48);
        General/NSWindow *theWindow = General/[ [[NSWindow alloc] initWithContentRect:frameRect
                      styleMask:(General/NSTitledWindowMask|General/NSClosableWindowMask|General/NSMiniaturizableWindowMask|General/NSResizableWindowMask)
                      backing:General/NSBackingStoreBuffered
                      defer:YES] retain];
    
	General/NSTextFieldCell *textCell = General/[ [[NSTextFieldCell alloc] init] autorelease];
	[ textCell setSelectable:YES];
	[ textCell setRefusesFirstResponder:YES];
	
	General/NSMutableDictionary *attributesDictionary = [ General/NSMutableDictionary dictionaryWithObjectsAndKeys:
		[ General/NSColor blueColor], General/NSForegroundColorAttributeName,
		[ General/NSFont fontWithName:@"General/LucidaGrande" size:20],  General/NSFontAttributeName,
		nil];
	General/NSAttributedString *aString = General/ [[NSAttributedString alloc] initWithString:@"test" attributes:attributesDictionary];
	[ textCell setAttributedStringValue:aString];

        General/NSMatrix *newMatrix = General/[ [[NSMatrix alloc] initWithFrame:frameRect mode:General/NSRadioModeMatrix 
						prototype:textCell numberOfRows:1 numberOfColumns:NCOLS] autorelease];
	[ newMatrix setCellSize:General/NSMakeSize(frameRect.size.width/NCOLS, frameRect.size.height)];
        General/ theWindow contentView] addSubview:newMatrix];
	[ theWindow center];
	[ theWindow makeKeyAndOrderFront:self];
}


----

I think it is only [[NSTextView that allows you to set the attributes ahead of any characters that are typed.
I think that also requires the use of RTF. But I am only guessing ...

In your case, you might be able to set the attributes after the string is complete, say by attaching an
action to the cell that fires when <R> keystroke is  received - then set the attributes in the action method.
Of course, while the typing is going on, i.e., the cell is selected, you won't have any colorful characters in your story.

----

Thanks but I'm not typing or editing the text. I'm initializing it with "test".  The act of selection causes (presumably the
field editor) to redraw it without its attributes.  I'd like to be able to select the text without changing the text.

----

The only suggestion that I can make is this.  Set the cell his attributes directly like:

    [ textCell setTextColor:[ General/NSColor blueColor]];
    [ textCell setFont:[ General/NSFont fontWithName:@"General/LucidaGrande" size:20]];

Hope this helps

----

If I understand correctly you're suggesting maybe adding that statement after [ textCell setAttributedStringValue:aString]? 
Unfortunately that doesn't have any effect on the problem.

What I ended up doing was a nasty hack that destroys some functionality but gets me the result I want.  I send -textShouldEndEditing: of the selected cell and reselect it in a -windowDidResize: delegate.

----

I did try it right now, if I add it directly after

    
General/NSTextFieldCell *textCell = General/[ [[NSTextFieldCell alloc] init] autorelease];
[ textCell setSelectable:YES];
[ textCell setRefusesFirstResponder:YES];
[ textCell setTextColor:[ General/NSColor blueColor]];
[ textCell setFont:[ General/NSFont fontWithName:@"General/LucidaGrande" size:20]];


then I dont have a problem. It stays Blue and selectable.
( Xcode 1.5 - 10.3.5 )

----

That solves the selection problem. I had tested only against a version of my example that allows resizing.