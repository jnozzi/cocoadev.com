If you have an [[NSDocument]] derived class and you want to save out a single object from your class, you can use the code below in your <code>dataRepresentationOfType:</code> method.

<code>
[[[NSArchiver]] archivedDataWithRootObject: singleObject];
</code>

Put the code below in the corresponding <code>loadDataRepresentation:ofType:</code> method.

<code>
[singleObject autoRelease];
singleObject = [[[[NSUnarchiver]] unarchiveObjectWithData: data] retain];
</code>

Anyone care to add code to add multiple objects to the data stream? Shouldn't be too difficult...

----
Ok,

If you want to have your document archive a collection of objects then just have an instance (in your Document Class) that acts as the model (or root object) for the collection of objects you want to archive.  This can be one of the Foundation collection Classes, ([[NSArray]], [[NSDictionary]], [[NSSet]]) or a custom Class of your own that implements the [[NSCoding]] protocol.

Now your document's archivable data is encapsulated in this model object.  If you want to read or change data within the model (i.e. data that will be saved) then you have to use the model's accessor methods 
<code>
e.g. [someIBOutlet setColour: [documentModel theColour]];
</code>


When you come to archive in the <code>dataRepresentationOfType:</code> method you simply archive the model object:

<code>
- ([[NSData]] '')dataRepresentationOfType:([[NSString]] '')aType
{
    // (Saving)  The [[NSDocumentController]] wants to save the document to disc.
    //	We need to give it our model object as [[NSData]].
    [[NSLog]](@"Document dataRepresentationOfType");

    return [[[NSArchiver]] archivedDataWithRootObject:documentModel];
}
</code>


and the same goes for unArchiving:

<code>
- (BOOL)loadDataRepresentation:([[NSData]] '')data ofType:([[NSString]] '')aType
{
     [documentModel release];
    documentModel=[[[[NSUnarchiver]] unarchiveObjectWithData:data] retain];

    [self updateUI];
    return YES;
}
</code>



----

Also, anyone know how to add versioning to the archiver stream so the file format can evolve nicely?

Here's version info: [[VersioningUsingCoder]] -- [[ChrisMeyer]]

----

Here's a link to a discussion about portability and plans for [[NSArchiver]]/[[NSUnarchiver]]:
http://mail.gnu.org/pipermail/help-gnustep/2000-September/000001.html

----

Could some1 contribute some examples of the use of those?

[[ArchivingToAndUnarchivingFromPropertyLists]] [[ArchivingObjects]]

----
hmm,
assume I have a class Person, which implements a <[[NSCoding]]> protocol. The data are used in a tableview and I want to use drag and drop. The problem is in case of multiple rows are selected/dragged. I can archive all data into [[NSArchiver]] object easy but how can I Unarchive them? 

<code>
[[[NSUnarchiver]] unarchiveObjectWithData:[pboard dataForType:[[SomeDragDropPboardType]]]]
</code>

this function will discard any data behind first record. How to correctly do it?
Thanks -[[BobC]]

----
ok,
I'm posting here a right solution.

<code>
    [[NSUnarchiver]] ''unarch = [[[[NSUnarchiver]] alloc] initForReadingWithData:[pboard dataForType: [[SomeDragDropPboardType]]]];
    
    while (![unarch isAtEnd])
    {
        [_array addObject:[unarch decodeObject]];
        [[NSLog]](@"%d", [unarch isAtEnd]);
    } 

    [unarch release];
</code>

However, I'm getting an error message "''''' Incorrect archive: unexpected byte". Any clues?
-[[BobC]]

----
The problem is that [[NSUnarchiver]] doesn't know how to expand multiple objects. The easiest solution I have found so far is to inlcude all objects into one array, which can be archived easily and than unarchive it on another side. I'm posting the solution:

''Perhaps you forgot to look at the superclass?  To decode multiple objects with [[NSUnarchiver]], init it with data and call decodeObject repeatedly.''

dragsource:
<code>
- (BOOL)tableView:([[NSTableView]] '')tv writeRows:([[NSArray]]'')rows toPasteboard:([[NSPasteboard]]'')pboard
{
    [[NSEnumerator]] 	''enumerator = [rows objectEnumerator];
    [[NSNumber]] 		''currentRow = [[[NSNumber]] numberWithInt:0];
    [[NSMutableArray]]	''draggedObjects = [[[NSMutableArray]] arrayWithCapacity:1];
    [[NSData]]		''aData;

    //prepare data
    while (currentRow = [enumerator nextObject])
    {
	[[ICISPerson]] ''aPerson = [[currentData peopleArray] objectAtIndex:[currentRow intValue]];
	[draggedObjects addObject:aPerson];
    }
    aData = [[[NSArchiver]] archivedDataWithRootObject:draggedObjects];
        
    [pboard declareTypes:[[[NSArray]] arrayWithObjects: [[ICISDragDropSimplePboardType]],[[NSStringPboardType]], nil] owner:self];
    
    [pboard setData:aData forType:[[ICISDragDropSimplePboardType]]]; 
    [pboard setString: [aData description] forType: [[NSStringPboardType]]];

    return YES;
}
</code>
drag destination
<code>
- (BOOL)tableView:([[NSTableView]]'')tableView acceptDrop:(id <[[NSDraggingInfo]]>)info row:(int)row dropOperation:([[NSTableViewDropOperation]])operation
{
	[preferredPeople addObjectsFromArray:[[[NSUnarchiver]] unarchiveObjectWithData:[[info draggingPasteboard] dataForType:[[ICISDragDropSimplePboardType]]]]];
	[tableView reloadData];

    return YES;
}
</code>
the drag destination solution is by Marcel Weiher
- [[BobC]]

----

Please note that [[NSKeyedArchiver]] and [[NSKeyedUnarchiver]] are usually to be used in preference to the unkeyed version.  Key-value coding/archiving is a lot more portable across versions, since it doesn't depend on objects to have been archived in a particular order.  It's my understanding that unkeyed archiving is more or less deprecated, but I might just be projecting there.   ---  [[JoeOsborn]]