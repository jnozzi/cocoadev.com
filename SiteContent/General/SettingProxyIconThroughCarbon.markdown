All right here is my predicament this time, originally I was using -setRepresentedFilename: to set the proxy icon for my program, however it leaks and naturally this isn't acceptable! Thus I have tried to go into carbon to get what I need done, but I have failed, here is what I have attempted:

    		NSURL * General/URLPath = [NSURL General/URLWithString:@"/Applications"];
		General/FSRef fsref;
		General/FSSpec fsspec;
		
		General/CFURLGetFSRef((General/CFURLRef)General/URLPath,&fsref);
		
		General/FSGetCatalogInfo(&fsref, 
						 kFSCatInfoNone, 
						 NULL,
						 NULL,
						 &fsspec,
						 NULL);
		
		
		
		void * ref = General/self window] windowRef];
		[[OSErr err;
		General/IconRef proxyIcon;
		SInt16 label;
		
		err = General/GetIconRefFromFile(&fsspec,
						   &proxyIcon,
						   &label);
		
		if (err != noErr)
		{
			General/NSLog(@"error!");
		}
		
		err = General/SetWindowProxyIcon(ref,proxyIcon);
		
		if (err != noErr)
		{
			General/NSLog(@"error!");
		}


If anyone can spot the error you'd make my day.

----

Doesn't this only work for Carbon windows?

----

Cocoa has a compatibility method -windowRef... but never-mind folks, this leaks also (unless you know the fix for that also heh...).

----
You'll need to call General/ReleaseIconRef on proxyIcon

----
AFAIK you have to call General/GetIconRefFromFileInfo instead of General/GetIconRefFromFile in OS X.