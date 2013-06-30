

Posted on General/CocoaDevTopics:

*Of course, all this has got me thinking about namespaces, which is a whole other topic. It'd be useful in a specific set of circumstances (i.e. within a class page like General/NSDictionary) to have the method names act as links but to that specific class' definitions of them. But of course this is 'feature creep' and probably not something that should be discussed here. -- General/RobRix*

Which is, in this case at least, re-factorable as a plea for footnotes - local pagewise definitions of non-General/WordsJammedTogether that lead to a footnote/appendix/etc on the page. Another example: I've noticed some of the longer discussions pages, like General/CocoaMostWanted, could be made neater with this feature.

This site is now altered to support this with the \\%\\%DEFINITION\\%\\% tag (see General/HowToUseFootnotes). General/DesignRedBlackTree and General/CocoaMostWanted are testament to its power.

The problem: it's feature-creep. It's good creep, in that it only slows the parsing of pages that use it, but all creep makes the Wiki script larger and obfuscates the site a little.

So: is it worth it, or should we cut it right back out?

----

Feature creep, yes, but it doesn't obfuscate the navigation of the site much at all, and only obfuscates the writing of pages by a small amount. I think it's worth it, because we can use this not only to document General/NSWotsit and provide other footnotes, but also to provide handy, editable documentation for our own General/ObjectWare, et cetera. General/CocoaDev could provide something of a General/CodeRepository and documentation for free classes. Got a great model class? Put the source on here, add your license, and document it.

Or, if this is deemed to be misuse of the site (it isn't necessarily fitting with the intent of the community and site), you can use the perl script on your own site and start a little General/MyCorp community :)

Another minor problem, though, is that feature creep such as this makes the transition to PHP a bit more difficult (although not necessarily a lot more difficult). I'm not really sure if that transition is as serious a prospect as all that, but it's something to keep in mind. -- General/RobRix

Also be aware that some browsers cannot edit Wiki pages that are too long (>32K?) in size, so adding features that encourage long pages could be a Bad Thing. Furthermore, this site now **enforces** a 32K limit on pages. -- General/KritTer