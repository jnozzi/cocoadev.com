Hi,

does anyone have an example of how to use General/NSComboBoxCell in an General/NSTableView column? A sample project would be preferred but sample code would be much appreciated too. http://goo.gl/General/OeSCu

Thanks for your help.

----

It took me a little while and some experimentation to understand how it works. I could not find a working sample code at the time so I will post one below. You need understand the following in order to use General/NSComboBoxCell and General/NSTableView:


* obviously in interface builder you must drop the     General/NSComboBoxCell control onto the table column... (from the data views palette);
* in interface builder, the column now gives you access to two sets of properties: the column itself (name, identifier, etc.) and the     General/NSComboBoxCell. You access the later by clicking on the little triangle in the column header;
* the value you see in the table comes from     tableView:objectValueForTableColumn:row:, not from the combo box, so you need to implement this method in the table data source;
* when the user selects an entry in the combo box, the box posts a     tableView:setObjectValue:forTableColumn:row: message to the table data source with the user selection, so you must implement this method too. Record the user selection and return it through     tableView:objectValueForTableColumn:row:;
* last but not least, the table view uses only one **shared**     General/NSComboBoxCell for every line, so if you need different values depending on the line on the line you must implement     tableView:willDisplayCell:forTableColumn:row: as well and update the list entries.


In other words, there are two controls (table view and combo box cell), each with a specific role. The table view displays the value and records the user selection (the last bit is somewhat counter-intuitive but it makes sense given how the table view works). The combo box cell displays the list of choices but it does **not** record the selection.

Here's the promised code sample. You will need to create a project (sorry, can't upload a project right now) and do some of the work in interface builder yourself:


* add a table with two columns with the following identifier (important):     pos and     combo;
* drop the     General/NSComboBoxCell on the second column (    combo);
* create the class     C<nowiki/>omboBoxDS as a subclass of     General/NSObject;
* double-click the table and open the info palette, set     C<nowiki/>omboBoxDS as the table data source **and** delegate (important);
* double-click the combo column, click the triangle in the column header to open the     General/NSComboBoxCell info;
* select "Uses Data Source" in the attributes (important);
* you may check the "Editable" property;
* set     C<nowiki/>omboBoxDS as the box data source;
* create the files for     C<nowiki/>omboBoxDS;
* back to Xcode, copy/paste the following code into the class (the .m file, you don't need to edit the generated header).


    #import "C<nowiki/>omboBoxDS.h"

/* for this example to work, the class must be set as:
   - data source for the table view
   - data source for the combo box
   - delegate for the table view */

@implementation C<nowiki/>omboBoxDS

/* create, randomly initialize and release the data structure for the data source
   we'll store the data in an array, each line is a dictionary with 3 entries:
   - pos contains the line number (just an ordinary column)
   - combo contains the current selection for the combo column
   - combov contains an array with the values for the list */

-(id)init
{
   self = [super init];
   if(self)
      records = General/[[NSMutableArray arrayWithCapacity:25] retain];
   return self;
}

-(void)dealloc
{
   [records release];
   [super dealloc];
}

-(void)awakeFromNib
{
   srand(General/[[NSDate date] timeIntervalSince1970]);
   int l = rand()/(int)(((unsigned)RAND_MAX + 1) / 25);
   int i, j;
   for(i = 0;i < l;i++)
   {
      int r = rand()/(int)(((unsigned)RAND_MAX + 1) / 15) + 1;
      General/NSMutableArray *list = General/[NSMutableArray arrayWithCapacity:r];
      for(j = 0;j < r;j++)
         [list addObject:General/[NSString stringWithFormat:@"data %d from line %d",j,i]];
      General/NSMutableDictionary *dic = General/[NSMutableDictionary dictionaryWithCapacity:3];
      [dic setObject:General/[NSNumber numberWithInt:i] forKey:@"pos"];
      [dic setObject:list forKey:@"combov"];
      [dic setObject:[list objectAtIndex:0] forKey:@"combo"];
      [records addObject:dic];
   }
}

/* data source for the General/NSComboBoxCell
   it reads the data from the representedObject
   the cell is responsible to display and manage the list of options
   (we set representedObject in tableView:willDisplayCell:forTableColumn:row:)
   this is optional, the alternative is to enter a list of values in interface builder */

-(id)comboBoxCell:(General/NSComboBoxCell*)cell objectValueForItemAtIndex:(int)index
{
   General/NSArray *values = [cell representedObject];
   if(values == nil)
      return @"";
   else
      return [values objectAtIndex:index];
}

-(int)numberOfItemsInComboBoxCell:(General/NSComboBoxCell*)cell
{
   General/NSArray *values = [cell representedObject];
   if(values == nil)
      return 0;
   else
      return [values count];
}

-(int)comboBoxCell:(General/NSComboBoxCell*)cell indexOfItemWithStringValue:(General/NSString*)st
{
   General/NSArray *values = [cell representedObject];
   if(values == nil)
      return General/NSNotFound;
   else
      return [values indexOfObject:st];
}

/* data source for the General/NSTableView
   the table is responsible to display and record the user selection
   (as opposed to the list of choices)
   this is required */

-(int)numberOfRowsInTableView:(General/NSTableView*)tableView
{
   return [records count];
}

-(id)tableView:(General/NSTableView*)tableView objectValueForTableColumn:(General/NSTableColumn*)tableColumn row:(int)index
{
   return General/records objectAtIndex:index] objectForKey:[tableColumn identifier;
}

-(void)tableView:(General/NSTableView*)tableView setObjectValue:(id)value forTableColumn:(General/NSTableColumn*)tableColumn row:(int)index
{
   if(nil == value)
      value = @"";
   if(General/tableColumn identifier] isEqual:@"combo"])
      [[records objectAtIndex:index] setObject:value forKey:@"combo"];
}

