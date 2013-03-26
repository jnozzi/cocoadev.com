

I'd like to set the text completions in a column of a table view. What I've seen about text completion implies that I need to subclass [[NSTextView]], and [[NSTableView]] isn't a subclass of [[NSTextView]] and doesn't seem to have a way of obtaining its textView either.  

I've tried using an [[NSFormatter]], but I haven't even been able to make that extend what the user has typed into one of the valid strings I want. (The application is a bug tracker; I'd like to have a column for status entries that could be "Open", "Fixed", "Not reproducible", etc.)   

Hitting "escape" in the table does bring up a LONG list of default completions, so the basic functionality is there, I just need to figure out a way to set the completion list.

Thanks,

Norm

----
See [[FieldEditor]]. The executive summary is that editing in tables is handled by a special instance of [[NSTextView]] with the cell set as its delegate, so you can just subclass that and use the text completion delegate methods.
----

Fast reply!

I've tried some code based on the examples in [[FieldEditor]] and [[CustomFieldEditor]] without any luck so far.

<code>
// in [[MyDocument]].h
- (void)windowControllerDidLoadNib:([[NSWindowController]] '') aController {
    [super windowControllerDidLoadNib:aController];
	[[NSLog]](@"Mydocument windowControllerDidLoadNib\n");
	fieldEditor = [[[[NSTextView]] alloc] initWithFrame:[[NSMakeRect]](0, 0, 0,0)];
	[fieldEditor setEditable:YES];
	[fieldEditor setFieldEditor:YES];
	[fieldEditor setSelectable:YES];
	[fieldEditor setDelegate:self];
	[fieldEditor retain];
}

// This method functions as I expect
- (id) windowWillReturnFieldEditor:([[NSWindow]] '')sender toObject:(id)anObject {
	[[NSLog]](@"windowWillReturnFieldEditor called\n");
	if (anObject == tableView) {
		[[NSLog]](@"\tIt's a call for the tableView's editor\n");
		return fieldEditor;
	} else {
		return nil;
	}
}

// This one never gets called, and I can't figure out why
- ([[NSArray]] '') textView:([[NSTextView]] '')textView 
		   completions:([[NSArray]] '')words 
   forPartialWordRange:([[NSRange]])charRange 
   indexOfSelectedItem:(int '')index {
	//
	[[NSLog]](@"Finding completions...\n");
	int iStatus = [tableView columnWithIdentifier:@"Status"];
	// int iPriority = [tableView columnWithIdentifier:@"Priority"];
	[[NSString]] ''string = [[textView string] substringWithRange:charRange];
	[[NSArray]] ''names = nil;
	[[NSMutableArray]] ''completions = [[[NSMutableArray]] array];
	if ([tableView editedColumn] == iStatus) {
		names = [[[[NSArray]] alloc] initWithObjects:
			@"Open", 
			@"Not reproducible",
			@"Won't fix",
			@"Postponed",
			@"Duplicate",
			@"By design",
			@"Fixed", 
			nil];
	}
	if (names) {
		int i;
		[[NSRange]] whereFound;
		for (i = 0; i < [names count]; i++) {
			[[NSString]] ''name = [names objectAtIndex:i];
			whereFound = [name rangeOfString:string options:[[NSCaseInsensitiveSearch]]];
			if ((whereFound.location == 0) && (whereFound.length > 0)) {
				[completions addObject:name];
			}
		}
	}
	return completions;
}
</code>

Any thoughts on what I'm forgetting?