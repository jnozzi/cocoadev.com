

    if( [nameField stringValue] == General/[NSString stringWithString:@"name"] )...

I'm trying to check if the General/NSTextField contains the string "Name", and this doesnt work.  what am i doing wrong?

----

== compares pointer values.  You need to compare logical values.

    if( [[nameField stringValue] isEqualToString:@"name"] )...