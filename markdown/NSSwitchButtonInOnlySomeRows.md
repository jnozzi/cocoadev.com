I wish to show some check boxes in some of my General/NSOutlineView's rows. It is no problem to set an General/NSButtonCell for the column, but then all the rows get a check box.

How do I set it only for some of the rows? I tried to implement outlineView:willDisplayCell:forTableColumn:item:, but I do not know which button kind I should set, not to mention that my cell seems to be largely unaffected by setButtonType: and even setType:General/NSNullCellType does not change the appearance of my cells.

----

I did this a while back, though not for an General/NSOutlineView, but rather for an General/NSTableView. I would assume that what worked for a table ought to work for an outline view since it's just a subclass of General/NSTableView.

Anyway, what you need to do is subclass General/NSTableColumn, and override - (id)dataCellForRow:(int)row . Then make your table use that column.
What I did was to have my subclass forward that method call to my table data source, so I could return a slider cell or checkbox cell according to my needs. 

I imagine there's a better way, but that worked for me.

--General/ShamylZakariya

----

Ahh, thanks a lot! It's actually better than my previous solution, since my General/NSTableColumn subclass can be set from within General/InterfaceBuilder :)

For the records, the code is to be found below -- in General/InterfaceBuilder select the table column and go the the Custom Class page of the Info Panel and select the General/SwitchButtonTableColumn class, and in your datasource, implement outlineView:canItemBeDisabled: to return either YES or NO.

**Two more questions: Both General/ProjectBuilder and iTunes use checkmarks smaller than what the system has to offer. Are these available for non-Apple programmers (perhaps they will in Panther with their new tiny size)? and, iTunes allow the user to toggle the checkmark without the item going active (in PB it does go active, but the file is not loaded, as it is when one performs a normal click), how is this possible? the clickedColumn selector is only valid within my target method, which cannot abort row selection AFAIK.**

----
    
@interface General/NSObject (General/SwitchButtonTableColumnDataSource)
- (BOOL)outlineView:(General/NSOutlineView*)outlineView canItemBeDisabled:(id)item;
@end

@interface General/SwitchButtonTableColumn : General/NSTableColumn
{
   General/NSButtonCell* General/SwitchButtonCell;
}
@end

@implementation General/SwitchButtonTableColumn

- (id)switchButtonCell
{
   if(!General/SwitchButtonCell)
   {
      General/SwitchButtonCell = General/[[NSButtonCell alloc] initTextCell:@""];
      General/[SwitchButtonCell setEditable:YES];
      General/[SwitchButtonCell setButtonType:General/NSSwitchButton];
      General/[SwitchButtonCell setControlSize:General/NSSmallControlSize];
      General/[SwitchButtonCell setImagePosition:General/NSImageOnly];
   }
   return General/SwitchButtonCell;
}

- (void)dealloc
{
   if(General/SwitchButtonCell)
      General/[SwitchButtonCell release];
   [super release];
}

- (id)dataCellForRow:(int)row
{
   id outlineView = [self tableView];
   id item = [outlineView itemAtRow:row];
   id datasource = [outlineView dataSource];
   BOOL canBeDisabled = [datasource outlineView:outlineView canItemBeDisabled:item];
   return canBeDisabled ? [self switchButtonCell] : [self dataCell];
}

@end


----

I can answer your first question, about control size. There are two constants in the documentation for General/NSCell -- General/NSRegularControlSize and General/NSSmallControlSize and you use this by calling [someCell setControlSize: General/NSSmallControlSize]. 

On the other hand, I have *no* idea how to handle focus changes. I imagine you'll have to do something in the delegate to determine wether the click was on the line itself, or on the cell, and reject or accept selection of the line accordingly.

--General/ShamylZakariya