I'm trying to subclass [[NSCell]] to get functionality similar to that of the cells in the Property List Editor utility, where most of the time the cell is a text field, but can also turn into an [[NSPopUpButton]](Cell). I've almost got it working, but it doesn't quite work properly.

Here's the code:
<code>
@interface [[NSCellSubclass]] : [[NSTextFieldCell]]
{
    BOOL displayPopUpButton;
    [[NSPopUpButton]] ''control;
}
- (void)setDisplaysPopUpButton:(BOOL)flag;

@implementation [[NSCellSubclass]]

- (void)dealloc
{
    if (displayPopUpButton)
    {
        [control removeFromSuperview];
        [control release];
    }
    [super dealloc];
}

- (void) setDisplaysPopUpButton:(BOOL)flag
{
    displayPopUpButton = flag;
}

- (void)drawWithFrame:([[NSRect]])cellFrame inView:([[NSView]] '')controlView
{
    if (displayPopUpButton)
    {
        control = [[[[NSPopUpButton]] alloc] initWithFrame:cellFrame];
        [control setBordered:NO];
        [control setFont:[[[NSFont]] fontWithName:@"Lucida Grande" size:11]];
        [control setTarget:[self target]];
        [control setAction:[self action]];
        [control addItemsWithTitles:[[[NSArray]] arrayWithObjects:@"Yes", @"No", nil]];
        
        [controlView addSubview:control];
    }
    else
    {
        [super drawWithFrame:cellFrame inView:controlView];
    }
}

@end
</code>

This works for the most part, but if you try it, you'll notice that the control will do some strange drawing things when it's trying to act as a pop-up button, such as draw over itself, and not go away when it's told to start acting like a text field again.

Any help would be great :-D

-- [[KentSutherland]]

----

The reason for the drawing problems is that you're creating a new [[NSPopUpButton]] every time you draw (and losing your reference to the old one), so you're creating stacks of popup buttons drawingon top of each other.  More fundamentally, using a view within a cell is a bad idea as some classes (like table and outline views) reuse cells to draw in several different locations; I'd advise just deciding whether you want a cell to be a text field or popup button cell and creating the appropriate cell type at run time.  Alternatively, you can use an [[NSProxy]] subclass to forward messages to an appropriate cell instance; the [[ForwardInvocation]] sample project /Developer/Examples/Foundation demonstrates how to set this up.  -- Bo

----

If I were going to create a new cell at runtime each time, wouldn't that slow things down a lot? And even if I were going to do that, how does one make a new cell and have the outline view display it?

----

To have individual rows use different cells in a table or outline view, you have to subclass [[NSTableColumn]] and override the method -dataCellForRow:.  Since you're subclassing the column anyway,you could have it create one cell instance for each ''type'' of cell (i.e. one [[NSTextFieldCell]] and one [[NSPopUpButtonCell]]) at initialization time and then have it return the appropriate instance for each row.  That way you won't be creating a bunch of cells, just 2.  -- Bo

----

Subclassing [[NSTableColumn]] and dataCellForRow worked great, thanks :) -- [[KentSutherland]]