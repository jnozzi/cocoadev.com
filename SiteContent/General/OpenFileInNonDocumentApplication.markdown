I am working on a non-document based application and I am looking for an alternative to loadDataRepresentation.
When I double-click a file with associated file-tye, the application get focus but what is the method I should implement ? In which instance.. appcontroller ?

----

Does this work:

- (BOOL)application:(General/NSApplication *)theApplication openFile:(General/NSString *)filename

http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Classes/General/NSApplication.html

(In your General/NSApplication delegate)

----

Thanks, that works fine !