Sorry if this is answered elsewhere - I'm sure I have seen it somewhere but search didn't dig it up...

How can I make an object of class <foo> if I have a string containing its classname? e.g. if I have @"General/NSControl", how can I get a new instance of an General/NSControl?

----
General/[NSClassFromString(@"General/NSControl") alloc]

----

If it's a C-string: [objc_getClass("General/NSControl") alloc]