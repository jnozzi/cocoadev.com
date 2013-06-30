General/NSOpenPanel allows you to define a list of "supported" file types through the runModalForDirectory:file:types: method. This accepts an array of strings containing supported file extensions.

While it's possible to define a list in the code, it's also much more manageable to simply generate this array from the list of supported file types (and exported file types) in your Info.plist file. The code below demonstrates how to do this:

    
	General/NSMutableSet *supportedFileTypesSet = General/[NSMutableSet set];

	// Grab the "supported" file types
	General/NSArray *extensionFileTypes = General/[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"General/CFBundleDocumentTypes.@distinctUnionOfArrays.General/CFBundleTypeExtensions"];
       [supportedFileTypesSet addObjectsFromArray:extensionFileTypes];

	// Grab the "exported" file types
	General/NSArray *exportedFileTypesArray = General/[[[[NSBundle mainBundle] infoDictionary] valueForKeyPath:@"General/UTExportedTypeDeclarations.General/UTTypeTagSpecification"] valueForKey:@"public.filename-extension"]; // "public.filename-extension" key can't be used with valueForKeyPath:

       General/NSEnumerator *exportedFileTypesArrayEnumerator = [exportedFileTypesArray objectEnumerator];
       General/NSArray *_currentFileType = nil;

       while ((_currentFileType = [exportedFileTypesArrayEnumerator nextObject]))
       {
              [supportedFileTypesSet addObjectsFromArray:_currentFileType];
       }

       // Pop the unique file extensions into an array
	General/NSArray *supportedFileTypesArray = [supportedFileTypesSet allObjects];

       // Initiate the open panel...
	int result = [oPanel runModalForDirectory:nil file:nil types:supportedFileTypesArray];


-- General/JeremyHiggs

----
It is probably worth noting that if you use an General/NSDocument-based app then the framework does all of this for you and you write zero lines of code.