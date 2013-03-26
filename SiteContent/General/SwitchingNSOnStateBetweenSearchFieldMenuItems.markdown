

Hi!


I've been working on a browser, and recently when implementing a search menu I ran into trouble. In providing users with a choice of search engine to use, I need to changed the currently "selected" option in my [[NSSearchField]]. I tried doing this with the following code, but when I try it, there is no reaction from the menu items at all.


<code>
- ([[IBAction]])setSearchEngine:(id)sender;
{
	[[NSUserDefaults]] ''defaults;
	defaults = [[[NSUserDefaults]] standardUserDefaults];
	
	if ([[sender title] isEqualToString: @"Google"])
	{
		[defaults setInteger:1 forKey: @"searchEngine"];
		[yahooItem setState: [[NSOffState]]];
		[googleItem setState: [[NSOnState]]];
		
	} else if ([[sender title] isEqualToString: @"Yahoo"])
	{
		[defaults setInteger:2 forKey: @"searchEngine"];
		[googleItem setState: [[NSOffState]]];
		[yahooItem setState: [[NSOnState]]];
	
}}
</code>

What's wrong? I'm sure it's something blatantly obvious, but I just can't put my finger on it. 
----
Are you sure that <code>sender</code> is the object you're assuming it to be?
----

Hmm... It should be the menu item the user clicked on, but I suppose not. Any other way to tell what item was selected?

----
This is a common problem people have with [[NSSearchField]]. When you set up your [[NSSearchField]], you set its menu either in IB or through code with setSearchMenuTemplate. Either way, [[NSSearchFieldCell]] takes that [[NSMenu]] as its menu template, not the actual [[NSMenu]] that is to be displayed.

So, assuming that googleItem and yahooItem are [[NSMenuItems]] in the menu template, changes made to them will have no effect on the [[NSSearchField]] because it's displaying a copy of that template made back when you last set it.

What you need to do is add [[theSearchField cell] setSearchMenuTemplate:searchMenu] at the end of your code to tell the [[NSSearchField]] to base its menu on your updated one.

There was a thread about this on the Cocoa-Dev mailing list here http://www.cocoabuilder.com/archive/message/cocoa/2006/7/19/167909

-[[JustinAnderson]]
----

Thanks, that did the trick!