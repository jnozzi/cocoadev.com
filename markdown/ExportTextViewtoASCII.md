I am trying to find out how to export the contents of a General/NSTextView to an ascii format like a txt file. Can anyone show me code that does this or refer me to some page that has this information on it ? Thanks!

----

    General/[[NSTextView string] writeToFile:@"path/to/file.txt" atomically:YES]

See [http://developer.apple.com/documentation/Cocoa/Conceptual/General/TextIO/Tasks/General/UsingTextIO.html]

Also check out General/NSDocument, which does alot of the work for you.