

Hi,

I've tried to put General/NSView in General/NSTableView, but I have no idea where to start. I was looking into General/NSCell, but found nothing useful there. Could anybody point me to the right direction?

Thanks

What are you trying to do? General/NSTableView does not require an General/NSView to work. 

----

If I had to guess, I'd say he's trying to put a color well or progress bar in a table. Neither of those have an General/NSCell form.

----

Hello, I am not the original poster, but have resurrected this discussion on Christmas day..

I would like some help, if possible, in placing a progress bar in an General/NSTableView row. What would also be rather useful is being able to put two lines of text in that same row also (with different font sizes for the two lines).

Now I have no idea how to accomplish this, have taken a look at Cells, but there is none for progressIndicator, yet I have seen this done so many times. Please tell me I do not have to jump through any highly complex hoops! 

Thanks!

----

Well, you might not have to jump through hoops if you've got a little cash to lay down. There are libraries out there that provide an General/NSProgressIndicator cell. Otherwise, sorry, I've got bad news for you.

Most of the progress bars you see in a table are faked. They are either manually drawn when the progress updates, or a timer updates each of the cells' images and redraws the table.


----
First, excuse me, my English is poor.
I have a sample.
----
    
// General/ProgressCell.h

#import <General/AppKit/Appkit.h>

@interface General/ProgressCell : General/NSCell
{
    General/NSProgressIndicator *progressIndicator;
}

- (id)initProgressCell : (General/NSProgressIndicator *)aProgressIndicator;

@end

----
    
// General/ProgressCell.m

#import "General/ProgressCell.h"

@implementation General/ProgressCell

- (id)initProgressCell : (General/NSProgressIndicator *)aProgressIndicator
{
    if( self = [ super initImageCell:nil ] )
    {
        progressIndicator = [ aProgressIndicator retain ];
    }

    return self;
}

- copyWithZone : (General/NSZone *)zone
{
    General/ProgressCell *cell = (General/ProgressCell *)[ super copyWithZone:zone ];
    cell->progressIndicator = [ progressIndicator retain ];
    return cell;
}

- (void)dealloc
{
    [ progressIndicator release ];
    [ super dealloc ];
}

- (void)setProgressIndicator : (General/NSProgressIndicator *)aProgressIndicator
{
    if( aProgressIndicator )
    {
        [ progressIndicator release ];
        progressIndicator = [ aProgressIndicator retain ];
    }
}

///////////////////////////////////////////////////////////////////////
//  If you need, you can add - (General/NSProgressIndicator*) progressIndicator;
///////////////////////////////////////////////////////////////////////

- (void)drawInteriorWithFrame : (General/NSRect)cellFrame inView : (General/NSView *)controlView
{
    if( [ progressIndicator superview ] == nil )
    {
        [ controlView addSubview:progressIndicator ];
    }
    [ progressIndicator setFrame:cellFrame ];
}