/* delegate for the [[NSTableView
   since there's only one combo box for all the lines, we need to populate it with the proper
   values for the line as set its selection, etc.
   this is optional, the alternative is to set a list of values in interface builder  */

-(void)tableView:(General/NSTableView*)tableView willDisplayCell:(id)cell forTableColumn:(General/NSTableColumn*)tableColumn row:(int)index
{
   if(General/tableColumn identifier] isEqual:@"combo"] && [cell isKindOfClass:[[[NSComboBoxCell class]])
   {
      General/NSDictionary *dic = [records objectAtIndex:index];
      [cell setRepresentedObject:[dic objectForKey:@"combov"]];
      [cell reloadData];
      [cell selectItemAtIndex:[self comboBoxCell:cell indexOfItemWithStringValue:[dic objectForKey:@"combo"]]];
      [cell setObjectValue:[dic objectForKey:@"combo"]];
   }
}

@end

Note that the combo box data source and the table delegate are not required if the list of values is identical for every line. The indirection is only required if you need to set the list of values programmatically. The table data source is always required.

For simplicity, I have only one class that implements the two data sources and the delegate. For more complex applications, you may want to spread the code over multiple classes.

Let me know if it helps.

General/BenoitMarchal


----

Question: Do you have to call selectItemAtIndex from within willDisplayCell? I ask, because willDisplayCell gets called very often, once for every cell. I'd rather only call selectItemAtIndex when the cell is being clicked upon, if possible.

----

That's my understanding.

Obviously it gets called once for every cell because you're in charge of displaying the cell.
You'd need a mechanism to recognize whether the call is to display a list or to display just the value in order to optimize. I don't think Cocoa passes a flag or something you could use to test in which case you are but I'd love to be proven wrong. Please post if you find how to optimize.

General/BenoitMarchal

----

If the comboboxcell in question will have only one instance, the fast way is to just record the current row and combo box in willDisplayCell.  Then in the combobox delegate functions for numberOfItems and objectValueForItemAtIndex refer to the externally saved row when you decide what to return.  That way you only reload the combobox choices when the box is about to display its contents.

General/McBane