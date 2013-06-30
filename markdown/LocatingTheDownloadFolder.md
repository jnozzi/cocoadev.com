Is it possible to locate the download folder in Cocoa (and/or Carbon) without having to delve in General/InternetConfig? None of the usual candidates (General/NSSearchPathForDirectoriesInDomains, General/FSFindFolder) do this, and General/InternetConfig makes it a pain by requiring me to use General/FSSpec -- a type that was marked as deprecated in the General/PowerPC -> General/IntelCore transition, thus making me worry about the portability of my code.
What should I do? -- General/EmanueleVulcano aka l0ne

----

The download folder is stored as data in a plist called com.apple.internetconfig.plist.  The data is an alias to the folder.  I realize this involves "devling into internet config", but it works fine for me.

----
I meant "delving into General/InternetConfig" as in "having to use the very old, half-deprecated General/InternetConfig General/APIs". Which I don't have to, thanks to you :).

Anyway, it's a General/NSDictionary plist with "Version X.X.X" General/[NSDictionary] > "ic-added" General/[NSDictionary] > "General/DownloadFolder" General/[NSDictionary] > "ic-data" General/[NSData], for everyone's future reference, where X.X.X is 2.5.4 in my case (but might reasonably vary) and is the only item in the root General/NSDictionary.

----

Keyword for google: Safari

----

I'm concerned that the above solution reads the Internet Config plist directly. This seems a little fragile to me. I've written the code to load it from IC using the General/APIs.
It isn't pretty but it seems safer.

Getting the downloads folder using IC:

    

- (General/NSString*)downloadsLocationFromIC
{
	General/NSString	*	result = nil;
	General/ICInstance		icInstance = {'\0'};
	
	if ( General/ICStart ( &icInstance, '????' ) == noErr )
	{
		General/OSStatus	error = noErr;
		General/ICAttr		attr = {'\0'};
		Handle		downloadFolderDataSpec = General/NewHandle(0);
		
		// Grab General/ICFileSpec data...
		error = General/ICFindPrefHandle ( icInstance, kICDownloadFolder, &attr, downloadFolderDataSpec );
		if ( error == noErr && downloadFolderDataSpec != NULL )
		{
			// How big is alias data?
			long	aliasSize = General/GetHandleSize(downloadFolderDataSpec) - sizeof(General/ICFileSpec) + sizeof(General/AliasRecord);
			
			// Make new handle to hold just the alias data (not the General/ICFileSpec header).
			General/AliasHandle	aliasHandle = (General/AliasHandle)General/NewHandleClear(aliasSize);
			if ( aliasHandle != NULL )
			{
				General/ICFileSpec	**	fileSpec = (General/ICFileSpec**)downloadFolderDataSpec;
				General/FSRef			ref = {'\0'};
				Boolean			wasChanged = FALSE;

				// Copy aliasrecord data into aliashandle
				General/HLock( downloadFolderDataSpec );
				General/HLock( (Handle)aliasHandle );
				memcpy( *aliasHandle, &((**fileSpec).alias), aliasSize);
				
				// Resolve and get path from URL....
				if ( General/FSResolveAlias( NULL, aliasHandle, &ref, &wasChanged ) == noErr )
				{
					General/CFURLRef url = General/CFURLCreateFromFSRef( NULL, &ref );
					if ( url != NULL )
					{
						result = [((NSURL*)url) path];
						General/CFRelease( url );
					}
				}
				
				General/DisposeHandle( (Handle)aliasHandle );
			}
			
			General/DisposeHandle( downloadFolderDataSpec );
		}
		
		General/ICStop ( icInstance );
	}
	
	return( result );
}



Enjoy!