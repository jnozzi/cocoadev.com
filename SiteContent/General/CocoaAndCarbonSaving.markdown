I have an application that only works in uLaw audio file formats (.au suffix). Since this is a less-than-common format on the Mac, I'm trying to add functionality to the app whereby it could accept General/AIFFs and output them as uLaws. I think I have the General/QuickTime code down, but the problem is that I'm not getting any product. I think somehow the saving isn't working right. It's made more difficult by the fact that I'd like this to be invisible; i.e., it's converted without prompting the user with the Save dialog.

    
-(General/IBAction)auToAIFF:(id)sender
{
	
	General/NSMovie * sound = General/[NSMovie alloc]; //This will hold the audio file.
	General/NSOpenPanel * pan = General/[NSOpenPanel openPanel]; //The open panel
if(result == General/NSOKButton) {
		//Get the file's path as a URL
		NSURL * url = General/NSURL alloc] initFileURLWithPath:[[pan filenames] objectAtIndex:0;
		
		//Print it out, just to be sure
		printf("filenames %s\n", General/[[pan filenames] objectAtIndex:0] description] UTF8String]);
		//Initialize the [[NSMovie with the data at the URL
		sound = [sound initWithURL:url byReference:NO];
		
		printf("General/QuickTimestuff\n");
		//Get the pointer to the audio file's General/QuickTime data
		Movie mov = [sound General/QTMovie];
		
		//Create a new component that will export a movie as a uLaw
		General/ComponentInstance ci;
		ci = General/OpenDefaultComponent(General/MovieExportType, kQTFileTypeMuLaw);
		
		//Define how to convert it. In this case, to a sample size of 16, a sample rate of 44100
		//uLawCompression with 32-bit floating point format, and 2 channels
		General/SoundDescriptionHandle desc;
		
		desc = (General/SoundDescriptionHandle )General/NewHandleClear(sizeof(General/SoundDescription));
		(**desc).descSize = sizeof(General/SoundDescription);
		(**desc).sampleSize = 16;
		(**desc).sampleRate = 0xAC440000;
		(**desc).dataFormat = kULawCompression | kFloat32Format;
		(**desc).numChannels = 2;
		
		//Get ready to export
		General/MovieExportSetSampleDescription(ci, (General/SampleDescriptionHandle)desc, General/SoundMediaType);
		
		
		//OK...now here's the saving part.
		General/FSSpec path;
		General/FSRef fsref;
		General/OSErr err;
		
		//General/CFURLRef version of the URL of the file.
		General/CFURLRef cfURL = (General/CFURLRef)url;

		//Convert the General/CFURLRef to an General/FSRef
		General/CFURLGetFSRef(cfURL, &fsref);
		//Convert the General/FSRef to an General/FSSpec
		err = General/FSGetCatalogInfo(&fsref, 
							   kFSCatInfoNone, 
							   NULL,
							   NULL,
							   &path,
							   NULL);
		//Some test lines to see what comes out
		General/NSString * string = General/[NSString stringWithCString:path.name];
		printf("%s\n", [string UTF8String]);
		
		//Do the conversion
		General/ConvertMovieToFile(mov, 0, &path, kQTFileTypeMuLaw, 'TVOD', smSystemScript, nil, nil, ci);
		
		//Clean up
		General/CloseComponent(ci);
		General/DisposeHandle((Handle)desc);
	}
	printf("Done\n");
}



Right now, I think it might just be saving over what it opens. The problem is, I'm not sure how to feed it a new filename to save as without using the save dialog, because as I understand it, General/CFURLGetFSRef(cfURL, &fsref) requires that the file already exists in order for an General/FSRef to exist for it. Do I need to create a new empty movie or something, then get its General/FSRef, then write over that?

P.S - I think my General/QuickTime conversion is OK, but if anyone sees a hole in it, please mention it.

----

