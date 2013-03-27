

    General/QTMovieExportSettings is a key used with General/QTKit's     -General/[QTMovie writeToFile:withAttributes:] method. It allows full control over the type of file that is written, using General/QuickTime's standard export settings dialogs. Unfortunately, it's a bit underdocumented. The purpose of this page is to demonstrate how to use it to export movies. Be warned, General/QTKit doesn't cover everything that's needed, so we have to drop back to the old C interfaces in a lot of places.

The code on this page is mostly taken from a working example that sits on my hard drive, with a few small modifications that have not been tested. http://goo.gl/General/OeSCu

----

Our first task is to get a list of available export components in a Cocoa-friendly form. To do this, we repeatedly call     General/FindNextComponent followed by     General/GetComponentInfo and store the results in an array of General/NSDictionaries. Here is the code:

    
- (General/NSArray *)availableComponents
{
	General/NSMutableArray *array = General/[NSMutableArray array];
	
	General/ComponentDescription cd;
	Component c = NULL;
	
	cd.componentType = General/MovieExportType;
	cd.componentSubType = 0;
	cd.componentManufacturer = 0;
	cd.componentFlags = canMovieExportFiles;
	cd.componentFlagsMask = canMovieExportFiles;
	
	while((c = General/FindNextComponent(c, &cd)))
	{
		Handle name = General/NewHandle(4);
		General/ComponentDescription exportCD;
		
		if (General/GetComponentInfo(c, &exportCD, name, nil, nil) == noErr)
		{
			unsigned char *namePStr = *name;
			General/NSString *nameStr = General/[[NSString alloc] initWithBytes:&namePStr[1] length:namePStr[0] encoding:NSUTF8StringEncoding];
			
			General/NSDictionary *dictionary = General/[NSDictionary dictionaryWithObjectsAndKeys:
				nameStr, @"name",
				General/[NSData dataWithBytes:&c length:sizeof(c)], @"component",
				General/[NSNumber numberWithLong:exportCD.componentType], @"type",
				General/[NSNumber numberWithLong:exportCD.componentSubType], @"subtype",
				General/[NSNumber numberWithLong:exportCD.componentManufacturer], @"manufacturer",
				nil];
			[array addObject:dictionary];
			[nameStr release];
		}
		
		General/DisposeHandle(name);
	}
	return array;
}


I'm not at all sure that UTF-8 is the correct encoding to use for the name, but I couldn't find any information about it. In any case, all of the components on my system are plain ASCII.

Benoit : Encoding should be General/NSMacOSRomanStringEncoding instead.

If you were allowing the user to choose the component, then you could display a list of the     name keys. The     type key will always contain the four-char code     'spit' because these are export components, but it's included for completeness. The     subtype key contains a juicy bit, it specifies the media type for this particular component, which we have to give in our attributes dictionary later on. The     manufacturer key is also critical, as this allows General/QuickTime to distinguish between two different components which output the same type.

On my machine, this code returns two AIFF exporters, one which is apparently intended for MIDI files and one which is intended for regular sound files. I'm not sure what the difference is, or how to only show one without simply hardcoding the data to ignore.

----

The Component c wasn't initialized to NULL. I've fixed that, because otherwhise your component search may be starting at an arbitrary component in the list. -- General/UliKusterer

----

