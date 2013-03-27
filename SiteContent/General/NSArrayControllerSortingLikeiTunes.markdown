I've made a small app to sort out song lyrics, using General/CoreData and General/NSArrayController. iTunes has the nice feature of ignoring articles such as "The" or "A" when it sorts the songs by titles. Is there an easy way to do that with an General/NSSortDescriptor or something applied to the General/NSArrayController?

----

If you already know about General/NSSortDescriptor, you're part way there. Read the docs, create a subclass, and write your own -compareObject:toObject: method ... The rest is more of a "how to sort strings alphabetically with exceptions" question.