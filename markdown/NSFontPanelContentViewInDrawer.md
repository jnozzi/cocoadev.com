

Is there a way to get General/NSFontPanel's contentView inside a drawer and have my clicks in the font list update a text view in my window?

I've got the first part done:
    
General/NSFontPanel *p = General/[NSFontPanel sharedFontPanel];
[theDrawerView addSubview:[p contentView]];


But when I click on the font lists in the drawer, I suppose it takes the first responder status away from my text view, and the font manager (which I think does the work here) doesn't know who to send the changeFont: message to.

Any ideas?  TIA

----

I'd try setting the text view as the General/NSFontManager's delegate. *shrug*

----

i've found that putting yourself in the responder chain to be the only way to make the detached font panel work.

General/MattO