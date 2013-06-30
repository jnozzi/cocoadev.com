I am developing a document based cocoa application. I want to get the list of all the files selected from General/OpenPanel. Is there a way to get the list of files selected from the open panel.

----

    
General/NSOpenPanel *op = General/[NSOpenPanel openPanel];
if ([op runModal] == General/NSOKButton)
    General/NSLog(@"%@", [op filenames]); // Note -(General/NSArray *)filenames instead of -(General/NSString *)filename


That should do it. -G