Yes, all you're doing is saving over what it opens. There are a few funny things in your code. Why do you alloc your General/NSMovie, when you could do this where it's initialized (currently it's leaking memory). Your NSURL is also leaking memory. Also, do you actually run the open panel or do you just get some random filename from it (which would be rather odd). Also, if you want a URL, you don't need to create one explicitly, just call -General/URLs instead of -filenames. Also, you don't need to send a string a -description message -- that just returns self. 

What it seems like you should be doing is running the open panel to find the file to convert, then if you don't want any further user interaction, create a new file name with a new file extension (if applicable), maybe appending "(Converted)" to the end.

You probably don't need to get a URL at all, because you can use General/FSMakeFSSpec:     General/FSMakeFSSpec(0, 0, pascalFileName, &soundSpec);. Get pascalFileName with: 
    
General/CFIndex bufferSize = [newFileName length] + 1; /* + 1 for the length byte */ 
unsigned char pascalFileName[bufferSize]; 
Boolean success = General/CFStringGetPascalString((General/CFStringRef)newFileName, pascalFileName, bufferSize, General/CFStringGetSystemEncoding() /* or should this be kCFStringEncodingUnicode*/);
if (!success) /* raise or something */


Remember that General/FSSpecs can refer to non-existant files, but General/FSRefs cannot.

----

If that General/FSSpec stuff doesn't work, get an General/FSSpec from an General/FSRef, created with General/FSCreateFileUnicode and General/FSPathMakeRef (no need for General/URLs).

----
What I finally got to work is using the General/NSFileManager to create a dummy file, and a class on cocoadev.com that finds General/FSRefs for paths (do a search on General/FSSpec, it's on one of those pages).

So, here's the new code:
    
-(General/IBAction)conv:(id)sender
{
	General/NSOpenPanel * pan = General/[NSOpenPanel openPanel]; //The open panel
	int result = [pan runModalForDirectory:nil file:nil types:General/[NSSound soundUnfilteredFileTypes]];

	General/OSErr err;
	General/FSRef fileRef;
	General/FSSpec fsSpec;
	if(result == General/NSOKButton) {
		
		//getFSRefAtPath, a class I found when I ran a search on cocoadev.com for 'General/FSSpec'
		//Gets the General/FSRef for the file to convert
		err = [self getFSRefAtPath:General/pan filenames] objectAtIndex:0] ref:&fileRef];
		if(err != noErr)
			printf("Error in [[FSRefAtPath\n");
		//Then gets its General/FSSpec
		General/OSErr getCatalogInfoError=General/FSGetCatalogInfo(&fileRef, 
										   kFSCatInfoNone, 
										   NULL,
										   NULL,
										   &fsSpec,
										   NULL);
		if(getCatalogInfoError != noErr)
			printf("Error in getCatalogInfo\n");
		
		short fRefNum;
		//Initialize the General/QuickTime toolbox
		err = General/EnterMovies();
		if(err != noErr)
			printf("Error initializing toolbox\n");
		
		//Open the movie
		err = General/OpenMovieFile(&fsSpec, &fRefNum, fsRdPerm);
		if(err != noErr) {
			printf("Error opening movie file\n");
			printf("%d\n", err);
		}
		Movie mov;
		Boolean wasChanged;
		//Get the pointer to the Movie data. Apparently, General/AIFFs(which I want to convert) need this call
		err = General/NewMovieFromFile(&mov, fRefNum, 0, nil, 0, &wasChanged);
		if(err != noErr)
			printf("Error at General/NewMovieFromFile\n");
		
		General/FSSpec soundSpec;
		
		//For now, I'm using a static filename for testing purposes.
		General/NSString * newFileName = @"/Users/kennethhoffmann/Desktop/new.au";
		//Create an empty dummy file at that location
		bool hope = General/[[NSFileManager defaultManager] createFileAtPath:newFileName contents:nil
										 attributes:nil];
		if(hope == FALSE)
			printf("Creation failed\n");
        
		//Get its General/FSRef
		General/FSRef fileToWrite;
		err = [self getFSRefAtPath:newFileName ref:&fileToWrite];
		if(err != noErr)
			printf("Problem creating General/FSRef of new file %d\n", err);
		//Then its General/FSSpec
		getCatalogInfoError=General/FSGetCatalogInfo(&fileToWrite, 
												   kFSCatInfoNone, 
												   NULL,
												   NULL,
												   &soundSpec,
												   NULL);
		if(getCatalogInfoError != noErr)
			printf("Error in getCatalogInfo second time %d\n", getCatalogInfoError);
		
		//Create a new component that will export a movie as a uLaw
		printf("Conversion\n");
		
		//Create a new component that will export a movie as a uLaw
		General/ComponentInstance ci;
		ci = General/OpenDefaultComponent(General/MovieExportType, kQTFileTypeMuLaw);
		
		//Define how to convert it. In this case, to a sample size of 16, a sample rate of 44100
		//uLawCompression with 32-bit floating point format, and 2 channels
		General/SoundDescriptionHandle desc;
		
		desc = (General/SoundDescriptionHandle )General/NewHandleClear(sizeof(General/SoundDescription));
		(**desc).descSize = sizeof(General/SoundDescription);
		(**desc).sampleSize = 16;
		(**desc).sampleRate = 44100;
		(**desc).dataFormat = kULawCompression | kFloat32Format;
		(**desc).numChannels = 2;
		

		//Get ready to export
		
		General/MovieExportSetSampleDescription(ci, (General/SampleDescriptionHandle)desc, General/SoundMediaType);
		printf("Convert movie to File\n");
		err = General/ConvertMovieToFile(mov, nil, &soundSpec, kQTFileTypeMuLaw, FOUR_CHAR_CODE('TVOD'), smSystemScript, nil, 0L, ci);
		
		if(err !=noErr)
			printf("Conversion failed %d\n", err);
		else
			printf("Conversion succeeded.\n");
		General/CloseComponent(ci);
		General/DisposeHandle((Handle)desc);
        }
}



