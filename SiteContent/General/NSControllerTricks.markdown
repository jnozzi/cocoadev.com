How do I do X with an General/NSController?
----
How do I clear the data from an General/NSArrayController before I fill it with new data?

the General/NSArrayController inherits from General/NSObjectController, which implements setContent.  If you call

[ myArrayController setContent:nil ]

before filling in the new array, then the previous contents will be removed

--General/AlexBrown
----
How do I designate an action to be performed when I double-click on an General/NSTableView attached to an General/NSController?

A: Correct me if I am missing something, but I beleive you still do it the normal way, target/doubleAction. You have to hook it up manualy in code.

----
How do I use an General/NSOutlineView with an General/NSArrayController?

*It seems that you can't.  I was just looking for the same answer.  See General/OutlineViewBindings.  --Mark*