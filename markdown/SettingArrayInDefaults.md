Hello all, i've been doing Cocoa for a while now, but i've never needed to do this till recently. I have several tables using Cocoa Bindings throughout my Application ( General/AssignmentTracker X http://sourceforge.net/projects/asntrackerx/ ) which are basically tables using General/NSArrayController tied to arrays in controller classes through General/NSObjectController.  I thought it'd be nice so that when you sort information in the various tables the program would save the sort descriptors array to the user defaults and then retrieve them on startup. I have no problem setting an initial array with no objects whatsoever to the defaults value, however when you actually try to set an General/NSArray to a defaults value using [defaults setObject:sortDescriptorsArray forKey:@"asn table descriptors"]; it gives me this message and fails to set the value in the defaults:
"Attempt to insert non-property value '<General/CFArray 0x32cb70 [0xa01900e0]> { type = immutable, count = 2, values = ( 
0 :  (className, ascending, compare:)
1 :  (assignmentName, ascending, compare:)
)} ' of class 'General/NSCFArray'.

Am i missing something here or doing something the wrong way? Shouldn't I be able to set an array for a key with setObject: forKey: ? Or is there another way to do this with Cocoa Bindings?

----

The only objects you can store in the defaults database are the General/PropertyListObjects.  These are General/NSDictionary, General/NSString, General/NSArray, General/NSNumber, General/NSData and General/NSDate. So an General/NSArray is fine, but not an General/NSArray of General/NSSortDescriptors.  

However, if I remember right then all you have to do is give your table an autosave name.  The tableview itself will handle the details of saving sort descriptor information.