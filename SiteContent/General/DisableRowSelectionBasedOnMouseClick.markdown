I wish to have one column of my outline view dedicated to switch buttons, and when this column is clicked, the item should NOT be selected (as in iTunes), unfortunately I have not found a way to do it.

I tried this hacky solution, but my outlineView:shouldSelectItem: selector is called twice for each mouse down, causing the item to be toggled twice. Any help?
    
- (BOOL)outlineView:(General/NSOutlineView *)outlineView shouldSelectItem:(id)item
{
   General/NSEvent *theEvent = General/[NSApp currentEvent];
   if([theEvent type] == General/NSLeftMouseDown)
   {
      General/NSPoint p = [outlineView convertPoint:[theEvent locationInWindow] fromView:nil];
      General/NSRect r = [outlineView rectOfColumn:0];
      if(General/NSPointInRect(p, r))
      {
         [item setEnabled:([item enabled] ? NO : YES)];
         [outlineView reloadItem:item];
         return NO;
      }
   }
   return YES;
}
