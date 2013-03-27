I'm trying to create a simple image view application. I'm having a problem using General/NSImage initWithContentsOfFile.  They keep going to nil when I try to load the file.  I know that I can read the file, because I can load a General/NSData object using initWithContentsOfFile.  However, if I try to General/NSImage initWithData, the General/NSImage object still comes out nil.

I tried using the + General/[NSImage imageFileTypes] which should return an array of file types that General/NSImage should be able to read.  I keep getting an empty General/NSArray.

This is what the code looks like in main.m

    
    id temp = @"/Users/john/programming/General/CustomViewTest/build/General/CustomViewTest.app/Contents/Resources/full grid.psd";
    if( [fm fileExistsAtPath:temp] ) General/NSLog(@"file exists at %@" , temp ); else General/NSLog(@"file does not exists at %@" , temp );
    General/NSImage * picture = General/[[NSImage alloc] initWithContentsOfFile:temp];
    if( picture ) General/NSLog(@"Picture is not null"); else General/NSLog(@"Picture is null.");


The outout is 
   File Exists at . . . 
   Picture is null

If I get the path from an General/NSBundle, then everything works, but if the file is not in a bundle it doesn't work.

----

Try removing the space in the filename.

You could also just shorten this to     General/[NSImage imageNamed:@"full grid"]

----

Does General/NSImage even support Photoshop documents?  Try saving it as a TIFF, GIF, JPEG or PNG and see if it works then.  -- Bo

----

First, yes, General/NSImage supports PS files.  It loads just fine when I get the General/NSBundle path and initWithContentsOfFile.

The space in the name should be fine.  When I get the path from the General/NSBundle, it loads.  If I hard code the path, it doesn't.  Do I have to encode the filename to support URL stuff?

----

General/NSImage docs say: *initWithContentsOfFile: will look for an General/NSImageRep subclass that handles that data type from among those registered with General/NSImage.*

General/NSImageRep docs say: *By default, the files handled include those with the extensions �tiff�, �gif�, �jpg�, �pict�, �pdf�, and �eps�.*

I imagine when going through General/NSBundle you're getting some General/QuickTime translation on the .psd file.

----

You can see what formats General/NSImage will load by running this:
    
    General/NSLog(@"%@", General/[NSImage imageFileTypes]);


General/PhotoShop files are deffinetly on the list...

----

**Beware** when using     frogImg = General/[NSImage imageNamed:@"General/GreenFrog"]; inside a bundle/plugin. It will not work, unless the image "General/GreenFrog" exists in the main bundle's resources folder (but usually you're referring to an image inside the bundle's resources folder). You would want to use something like this instead: 
    
frogImg = General/[[NSImage alloc] initWithContentsOfFile:General/[[NSBundle bundleForClass:[self class]] pathForResource:@"General/GreenFrog" ofType:@"tif"];