OK, now, you can add instance of General/ProgressCell to tableColumn.
Suppose that "progress" is your tableColumn identifier, mainTableView is the General/NSTableView
in The "IB", so we can do this:
    
    General/NSTableColumn *progColumn;
    progColumn = [ [ mainTableView tableColumnWithIdentifier:@"progress" ];
    [ progColumn setDataCell:[ [ General/ProgressCell alloc ] init ];

----

I'd like to add a precision about the previous code. It's perhaps obvious for everyone, but if you don't know where, when and how to modify the displayed General/NSProgressIndicator, check this article out : General/NSTableViewImagesAndText

-- Mathieu Godart

----

Now, I have a problem. I want to set the progressIndicator size. Just like set it samll in "IB".
In "IB", you set it small changed the progressIndicator' height. In Cocoa Documents, description
like this:

    General/NSProgressIndicator defines the following constants to use as the height of your progress indicator:

    *Constant----------------->Height in Pixels 
    *General/NSProgressIndicatorPreferredThickness------------------>14 
    *General/NSProgressIndicatorPreferredSmallThickness------------->10 
    *General/NSProgressIndicatorPreferredLargeThickness------------->18 
    *General/NSProgressIndicatorPreferredAquaThickness-------------->12 
%

but I don't know how to use this, is there anyone know it?
Thank you very much!

----

Just call setControlSize: method on your General/NSProgressIndicator (see General/NSControlSize in General/TypesAndConstants at Apple's). Here is an example:

[myProgIndic setControlSize:General/NSSmallControlSize];

-- General/MathieuGodart

I've tried the above code yesterday and it contains some mistakes and doesn't explain how it works and what to do when the General/NSTableView needs data. I will try to find the time to explain it and put a modifier code (allowing to change the size...) quickly, but if someone really needs it, juste send me a mail and I'll explain that: mathieu AT mac4ever DOOOT com

-- General/MathieuGodart

----

Also see http://www.joar.com/code/ for a nice treatment with full sample code.

----
----

The example at joar isn't that great. It only shows an indeterminate progress indicator. For those who actually want a download kind of thing, use the code above, but replace the draw method with this one:

    
- (void)drawInteriorWithFrame:(General/NSRect)cellFrame inView:(General/NSView *)controlView
{
    if ([progressIndicator superview] == nil) {
        [controlView addSubview:progressIndicator];
    }
	
    [progressIndicator setDoubleValue:General/self objectValue] doubleValue;
    [progressIndicator setFrame:cellFrame];
}



And then use this code in the awakeFromNib where the table is:

    
// Transfer Table
General/NSProgressIndicator * progress = General/[[[NSProgressIndicator alloc] init] autorelease];
[progress setControlSize:General/NSSmallControlSize];
[progress setIndeterminate:NO];
General/transferTable tableColumnWithIdentifier:@"Progress"] setDataCell:[[[[ProgressCell alloc] initProgressCell:progress]];



In the table's objectValueForTableColumn method you should return an General/NSNumber from 0 to 100 (a percentage) and then you're done. It works. 

Have fun -- Seth W.

*The problem with your code (that I can see) is that the progress bar is only updated when objectValueForTableColumn method is called.  This is pretty much only called on table reload data, or when the display needs to be updated.  So if the window with the tableview is in the fore ground the whole time, it will most likely not update.*

*-Vinay*

Not really, because the progress indicator is set as a subview of the tableview, it gets all the privaleges of being in the view heirarchy, including corectly redrawing itself and being clipped when the tableview is scrolled elsewhere.

*Oh it's drawn correctly.  but if the display isn't changed..i.e. the view doesn't need to redraw itself, then it won't redraw, and if my *download* has updated in the meantime, the progress won't show up.*


----

I think I found a much easier way to do this that actually works correctly too (the above code has issues with removing the view when the row is removed from the table)...

    
- (void)drawInteriorWithFrame:(General/NSRect)cellFrame inView:(General/NSView *)controlView
{
	General/NSProgressIndicator * progressIndicator = General/self objectValue] objectForKey:@"[[NSProgressIndicator"];
	General/NSNumber * progress = General/self objectValue] objectForKey:@"Progress"];
	
	if ([progressIndicator superview] == nil) {
		[controlView addSubview:progressIndicator];
	}
	
	[progressIndicator setDoubleValue:[progress doubleValue;
	[progressIndicator setFrame:cellFrame];
}


If your objectValue data source method returns a dictionary that contains the General/NSNumber for the progress value and "it's own" General/NSProgressIndicator which is removed from the view when you remove the row object from the array in your data source, then it all works just dandy!!!

Much easier to deal with. Sure there are more views, but they're so tiny comparitively speaking, who cares?

-- Seth W


----

I found a lot of the code above a bit complex and verbose, and have come up with a solution using Core Data that is much more compact. You can find it on my blog (http://www.macanics.net/blog/?p=25).


Drew General/McCormack

----
Drew: I used your solution from your blog and it works great! Except when I try to remove it again...

My commonAwake looks like this:
    
- (void)commonAwake {
    General/NSView *newView = General/[[NSView alloc] initWithFrame:General/NSMakeRect(0, 0, 125, 39)];
		
	// General/NameField
	General/NSTextField *nameField = General/[[NSTextField alloc] initWithFrame:General/NSMakeRect(39, 20, 80, 14)];
	[nameField setBordered:NO];
	[nameField setDrawsBackground:NO];
	[nameField setEnabled:NO];
	[nameField bind:@"stringValue" toObject:self
		withKeyPath:@"name" options:nil];
	[newView addSubview:nameField];
	
	// General/StatusField
	General/NSTextField *statusField = General/[[NSTextField alloc] initWithFrame:General/NSMakeRect(39, 6, 79, 11)];
	[statusField setFont:General/[NSFont systemFontOfSize:9.0]];
	[statusField setBordered:NO];
	[statusField setDrawsBackground:NO];
	[statusField setEnabled:NO];
	[statusField bind:@"stringValue" toObject:self
		withKeyPath:@"status" options:nil];
	[newView addSubview:statusField];

    [self setUserView:newView];
	[newView release];
}


I get this error: *** Assertion failure in -General/[NSTextFieldCell _objectValue:forString:errorDescription:], General/AppKit.subproj/General/NSCell.m:1298

Anyone who knows what could be wrong?
Thx

----
That assertion failure is an exception, see General/DebuggingTechniques for how to find out where the exception is being thrown s oyou can find the culprit line.

----
I'm having another problem with the same code...
My view doesn't disappear when the object is removed. The cell vanishes and it isn't clickable any longer but my text and images still gets drawn.
Any suggestions?

----

Here is the results of my hacking up of all the suggestions so far. It is working nicely.

First, start off with General/ProgressCell.h
    
#import &lt;General/AppKit/Appkit.h&gt;

// Some handy definitions.
#define kControl @"control"

// An General/NSCell that contains a progress indicator.
@interface General/ProgressCell : General/NSCell
  {
  }

// Initialize.
- (id) init;

// Draw the cell.
- (void) drawInteriorWithFrame : (General/NSRect) cellFrame 
  inView: (General/NSView *) controlView;

@end


Next, add General/ProgressCell.mm (yeah, that's .mm - Objective-C++ baby!)
    
#import "General/ProgressCell.h"

@implementation General/ProgressCell

// Constructor.
- (id) init
  {
  self = [super initImageCell: nil];
  
  return self;
  }

// Draw the cell.
- (void) drawInteriorWithFrame : (General/NSRect) cellFrame 
  inView: (General/NSView *) controlView
  {
  General/NSProgressIndicator * indicator = 
    General/self objectValue] objectForKey: kControl];
  
  // Removing subviews is tricky, if the progress bar gets removed when it gets
  // 100%, it could get re-created on resize. This is perhaps kludgy and should
  // be fixed.
  if([indicator doubleValue] &lt; 100)
    {
    if(![indicator superview])
      [controlView addSubview: indicator];
	
    // Make the indicator a bit smaller. The setControlSize method
    // doesn't work in this scenario.
    cellFrame.origin.y += cellFrame.size.height / 3;
    cellFrame.size.height /= 1.5;
    
    [indicator setFrame: cellFrame];
    }
  }
  
@end


Now to use it, create an [[NSTableView. Add a column for the progress bars. Drag an General/NSImageCell into that column to turn it into an image column. Don't forget to setup your data source and maybe delegate.

In your controller's awakeFromNib, do this:
    
General/myTableView tableColumnWithIdentifier: kProgress] 
  setDataCell: [[[[ProgressCell alloc] init]];


I've got some handy macros for my column identifiers. They are:
    
// Some handy General/NSDictionary keys.
#define kPath      @"path"
#define kName      @"name"
#define kIcon      @"icon"
#define kProgress  @"progress"


My data source methods use an General/NSMutableArray. Here is the code:
    
// Get the number of rows in the table.
- (int) numberOfRowsInTableView: (General/NSTableView *) aTableView
  {
  return [myData count];
  }

// Get a table item value.
- (id) tableView: (General/NSTableView *) aTableView
    objectValueForTableColumn: (General/NSTableColumn *) aTableColumn
    row: (int) rowIndex
  {
  // Use those macros above for column identifiers.
  return General/myData objectAtIndex: rowIndex] 
    objectForKey: [aTableColumn identifier;
  }


Now, to put something in myData so it will get displayed in the table, do the following:
    
// This icon stuff is just for a file icon. It doesn't have anything
// to do with the progress indicator. No point in removing it.

// See if there is an icon for this file.
General/NSImage * icon = General/[[NSWorkspace sharedWorkspace] iconForFile: path];
    
if(!icon)
    
  // No icon for actual file, try the extension.
  icon = General/[[NSWorkspace sharedWorkspace] iconForFileType: 
    [path pathExtension]];
     
General/NSProgressIndicator * progress = 
  General/[[[NSProgressIndicator alloc] init] autorelease];

// Unless you want it indeterminate, of course.  
[progress setIndeterminate: NO];

// This is an important plot point. You can't just put the control inside a dictionary.
// It complains about copyWithZone or something. You have to put the control inside
// a dictionary.
General/NSDictionary * progressData =
  General/[NSDictionary dictionaryWithObjectsAndKeys:
    progress, kControl,
    0];

// This dictionary is optional. You could do this differently.      
[myData addObject:     
  General/[NSDictionary dictionaryWithObjectsAndKeys:
    path, kPath,
    [path lastPathComponent], kName, 
    icon, kIcon, 
    progressData, kProgress,
    0]];

// Don't forget!  
[myTableView reloadData];


To update the control, use this snippet:
    
// Get the control.
General/NSProgressIndicator * progress = 
  General/[myData objectAtIndex: i] objectForKey: kProgress] 
    objectForKey: kControl];

[progress setDoubleValue: newValue];


Finally, to remove a row, there is an extra step:
    
// Get the control.
[[NSProgressIndicator * progress = 
  [[[myData objectAtIndex: i] objectForKey: kProgress] 
    objectForKey: kControl];
  
[progress removeFromSuperview];
  
// Now remove the row.    
[myData removeObjectAtIndex: i];


I haven't done any checking for memory leaks. Please comment if there are any. This isn't completely finished, but if I don't post it now, I won't ever get around to it.