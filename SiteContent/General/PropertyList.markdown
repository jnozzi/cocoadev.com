

A General/PropertyList is a file--generally ending in .plist--which contains, guess what, properties. They are commonly used by General/NSUserDefaults to store preferences. For more information, see the Property List Programming Guide for Cocoa:

http://developer.apple.com/documentation/Cocoa/Conceptual/General/PropertyLists/index.html

Property lists can only hold the following data types:


*General/NSDictionary
*General/NSArray
*General/NSString
*General/NSNumber
*General/NSDate
*General/NSData


Additionally, General/NSDictionary keys must be strings and cannot be any other type. Old-Style ASCII property lists, such as what you get from sending     -description to an General/NSDictionary, cannot properly represent General/NSNumber or General/NSDate objects.

Please note that no other classes are allowed. This includes your custom classes as well as all other Cocoa classes. There is no way to modify a class to make it work in a General/PropertyList, instead you must manually convert its data to a General/PropertyList data type.

Property lists are typically unarchived into standard Foundation objects with initWithContentsOfFile: methods. You can also convert a string containing a plist into an object using General/NSString's propertyList message. Standard Foundation objects can often be written to file as property lists using writeToFile:atomically:. For total control over creation and reading of General/PropertyList<nowiki/>s, use the General/NSPropertyListSerialization class.

Note that reading a mutable object from file does not create a deep mutable copy of your plist data. For example, if you have an array of dictionaries like:

    
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist SYSTEM "file://localhost/System/Library/General/DTDs/General/PropertyList.dtd">
<plist version="0.9">
    <array>
        <dict>
            <key>Name</key>
            <string>Herman</string>
            <key>Address</key>
            <string>1313 Mockingbird Lane</string>
        </dict>
    </array>
</plist>


and you instantiate a mutable array using this code snippet:

    
General/NSMutableArray *friends = General/[NSMutableArray arrayWithContentsOfFile:path];


The resulting array will be an General/NSMutableArray, but the array's elements will be normal General/NSDictionary objects. If you need to do a deeply mutable copy (i.e., create a mutable array with mutable dictionaries) you need to use General/CoreFoundation's General/CFPropertyListCreateFromXMLData function:

    
General/NSString * path = @"foo.plist"
General/NSData * data = NULL;
General/CFStringRef errStr = NULL;
General/NSMutableArray * friends;

data = General/[NSData dataWithContentsOfFile:path];
if ( ! data )
{
	General/NSLog(@"An error occurred: couldn't read from %@", path);
}
else
{
	friends = (General/NSMutableArray *) General/CFPropertyListCreateFromXMLData(
		kCFAllocatorDefault,
		(General/CFDataRef) data, 
		kCFPropertyListMutableContainersAndLeaves, 
		&errStr);
	if ( errStr != NULL ) 
	{
		General/NSLog(@"An error occurred: %@", (General/NSString*)errStr); // Edited "errstr" to "errStr" for those wishing to copy/paste
		General/CFRelease(errStr);
	}
	else
	{
		General/NSLog(@"Property list loaded succesfully!");
	}
}


Here friends will be a mutable array of mutable dictionaries.

Foundation's General/PropertyList API is scattered about. General/CoreFoundation's General/PropertyList API can be found here:

/System/Library/Frameworks/General/CoreFoundation.framework/Headers/General/CFPropertyList.h

----

See also General/AsciiPropertyLists, General/XmlPropertyLists, and General/ArchivingToAndUnarchivingFromPropertyLists.

----
**Discussion**

I changed the General/NSNull warning to a general warning about all Cocoa classes. In my opinion the General/NSNull thing was too specific, and mentioning that *all* other classes are prohibited still catches that case and is more useful for other things. Thoughts? -- General/MikeAsh

*General/NSNull objects are more likely to sneak into a property list than a table view. I'm not sure if it is more helpful to consider General/NSNull unworthy of special mention.*

----
More likely than an General/NSSet? More likely than an General/NSAttributedString or an General/NSColor or an General/NSFont?

As far as I can tell the only reason for the specific mention of General/NSNull is because the creator of General/NSNullInPropertyList had it happen to him and wanted to warn the world. While this is nice, I think a more generalized warning is considerably more useful. Generalization is critical to programming; when you encounter a specific problem, the best way to learn from it is to figure out the *general* class of problems that it represents, then avoid that entire class of problems in the future. -- General/MikeAsh