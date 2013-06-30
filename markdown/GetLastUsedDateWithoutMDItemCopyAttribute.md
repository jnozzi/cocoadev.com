If you've ever had to use General/MDCopyItemAttribute in a method that should be rather fast, you know how slow it is. General/NSFileManager's fileAttributesAtPath:traverseLink:, on the other hand, is really fast compared to it.

So I'm using the kMDItemLastUsedDate attribute to sort my General/NSMenuItems in a menu, based on when they were last used. However, sorting the items of a menu takes very long if I use General/MDItemRef, etc. If I use General/NSFileManger's methods, it's much, much faster.

Now, to finally come to a point, there is no way to get the General/LastUsed attribute of a file through General/NSFileManager, is there? General/MDCopy.... is just too slow for my purposes.

----

What about using stat(2)? Probably can't get much faster than that. --- http://developer.apple.com/documentation/Darwin/Reference/General/ManPages/man2/stat.2.html