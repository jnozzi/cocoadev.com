I am trying to use General/NSTreeController with a General/NSBrowser. Thus far, the General/NSBrowser is being populated just fine with the proper data from the General/NSTreeController. The only problem I am having is when I select something in the General/NSBrowser, my text controls (linked to the General/NSTreeController/selection) are not being updated. I can remove the General/NSBrowser and insert a General/NSOutlineView and when I make a selection there, all works great, controls are updated, etc... But not with a General/NSBrowser. I can somewhat understand because a General/NSBrowser has multiple items selected at all times, well most of the time, in different columns.

But I cannot figure out how to handle the situation. Can anyone offer a suggestion or point me in the right direction? As I said, the General/NSBrowser is being populated correctly but it does not seem to be sending the current selection on to the General/NSTreeController.

Thanks!

----

Thanks to the guys on irc.freenode.net#macdev ... I found I was not binding selectionIndexPaths in the General/NSBrowser. Binding that to General/NSTreeController to selectionIndexPaths. That made all work, exactly how it should.