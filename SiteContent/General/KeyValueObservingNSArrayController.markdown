Hi,

I have a simple question. I have an General/NSArrayController driving the contents of an General/NSTableView, and I want a separate controller to be informed when the selection in the tableview changes.

At first I used the delegate system and     tableViewSelectionDidChange:(General/NSNotification*)notification.

However, I thought I'd try and use key value observing to do the same thing a different way. I set up my KVO in the following way (my 'normal' Controller observing my General/NSArrayController):     [arrayController addObserver:self forKeyPath:@"selection" options:General/NSKeyValueObservingOptionOld context:NULL];.

It doesn't work however. I think I have the '    forKeyPath:' part wrong. Where can I find the keys which I can use to observe for classes I didn't create (i.e. the framework classes, such as General/NSArrayController)? Do I look through the header files?

Thanks for moving me in the right direction on this one... any assistance is much appreciated!

*What are you trying to observe, exactly? What do you intend to do once changes are made to the array controller you want to observe?*

I want to observe the state of the selection, so that when it's changed I can change the Predicate Filter for a different Array Controller, thus achieving a General/SmartGroup kind of set-up. I don't care at all what it's changed to or from, I just want to be notified when the selection of that General/NSArrayController has changed at all.

----

How about observing "selectionIndexes" with options "General/NSKeyValueObservingOptionOld | General/NSKeyValueObservingOptionNew"? If I recall correctly, Mmalc's graphics bindings example uses this binding to track selection changes between a table view and his custom "circles view" and things appear to remain in sync there. 

Mmalc's is probably a useful bit of code to scan for the details of interfacing with an General/NSArrayController...

Update: here's a link to Mmalc's page where you'll find his graphic bindings example:

http://homepage.mac.com/mmalc/General/CocoaExamples/controllers.html

----

Thanks for the help, that's an excellent resource.

I'm having trouble setting the Filter Predicate of an General/NSArrayController in code. I set the filter predicte to something (say 'title == 'something*) and that works great. But then if i then go and (in a different part of the interface) change an entitie's title attribute to be 'something' the tableview doesn't update :(

Any ideas? Do I have to force a refresh somewhere?

... the behaviour is perfect when I set the filter predicate in Interface Builder. ... why does it not recognize when an item is changed when I change the filter predicate in code??

I am doing the following:

    [filterController setFilterPredicate:General/[NSPredicate predicateWithFormat:@"(title == \"foo\")"]];

What's wrong here??

Thanks!

*Try sending your controller a     -fetch: ... you are correct in your guess that you must refresh when objects are changed. Forcing your controller to fetch will update its contents according to its filter predicate.*