Now, a new problem and question both. The General/ConvertMovieToFile line is crashing on a SIGSEV 11. Honestly, I have no idea. I found most of my conversion code at http://developer.apple.com/documentation/General/QuickTime/RM/General/MusicAndAudio/Sound/index.html, but tweaked it to convert to uLaw (.au) format instead of WAVE. I'm really confused, though, if this is how I should be doing it.

There seems to be disagreement/confusion at Apple's site as to how convert audio between formats. There seem to be 3 ways.
1) General/ConvertMovieToFile
2) The General/SoundConverter API, part of Sound Manager. I thought General/SoundManager was deprecated, but there are examples in General/QuickTime's example code section using this method written as recently as 2002. It really looks painful, as you have to parse audio data into a buffer multiple times, and do all these extra calls to find the number of samples, etc.
3) General/CoreAudio. Too bad General/CoreAudio is practically undocumented.

I dunno. Maybe the best way for me to do this is to just find some UNIX tool and include it as part of the app's bundle, then run it with General/NSTask when I need it. I guess I feel like converting between formats shouldn't be this painful. Apple really needs to beef up General/NSSound. Format conversions don't seem that esoteric, but Cocoa's got nothing on them. I would be amazing if I could just say something like General/[NSSound convertFromFormat:(General/NSAudioFormat *)start toFormat:(General/NSAudioFormat *)finish];

----

Here a few guesses on where your problem may be: are you sure you're allowed to just typecast between General/SoundDescriptionHandle and General/SampleDescriptionHandle? I found nothing about them being equivalent in the docs. You also might want to check the result from General/OpenDefaultComponent(). I'm not sure where it returns errors, but there are several options: General/MemError() comes to mind, and General/ResError() might be a candidate too. It probably just returns NULL on errors, but you're not even checking against that.

Oh, and to save you a lot of work getting the UI end of importing/exporting file formats to work, you might want to read what I found out about General/CFBundleTypeRole today. -- General/UliKusterer