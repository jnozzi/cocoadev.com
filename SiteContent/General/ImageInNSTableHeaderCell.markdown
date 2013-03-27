I was wondering how I would put an image in a General/NSTableHeaderCell. Thanks.
----
Never mind, I found it out. I'll share.
    
General/NSTableColumn *priorityColumn = [fileView tableColumnWithIdentifier:@"filePriority"];
General/NSTableHeaderCell *priorityHeader = General/[[NSTableHeaderCell alloc] initImageCell: General/[NSImage imageNamed:@"priority_header"]];
[priorityColumn setHeaderCell:priorityHeader];
[priorityHeader release];
General/NSImageCell *priorityImageCell = General/[[NSImageCell alloc] init];
[priorityColumn setDataCell:priorityImageCell];
[priorityImageCell release];

This helped me, I hope it helps you people too.

--General/JoshaChapmanDodson