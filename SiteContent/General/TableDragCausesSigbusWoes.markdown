It happens after the drop onto the table.

''On what line?''

Also, the "if ([supportedFiletypes containsObject:[filePath pathExtension]])"
statement does not seem to limit files types dropped as it should.

''What do supportedFiletypes and filePath contain at that point?''

----

Here's the code:

<code>

#import "ac3xController.h"

typedef enum {
    ac3xUnencoded,
    ac3xEncoding,
    ac3xEncoded
} ac3xEncodingState;

@interface Ac3xFile : [[NSObject]]
{
	@private
	
	[[NSString]] ''filePath;
	ac3xEncodingState fileState;
}

+ (id) fileWithPath:([[NSString]] '') aPath;

- ([[NSString]] '') filePath;
- (ac3xEncodingState) encodingState;

- (void) setEncoding;
- (void) setEncoded;

@end

@implementation Ac3xFile

- (id) initWithPath:([[NSString]] '') aPath
{
	if ((self = [super init]) != nil)
	{
		filePath = [aPath copy];
		fileState = ac3xUnencoded;
	}
	
	return self;
}

- (void) dealloc
{
	[filePath release];
	
	[super dealloc];
}

+ (id) fileWithPath:([[NSString]] '') aPath
{
	return [[[self alloc] initWithPath: aPath] autorelease];
}

- ([[NSString]] '') filePath
{
	return filePath;
}

- (ac3xEncodingState) encodingState
{
	return fileState;
}

- (void) setEncoding
{
	fileState = ac3xEncoding;
}

- (void) setEncoded
{
	fileState = ac3xEncoded;
}

@end

@implementation Ac3xController

