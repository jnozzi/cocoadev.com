Is there anyway to show and hide a specific tab that is part of an General/NSTabView?

----

One way you could do it would be to remove the General/NSTabViewItem from the General/NSTabView when you want to hide it, then reinsert it when you want to unhide it.  If you do this, you'll have to make sure the General/NSTabViewItem is retained by something besides the General/NSTabView so that it doesn't go to the great bit bucket in the sky when it gets yanked out.

ie, let's say you want to "hide" tab 3 from a tab view with 5 tabs.

    
General/NSTabView *aTabViewWith5Items;  // already initialized, populated, etc.
General/NSTabViewItem *holderForTabItem3;
holderForTabItem3 = [[aTabViewWith5Items tabViewItemAtIndex:2] retain];//index starts at 0
[aTabViewWith5Items removeTabViewItem:holderForTabItem3];
// do whatever you want to do with tab hidden
// ....
// finish doing whatever you wanted to do with tab hidden
[aTabViewWith5Items insertTabViewItem:holderForTabItem3 atIndex:2];
[holderForTabItem3 release];
