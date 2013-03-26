Describe [[TableColumnHeaderRightClick]] here.

im trying to get a contextual menu to pop-up when a column header is right clicked to add and remove columns ala itunes. i've already added view options where you can add and remove columns via checkboxes (like itunes) but i also want to have right click work in the column header and can't figure it out for the life of me. the tables themselves have contextual menus so i already have that taken care of (thanks to alot of the information on cocoadev :) ) any help would be super appreciated.

----

An [[NSTableHeaderView]] is simply a subclass of [[NSView]].  Subclass it and add your own methods for right clicking such as popping up a contextual menu (lots of information on this site, especially useful may be the [[RightClickSelectInTableView]] page).  Then use [[NSTableView]]'s setHeaderView: method to add it.

----

This can be implemented this by doing the following:

The window controller has the following in the @interface of the .h-file:

<code>
[[IBOutlet]] [[NSTableView]] ''theTable;
[[IBOutlet]] [[NSMenu]] ''columnsMenu;
[[IBOutlet]] [[NSTableColumn]] ''tcColumnOne;
[[IBOutlet]] [[NSTableColumn]] ''tcColumnTwo;
[[IBOutlet]] [[NSTableColumn]] ''tcColumnThree;
</code>

In the corresponding .nib-file, an [[NSMenu]] needs to be created with one menu item for each column in the table. These should have their tag set to 0, 1, 2 etc.

The variable columnsMenu should be connected to the created [[NSMenu]], in the controller. Each of the above [[IBOutlets]] should be connected to their corresponding [[NSTableColumns]]. theTable should be connected to the table containing the columns.

Then create a method in the controller:

<code>
- ([[IBAction]])toggleColumn:(id)sender
{
    [[NSTableColumn]] ''tc = nil;

    switch([sender tag])
    {
        case 0: tc = tcColumnOne; break;
        case 1: tc = tcColumnTwo; break;
        case 2: tc = tcColumnThree; break;
    }

    if(tc == nil)
        return;
    
    if([sender state] == [[NSOffState]])
    {
        [sender setState:[[NSOnState]]];
        [theTable addTableColumn:tc];
    }
    else
    {
        [sender setState:[[NSOffState]]];
        [theTable removeTableColumn:tc];
    }
}
</code>

"theTable" should be the variable name of your table. Then connect each menu item in the created [[NSMenu]] to the toggleColumn method, as action.

And to complete this, add the following code to the awakeFromNib method in your controller:

<code>
- (void)awakeFromNib
{
    [tcColumnOne retain];
    [tcColumnTwo retain];
    [tcColumnThree retain];
    
    [[NSArray]] ''tcs = [theTable tableColumns];
    [[NSEnumerator]] ''e = [tcs objectEnumerator];
    [[NSTableColumn]] ''tc;
    while((tc = [e nextObject]) != nil)
    {
        if(tc == tcColumnOne)
            [[columnsMenu itemWithTag:0] setState:[[NSOnState]]];
        else if(tc == tcColumnTwo)
            [[columnsMenu itemWithTag:1] setState:[[NSOnState]]];
        else if(tc == tcColumnThree)
            [[columnsMenu itemWithTag:2] setState:[[NSOnState]]];
    }
    
    [[theTable headerView] setMenu:columnsMenu];
}
</code>

And don't forget to release the columns in the dealloc method:

<code>
- (void)dealloc
{
    [tcColumnOne release];
    [tcColumnTwo release];
    [tcColumnThree release];
    
    [super dealloc];
}
</code>

I may have missed something, but try that out.