// joar
//  You should ''always'' implement a dealloc method - you're leaking memory as it is now
- (void) dealloc
{
	[files release];
	
	[super dealloc];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) awakeFromNib
{
	// joar
	// This can all be done in Interface Builder
	// id cell;
    // [[NSTableColumn]] ''imageColumn = [sourceTable tableColumnWithIdentifier:@"image"];
    // cell = [[[NSImageCell]] new]; // Use of the "new" method is discouraged
    // [imageColumn setDataCell:cell];
	

    files = [[[[NSMutableArray]] alloc] init];
    
	[sourceTable setDoubleAction:@selector(encodeFile:)];
  
    [sourceTable registerForDraggedTypes:[[[NSArray]] arrayWithObjects:[[NSFilenamesPboardType]],nil]];
   
	// joar
	// Should not the controller (ie. "self") be the receiver of the notification?
	// I have also commented it out until the callback methdod is implemented
    // [[[[NSNotificationCenter]] defaultCenter] addObserver: sourceTable selector: @selector(abortEncode:) name: [[NSApplicationWillTerminateNotification]] object:[[NSApp]]];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (int)numberOfRowsInTableView:([[NSTableView]] '')tableView
{
    return [files count];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ ([[NSImage]] '') imageForState:(ac3xEncodingState) aState
{
	switch (aState)
	{
		case ac3xUnencoded :
			return [[[NSImage]] imageNamed: @"blue"];
		case ac3xEncoding :
			return [[[NSImage]] imageNamed: @"yellow"];
		case ac3xEncoded :
			return [[[NSImage]] imageNamed: @"green"];
		default :
			return nil;
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+ ([[NSString]] '') statusStringForState:(ac3xEncodingState) aState
{
	switch (aState)
	{
		case ac3xUnencoded :
			return @"";
		case ac3xEncoding :
			return @"Encoding...";
		case ac3xEncoded :
			return @"Encoded";
		default :
			return nil;
	}
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (id)tableView:([[NSTableView]] '')view objectValueForTableColumn:([[NSTableColumn]] '')col row:(int)row
{
	Ac3xFile ''selectedFile = [files objectAtIndex: row];

    if ([[col identifier] isEqualTo: @"image"]) {
        return [[self class] imageForState: [selectedFile encodingState]];
    }
    else if ([[col identifier] isEqualTo: @"source"]) {
        return [selectedFile filePath];
    }
    else if ([[col identifier] isEqualTo: @"status"]) {
        return [[self class] statusStringForState: [selectedFile encodingState]];
    }
    return nil;


}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// joar
// Not used?
/''
- ([[NSString]] '')fileSelected
{ 
	// joar
	// Should you really have a "fileSelected" method, when you allow multiple selection in the table view?
	// You also need to handle the case when you have no selected rows and "selectedRow" returns -1!
return [files objectAtIndex: [sourceTable selectedRow]]; 

}
''/

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/''
- (BOOL)tableView:([[NSTableView]] '')tableView shouldEditTableColumn:([[NSTableColumn]] '')tableColumn row:(int)row
{
	// joar
	// You can disable editing of column in IB - at least if you're always going to return NO.
    return NO; 
}
''/

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- ([[NSDragOperation]])tableView:([[NSTableView]]'')tv validateDrop:(id <[[NSDraggingInfo]]>)info proposedRow:(int)row proposedDropOperation:([[NSTableViewDropOperation]])op
{
    [tv setDropRow:[tv numberOfRows] dropOperation:[[NSTableViewDropAbove]]];
    return [[NSTableViewDropAbove]];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void) addFileAtPath:([[NSString]] '') aPath
{
	[files addObject: [Ac3xFile fileWithPath: aPath]];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)tableView:([[NSTableView]]'')tv acceptDrop:(id <[[NSDraggingInfo]]>)info row:(int)row dropOperation:([[NSTableViewDropOperation]])op
{

    [[NSPasteboard]] ''myPasteboard=[info draggingPasteboard];
    [[NSArray]] ''typeArray=[[[NSArray]] arrayWithObjects:[[NSFilenamesPboardType]],nil];
	[[NSArray]] ''filenames = [myPasteboard propertyListForType:[[NSFilenamesPboardType]]];
    [[NSArray]] ''supportedFiletypes = [[[NSArray]] arrayWithObjects:@"dv", @"VOB", nil];

    [[NSString]] ''filePath,''availableType;
    [[NSArray]] ''filesList;
    int i;

    availableType=[myPasteboard availableTypeFromArray:typeArray];
    filesList=[myPasteboard propertyListForType:availableType];
	
	// joar
	// You're assigning an autoreleased object instance to an instance variable - not good
	// In the general case this would have led to a crash
	// statusImage = [[[NSImage]] imageNamed: @"blue"];
	// Same here really. OK, so a static string doesn't have to be retained, but it's best to
	// learn to use proper memory management routines at all times
	// statusText = @"";

    for (i = 0; i < [filesList count]; i++)
    {
		if ([supportedFiletypes containsObject: [filePath pathExtension]])
		{
			[self addFileAtPath: filePath];
		}
	}
		
		[sourceTable reloadData];

		/''
        filePath=[[filesList objectAtIndex:i]lastPathComponent];
		
		if ([supportedFiletypes containsObject:[filePath pathExtension]])
{
        [files insertObject:filePath atIndex:row+i];
    }
   
    [sourceTable reloadData];
   
    [sourceTable selectRow:row+i-1 byExtendingSelection:NO];
		 ''/
		
    return YES;
   // }
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- ([[IBAction]])abort:(id)sender
{
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- ([[IBAction]])addFile:(id)sender
{

  int result;
  [[NSArray]]'' fileTypes = [[[NSArray]] arrayWithObjects: @"dv", @"VOB", nil];
  [[NSOpenPanel]] ''oPanel = [[[NSOpenPanel]] openPanel];

  [oPanel setAllowsMultipleSelection:YES];
  result = [oPanel runModalForDirectory:[[NSHomeDirectory]]() file:nil types:fileTypes];
  
    if (result == [[NSOKButton]])
	{
        BOOL x;
        [[NSArray]] ''filesToOpen = [oPanel filenames];
        int i, count = [filesToOpen count];
        for (i=0; i<count; i++)
		{
			[self addFileAtPath: [filesToOpen objectAtIndex: i]];
/''        
            [[NSString]] ''aFile = [[filesToOpen objectAtIndex: i] lastPathComponent];
            [files insertObject:aFile atIndex:i];
			''/
        }
        [sourceTable reloadData];
		[sourceTable selectRow:[files count]-1 byExtendingSelection:NO];
    }

}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- ([[IBAction]])deleteFile:(id)sender
{

 [[NSEnumerator]] ''enumerator = [sourceTable selectedRowEnumerator];
    id object;
    int i = 0;
    while (object = [enumerator nextObject]) 
    {	
        [[NSLog]](@"%@",object);
        [files removeObjectAtIndex:[object intValue]-i];
        i++;
    }
    
    [sourceTable reloadData];
}

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- ([[IBAction]]) encode:(id) sender
{
	int selectedRow = [sourceTable selectedRow];
	
	if (selectedRow >= 0)
	{
		Ac3xFile ''selectedFile = [files objectAtIndex: selectedRow];

		[selectedFile setEncoding];
	}

	/''
    {	
		// joar
		// You're assigning an autoreleased object instance to an instance variable - not good
		// In the general case this would have led to a crash
		// statusImage = [[[NSImage]] imageNamed: @"green"];
		// Same here really. OK, so a static string doesn't have to be retained, but it's best to
		// learn to use proper memory management routines at all times
		// statusText = @"Encoding...";
    }
	 ''/
    
    [sourceTable reloadData];

}

@end

</code>

Thanks for your help!

Sean
%%ENDENTRY%%

----

You gotta be more specific. When exactly does the problem occur? While you're dragging? When you start the drag? When you end the drag?

''Editor's Note: thanks to joar for trying to debug this code; where advice is given, comments have been inserted in the code''