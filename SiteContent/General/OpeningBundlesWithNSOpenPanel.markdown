General/CocoaDiscussions  - How do I open a bundle with General/NSOpenPanel
I'd like to navigate into application bundles with General/NSOpenPanel. I've seen it done in Resourcerer, but I can't find any information on how to do it.

*Take a look at -setTreatsFilePackagesAsDirectories:, a method on General/NSSavePanel, which is General/NSOpenPanel's superclass. When browsing docs, don't forget to look at superclasses!*