

I'm trying to make a General/NSPanel as a sheet that appears when a new General/NSWindow is opened. I want this sheet to allow n-number of rows of General/NSControl<nowiki/>s to be generated to collect information from the user. I want each row to contain an General/NSImageView, an General/NSTextField, and an General/NSPopUpButton. Think of how iConquer's ( http://www.kavasoft.com/iConquer/tour/index.php?lang=en&page=1 ) player name collection dialog looks for an example...

I originally thought about using an General/NSTableView, but I couldn't figure out how to make it transparent. (It always drew a solid color behind it.)

I've been trying to use parallel General/NSMatrix<nowiki/>s by option-dragging in General/InterfaceBuilder, and using the General/YSpacing to line the rows up. While I can make multiple General/NSImageView<nowiki/>s and General/NSTextField<nowiki/>s, IB simply beeps when trying to drag the pop-up. At first, I suspected that this class isn't implemented using General/NSCell<nowiki/>s, but both IB's class browser and General/AppKiDo are reporting that there is a General/NSPopUpButtonCell implemented. I also tried using General/NSComboBox<nowiki/>es, which do matrix, but they don't work the same. (They don't support General/MenuSeparators, and they have text selection behavior I don't want.)

I haven't been doing much Cocoa development for long, but this is making me wonder if I have to hard-code some functionality instead of General/GettingItForFree. I've tried searching through Apple's mailing list archives, but only found one other reference to this problem, and nobody provided assistance to the person who brought it up. Anybody successfully solved this problem?

-- General/DLWormwood



----
Actually, you do use General/NSTableView. See this: http://www.stepwise.com/Articles/Technical/2003-12-20.01.html

You'll need to set the General/NSOutlineView's background color to General/[NSColor clearColor], as well as the General/NSTableView (the table view is inside the outline view).

If you don't want to go through this, you'll need to be creating new controls. e.g. General/NSButton *button = General/[[NSButton alloc] initWithFrame:rect]; set all you need (like style, etc.) then, use General/panel contentView] addSubview:button]; to add the control to the view. Remember that the control is not autoreleased, you need to release it on dealloc.

----

The example you linked to seems to be overkill for my needs.  [[NSTableView's cells provide the controls I need without inventing my own General/NSView<nowiki/>s to embed in each row.

Also, did you mean General/NSScrollView rather than General/NSOutlineView for the General/NSTableView's container?  I added the following to my code to try to make the table transparent...

    
[myTable setBackgroundColor:General/[NSColor clearColor]];
General/myTable superview] setBackgroundColor:[[[NSColor clearColor]];
General/myTable superview] display];


...but the table gets a solid black background, just like if I set a 0% opacity color in IB. I also get a compiler warning, but I can insert a typecast or store the superview in a temp variable to get around that. I also have to double-click on the text field to edit it, since I'm working on disabling row selection behavior, which I don't need.

Making a wrapper data source to process an [[NSImage, General/NSString and General/NSNumber (tabled pop-ups need an index, it seems) appears to work otherwise. I'll have to make a dictionary inside the data source or somesuch rather than checking control values by tag at panel close...

-- General/DLWormwood


----

I did mean General/NSScrollView. In Interface Builder, select the Classes tab, then select the table view in your window. General/NSTableView is a view inside a General/NSScrollView. General/NSOutlineView is a subclass of General/NSTableView.

Now it remains a mystery why you got your backround black. Try General/NSScrollView's - (void)setDrawsBackground:(BOOL)flag to NO, so it doesn't draw the background at all (then it should be transparent).

I recommend a little app called Cocoa Browser - you can easily access all classes and see the hierarchy.

-- Charlie

----
Note that     [tableView superview] won't get you the General/NSScrollView, it'll get you the scroll view's General/NSClipView, which is probably why this isn't working. To get your enclosing scroll view, the     -enclosingScrollView method should be helpful.

----

I mentioned that I use General/AppKiDo; it has some of the same functionality.  That's how I caught the General/NSScrollView ref in the first place.

As for the     -enclosingScrollView call, my code is now up to this...

    
General/NSScrollView* tableWrapper;
[myTable setBackgroundColor:General/[NSColor clearColor]];
tableWrapper = [myTable enclosingScrollView];
[tableWrapper setBackgroundColor:General/[NSColor clearColor]];
[tableWrapper setDrawsBackground:NO];
[tableWrapper display];


...and it still draws a solid black background.

For the record, I'm getting this in a minimal skeleton project:

http://web.mac.com/wormwood/General/CocoaDev/General/NSTableViewVersion.gif

While I'm shooting for this, just in case the iConquer reference wasn't clear enough:

http://web.mac.com/wormwood/General/CocoaDev/InterfaceBuilderHard2Version.gif

The above example was hard designed in IB with two rows.

I'm going to experiment with the stuff at General/HelpWithCopyingNSView since this seems to be drifting from the original page topic...

----

Why don't you do what Apple does for predicate editors and create, in a separate nib, an General/NSView with placeholder versions of your controls?  Hook them up to an General/NSOwner outlet using Bindings or however you wish to get data into the view, and then programmatically add and remove instances of this view as subviews of an General/NSScrollView.