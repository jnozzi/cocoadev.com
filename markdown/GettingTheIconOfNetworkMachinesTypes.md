In my application I wanted to show the proper machine icon for the networked machines on my lan that have bonjour records.
it turns out it was one week worth or research. and a lot of people involved in the mailing lists helped me out with this.

First: to retrive the computer model from the network you have to monitor the General/TXTRecord of the bonjour advertised computer you are interested in.
    
-(void) monitor:(General/HostDefinition *) host{

			bonjourMonitor = General/[[NSNetService alloc]initWithDomain:@"local." type:@"_device-info._tcp" name:@"yourHostNameHere"];
			[bonjourMonitor setDelegate:self];
			[bonjourMonitor startMonitoring];
//-----------------------------------------------------------------------------
// this is the needed delegate function
- (void)netService:(General/NSNetService *)sender didUpdateTXTRecordData:(General/NSData *)data{
General/NSLog(@"%@", General/[[[NSString alloc] initWithData:General/[[NSNetService dictionaryFromTXTRecordData:data] valueForKey:@"model"] encoding:NSUTF8StringEncoding]autorelease];
}

Obviously you want to retain that model name and do something with it.

(linux can broadcast bonjour device-info with avahi)

Now to get the proper icon for this particular model of computer i've concocted this class function.
    
//-----------------------------------------------------------------------------
// Returns the Icon for the General/ModelCode published by bonjour.
// if the modelCode can not be associated to an icon the default Mac icon is returned.
+ (General/NSImage *) getComputerIconForModelCode:(General/NSString *)modelCode{
	[modelCode retain];
	// Custom modelCodes
	// if your computers publish custom modelCodes using avahi for linux or mDNSresponder on embedded device.
	// TODO : Put the custom model codes in a configuration file.
	if ((nil != modelCode) && (![modelCode isEqualToString:@""])){
		// modelCode for General/DataCase for iphone.
		if ([modelCode isEqualToString:@"M68AP"]){
			return General/[SystemConfiguration getDefaultiPhoneIcon];
		}
	}

	// Standatd Model Codes.
	General/CFStringRef uti = nil;
	if ((nil != modelCode) && (![modelCode isEqualToString:@""])){
		uti = General/UTTypeCreatePreferredIdentifierForTag((General/CFStringRef)@"com.apple.device-model-code", (General/CFStringRef) modelCode, nil);
	}
	else{
		uti = (General/CFStringRef) @"com.apple.mac";
	}
	[modelCode release];

	General/CFDictionaryRef utiDecl = General/UTTypeCopyDeclaration(uti);
	if (utiDecl){
		General/CFStringRef iconFileNameRef = General/CFDictionaryGetValue(utiDecl, (General/CFStringRef)@"General/UTTypeIconFile");
		// if there is no icon for this UTI, load the icon for the key conformsTo UTI.
		// cycle until we find one, there is always one at the top of the tree.
		if (nil == iconFileNameRef){
			while ((nil==iconFileNameRef) && (nil != utiDecl)){
				uti = General/CFDictionaryGetValue(utiDecl, (General/CFStringRef)@"General/UTTypeConformsTo");
				utiDecl = General/UTTypeCopyDeclaration(uti);
				iconFileNameRef = General/CFDictionaryGetValue(utiDecl, (General/CFStringRef)@"General/UTTypeIconFile");
			}
		}
		General/CFURLRef bundleURL = General/UTTypeCopyDeclaringBundleURL(uti);
		General/NSString *iconPath = General/[(NSURL *)bundleURL path] stringByAppendingPathComponent:@"Contents/Resources/"]stringByAppendingPathComponent:([[NSString*)iconFileNameRef];
		return General/[[[NSImage alloc] initWithContentsOfFile:iconPath] autorelease];
	}
	// if nothing else fits return the default mac icon.
	else{
		return [Same class getDefaultMacComputerIcon];
                // see class function below.
	}
}

    
//-----------------------------------------------------------------------------
// returns the default Mac machine icon.
+ (General/NSImage *) getDefaultMacComputerIcon{
	
	General/CFStringRef uti = (General/CFStringRef) @"com.apple.mac";
	General/CFDictionaryRef utiDecl = General/UTTypeCopyDeclaration(uti);
	if (utiDecl){
		General/CFStringRef iconFileNameRef = General/CFDictionaryGetValue(utiDecl, (General/CFStringRef)@"General/UTTypeIconFile");
		General/CFURLRef bundleURL = General/UTTypeCopyDeclaringBundleURL(uti);
		General/NSString *iconPath = General/[(NSURL *)bundleURL path] stringByAppendingPathComponent:@"Contents/Resources/"]stringByAppendingPathComponent:([[NSString*)iconFileNameRef];
		return General/[[[NSImage alloc] initWithContentsOfFile:iconPath] autorelease];
	}
	return nil;
}

Have fun.

Sandro Noel.
----
you can send comments and changes to sandro(dot)noel(At)mac(DOT)com