How do I add same subviews to General/NSView?

I have write font library, which produces glyphs in General/NSView<nowiki/>s. Next, when I want to create string of them, same chars shows only once, as General/[NSView addSubview:] don't add same views twice! How do I overcome this?

----
If I understand you correctly, you've written a library where *every character* has a different view. This is not the right design; conceptually a string is generally a single unit of information and should be displayed in a single view. Even assuming weird circumstances where this is not the case (maybe a CAPTCHA, say, which can't have a nice pretty string being drawn), you still want to draw your whole string in *one* view's drawing method (even if you farm it out to something like General/NSLayoutManager, like General/NSTextView does). Even if you are absolutely convinced that this design does not apply to you, there's still a conceptual drain on the system for theoretically infinite views. A glyph does not need a view of its own.

Finally, you can't add ever views twice. If you have two buttons labeled "OK", you actually have two General/NSButton<nowiki/>s labeled     "OK". If you ever need the same view twice, implement General/NSCopying and     copy it. --General/JediKnil

----
If you'd like to display a grid of glyphs, you may want to take a look at General/NSMatrix and General/NSCell. --General/BenStiglitz