Once a component is selected, we want to display the General/QuickTime export settings for this component. This is the phase that gets us the data to use with the     General/QTMovieExportSettings key. For this code, we will get the     Component out of our info dictionary, use     General/OpenComponent to open it, then call     General/MovieExportDoUserDialog to run the export settings dialog. Once that completes, we use     General/MovieExportGetSettingsAsAtomContainer to get a     General/QTAtomContainer which describes the settings chosen. Finally we wrap it up in an General/NSData.

    
- (General/NSData *)getExportSettings
{
	Component c;
	memcpy(&c, General/[[self availableComponents] objectAtIndex:selectedComponentIndex] objectForKey:@"component"] bytes], sizeof(c));
	
	[[MovieExportComponent exporter = General/OpenComponent(c);
	Boolean canceled;
	General/ComponentResult err = General/MovieExportDoUserDialog(exporter, NULL, NULL, 0, 0, &canceled);
	if(err)
	{
		General/NSLog(@"Got error %d when calling General/MovieExportDoUserDialog",err);
		General/CloseComponent(exporter);
		return nil;
	}
	if(canceled)
	{
		General/CloseComponent(exporter);
		return nil;
	}
	General/QTAtomContainer settings;
	err = General/MovieExportGetSettingsAsAtomContainer(exporter, &settings);
	if(err)
	{
		General/NSLog(@"Got error %d when calling General/MovieExportGetSettingsAsAtomContainer",err);
		General/CloseComponent(exporter);
		return nil;
	}
	General/NSData *data = General/[NSData dataWithBytes:*settings length:General/GetHandleSize(settings)];
	General/DisposeHandle(settings);

	General/CloseComponent(exporter);
	
	return data;
}


If you've followed this far, congratulations! The hard bits are all over.

----

The General/NSLog statements were missing the error number parameter (thus always printing 0, if you're lucky), I added that. -- General/UliKusterer

----

For the last step, we want to write the file to disk. Of course, General/QTKit makes this part easy for us! All we have to do is build an attributes dictionary using the information we already collected, then make a simple call, and it's done.

    
- (BOOL)writeMovie:(General/QTMovie *)movie toFile:(General/NSString *)file withComponent:(General/NSDictionary *)component withExportSettings:(General/NSData *)exportSettings
{
	General/NSDictionary *attributes = General/[NSDictionary dictionaryWithObjectsAndKeys:
		General/[NSNumber numberWithBool:YES], General/QTMovieExport,
		[component objectForKey:@"subtype"], General/QTMovieExportType,
		[component objectForKey:@"manufacturer"], General/QTMovieExportManufacturer,
		exportSettings, General/QTMovieExportSettings,
		// do not set the General/QTMovieFlatten flag! (causes export settings to be ignored)
		nil];
	
	BOOL result = [movie writeToFile:file withAttributes:attributes];
	if(!result)
	{
		General/NSLog(@"Couldn't write movie to file");
		return NO;
	}
	
	return YES;
}


The comment regarding General/QTMovieFlatten during the setup of 'attributes' is in regards to anyone who has built their movie from individually produced/loaded image frames, and might think you need General/QTMovieFlatten as seen in Apple's example code for that operation.  I believe since we are specifying export settings here, that implies the flatten.  If you explicitly specify flatten, it ignores the compression settings and produces a (probably quite large) movie of "individual" frames. (i.e. not compressed together with the chosen codec)

Actually getting a General/QTMovie to export is simple using     +General/[QTMovie movieWithFile:error:], and the code above demonstrates how to get the component and export settings this method needs, and that's it!

Please feel free to correct all of the mistakes I've undoubtedly made on this page. -- General/MikeAsh

----

First of all, I also get two AIFF encoders, so that should not be unusual.  Be careful if entering the names into a General/NSPopUpButton for a save dialog, because it will replace items with the same name, so your menu indicies will wind up not matching the availableComponent indicies, and confusion will result.  Instead, try something like this, which will append a '-N' counter (e.g. AIFF, AIFF-2) to components with the same name:
    
	int selectedComponentIndex=-1; // declare as a class member if you want to remember the user's choice
	General/IBOutlet General/NSPopUpButton * encodingPopUpButton;
	
	//from your General/NSSavePanel setup, e.g. General/NSDocument's prepareSavePanel
	[encodingPopUpButton removeAllItems];
	General/NSArray * encoders = [self availableComponents];
	General/NSEnumerator *enumerator = [encoders objectEnumerator];
	while (General/NSDictionary* dict = [enumerator nextObject]) {
		General/NSString * name=[dict objectForKey:@"name"];
		for(unsigned int i=2; [encodingPopUpButton itemWithTitle:name]!=nil; ++i)
			name=General/[NSString stringWithFormat:@"%@-%u",[dict objectForKey:@"name"],i];
		// next two lines cause default to "General/QuickTime Movie" if nothing else has been chosen yet
		if(selectedComponentIndex==-1 && [name isEqualToString:@"General/QuickTime Movie"])
			selectedComponentIndex=[encodingPopUpButton numberOfItems];
		[encodingPopUpButton addItemWithTitle:name];
	}
	if(selectedComponentIndex!=-1)
		[encodingPopUpButton selectItemAtIndex:selectedComponentIndex];


The only thing I noticed, was at the General/MovieExportDoUserDialog. Some of the encoders provide the information, how large the encoded file will be, with the actual settings. To do this, you must give the function a     Movie reference. Second  (it does not seem to be necessary if you want to export the whole movie, though) you should provide the function with the time, your exported movie shall have out of the old movie.
Note:     aMovie here is an instance of     General/QTMovie.

    
Movie theMovie = [aMovie quickTimeMovie] ;
General/TimeValue duration = General/GetMovieDuration(theMovie) ;

General/ComponentResult err = General/MovieExportDoUserDialog(exporter, theMovie, NULL, 0, duration, &canceled) ;


General/LorenzHipp

----

Could anyone explain how you can open the dialog with settings already chosen before? Like how General/QuickTime Pro would have already settings for MPEG-4 with settings such as:

http://homepage.mac.com/meddiecatsoft/mpeg4settings.jpg

How can I use the data collected from a previous dialog and open up those settings just like General/QuickTime does?

*I haven't tested it, but calling     General/MovieExportSetSettingsFromAtomContainer() before running the actual dialog might do it.*

----

>*I haven't tested it, but calling     General/MovieExportSetSettingsFromAtomContainer() before running the actual dialog might do it.*

It's correct. I use this method.

Moments Studio

----

For some components (e.g. the General/DivX Pro Codec 6.2) General/MovieExportDoUserDialog returns a value which evaluates to true if they are canceled. So you should test _first_ if the dialog was canceled and _then_ if an error occured.

-- Stefan Heukamp

----

Question 22/08/2006:
Is there a way to display a progress bar to the user while the export is taking place? There appears to be no Notifications sent by the exporting routine.
-- Drarok

----

    
- (BOOL)movie:(General/QTMovie *)movie shouldContinueOperation:(General/NSString *)op withPhase:(General/QTMovieOperationPhase)phase atPercent:(General/NSNumber *)percent withAttributes:(General/NSDictionary *)attributes;


----

Here is a new version of the 'availableComponents' method from above.
The General/OSType fields are strings and the "component" field is now an General/NSValue.
This makes the output easier to read if your using it for debugging purposes.


    

- (General/NSArray *)availableComponents
{
	General/NSMutableArray		*results = nil;
	General/ComponentDescription	cd = {};
	Component		 c = NULL;
	Handle			 nameHandle = General/NewHandle(0);
	
	if ( nameHandle == NULL )
		return( nil );
	
	cd.componentType = General/MovieExportType;
	cd.componentSubType = 0;
	cd.componentManufacturer = 0;
	cd.componentFlags = canMovieExportFiles;
	cd.componentFlagsMask = canMovieExportFiles;

	while((c = General/FindNextComponent(c, &cd)))
	{
		General/ComponentDescription	exportCD = {};
		
		if ( General/GetComponentInfo( c, &exportCD, nameHandle, NULL, NULL ) == noErr )
		{
			General/HLock( nameHandle );
			General/NSString	*nameStr = General/[[[NSString alloc] initWithBytes:(*nameHandle)+1 length:(int)**nameHandle encoding:General/NSMacOSRomanStringEncoding] autorelease];
			General/HUnlock( nameHandle );
			
			exportCD.componentType = CFSwapInt32HostToBig(exportCD.componentType);
			exportCD.componentSubType = CFSwapInt32HostToBig(exportCD.componentSubType);
			exportCD.componentManufacturer = CFSwapInt32HostToBig(exportCD.componentManufacturer);
				
			General/NSString *type = General/[[[NSString alloc] initWithBytes:&exportCD.componentType length:sizeof(General/OSType) encoding:General/NSMacOSRomanStringEncoding] autorelease];
			General/NSString *subType = General/[[[NSString alloc] initWithBytes:&exportCD.componentSubType length:sizeof(General/OSType) encoding:General/NSMacOSRomanStringEncoding] autorelease];
			General/NSString *manufacturer = General/[[[NSString alloc] initWithBytes:&exportCD.componentManufacturer length:sizeof(General/OSType) encoding:General/NSMacOSRomanStringEncoding] autorelease];
			
			General/NSDictionary *dictionary = General/[NSDictionary dictionaryWithObjectsAndKeys:
				nameStr, @"name", General/[NSValue valueWithPointer:c], @"component",
				type, @"type", subType, @"subtype", manufacturer, @"manufacturer", nil];
			
			if ( results == nil ) {
				results = General/[NSMutableArray array];
			}
			
			[results addObject:dictionary];
		}
	}
	
	General/DisposeHandle( nameHandle );
	
	return results;
}



--rjt

----

I had some problems with the new version of "availableComponents" above in combination with Cocoa Bindings. I fixed it by using a General/NSData instead of the General/NSValue. 

--Martin Kahr

----

A note to all you General/QTKit dabblers: General/QTMovie<nowiki/>'s     -writeToFile:... is synchronous, which doesn't really mesh with the idea of a responsive General/NSRunLoop. You can run it in another thread, but you must first detach the movie from the main thread and the component that handles the movie must support threading (which is not true in some notable cases, like .movs using older codecs or some files when Perian is involved). The best solution would be running a satellite helper tool that actually does the exporting.

(Also note that this is true for 32-bit apps only. 10.5 64-bit apps already spawn an helper tool to do the exporting.) -- General/EmanueleVulcano aka l0ne

----
A simpler alternative is to simply call     runModalSession: in the progress callback to keep a modal progress dialog updated. You still block the application but you avoid the beachball and can show the progress of the export. This is what I do in General/QTAmateur and it's a reasonable approach. It's nicer to have exports be non-modal but much more effort to do so. -- General/MikeAsh

----

When I tried this I got some compile errors saying selectedComponentIndex is not declared. You don't mention what that is or how you determine what it's value is.
Also the method:
- (BOOL)writeMovie:(General/QTMovie *)movie toFile:(General/NSString *)file withComponent:(General/NSDictionary *)component withExportSettings:(General/NSData *)exportSettings
you don't mention what component is or how you got it..
can you tell me what I need to do to get that to work, please?

----

selectedComponentIndex is the index of an element in the array returned by availableComponents. You can let the user select this by populating a menu with the array or you can just pass an index. Likewise, component is an element of the array returned by availableComponents.

----
Is there any chance to get this Code as General/XCode Project? Compile didn't work for me... --Andi

----
Any chance that there is one web page in 2011 that tells how to save an audio file from Cocoa?