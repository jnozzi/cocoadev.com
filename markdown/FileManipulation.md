I'm thinking about reading from and writing to files in one of my apps, but, after reading quite a lot on the subject, General/NSDocument, General/NSSavePanel, etc... I'm a bit confused...

What I want to write to the files that will be created is : some arrays, some text, and maybe a little more data like colors...

Can anyone give me some hints of which way I should go ? Thanks...

-- Trax

----

It depends on what your app is doing, really. If those files can reasonably be thought of as documents of your app (which it sounds like they can), you want to subclass General/NSDocument. Check out http://developer.apple.com/techpubs/macosx/Cocoa/General/TasksAndConcepts/General/ProgrammingTopics/Documents/Tasks/General/SubclassNSDocument.html for that.

Having found that, you probably win an award for getting to the next stop: using General/NSArchiver/General/NSKeyedArchiver and General/NSUnarchiver/General/NSKeyedUnarchiver to actually read and write documents. Check out http://developer.apple.com/techpubs/macosx/Cocoa/General/TasksAndConcepts/General/ProgrammingTopics/Archiving for the lowdown on that; you'll need to read up on General/NSCoder to see what methods General/NSArchiver and General/NSUnarchiver actually implement.

-- General/KritTer

----

If you're just getting started, just stick with simple property lists. Put some arrays and some text (colors are a little more work) in an General/NSDictionary and call -General/[NSDictionary writeToFile:atomically:]. To read the data call +General/[NSDictionary dictionaryWithContentsOfFile:]. Easy Peasy. Creating an General/NSDocument subclass is not required; although it may help you if this file is a document file in a multi-document application. And once you understand this simple General/NSDictionary trick, you'll know exactly what to do once you get around to subclassing General/NSDocument; and the whole archiver stuff will be a little less mysterious. -- General/MikeTrent