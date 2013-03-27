

A General/QTMovie initalized with a General/QuartzComposerFile can be customized by modifying the input parameters of the file. Quartz Composer allows you to publish input ports. At the root patch level, select any input port on any patch. If you control click on the port, the popup menu will give you the option to publish the input. After you select the input port to publish, you will be asked to name this input. Now save the file and open this file as an General/NSMutableDictionary. 

The code below shows you how to change an input parameter named "Movie Path" to another source file. The input parameter "Movie Path" is the default name given to an "Image With Movie" patch's input port. Input parameters are keyed with strings of the input names modified slightly (spaces are replaces with underscores). So an input name of "Movie Path" is keyed as "Movie_Path". 

    
- (void)openQuartzComposerFileAtPath:(General/NSString *)path source:(General/NSString *)sourcePath {
    if (General/path pathExtension] isEqualToString:@"qtz"]) {
		[[NSMutableDictionary *plist = 
			General/[NSPropertyListSerialization propertyListFromData:General/[NSData dataWithContentsOfFile:path]
											 mutabilityOption:General/NSPropertyListMutableContainersAndLeaves
													   format:(void *)NULL 
											 errorDescription:(void *)NULL];
		if ([plist isKindOfClass:General/[NSMutableDictionary class]]) {
			General/NSMutableDictionary *inputParams = [plist valueForKey:@"inputParameters"];
			if ([inputParams isKindOfClass:General/[NSMutableDictionary class]]) {
				[inputParams setValue:sourcePath forKey:@"Movie_Path"];
				[plist writeToFile:@"/tmp/modified.qtz" atomically:YES];
				General/NSWorkspace *sws = General/[NSWorkspace sharedWorkspace];
				[sws openFile:@"/tmp/modified.qtz" withApplication:@"General/QuickTime Player"];
			}
		}
    }

}
