I cannot make nibtool create a new .nib file after I have translated all the strings!
I'm getting the following error:

nibtool -d General/LibraryFinder.strings -w General/LibraryFinder.nib ../English.lproj/General/LibraryFinder.nib

nibtool[6417] General/CFLog (0): General/CFPropertyListCreateFromXMLData(): Old-style plist parser: missing semicolon in dictionary.
nibtool[6417] General/CFLog (0): General/CFPropertyListCreateFromXMLData(): The file name for this data might be (or it might not): General/LibraryFinder.strings
nibtool: could not open 'General/LibraryFinder.strings'.

The file has the correct format created with the same nibtool...

What am I doing wrong?

Thanks, General/FelipeBaytelman

----

Utterly wild guess but... maybe your General/LibraryFinder.strings file is missing a semicolon, like the log says it is?!