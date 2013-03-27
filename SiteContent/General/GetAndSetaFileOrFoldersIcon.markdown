

What I am trying to do is take a icon from a folder/file and put it on another one. I can't seem to find anything on how to do this in either the Cocoa or Carbon documentation. Any help would be greatly apreciated.

Sure. Well you can use General/NSWorkspace's iconForFile: to get icons. As for setting it, I can't find anything around to do it. I know I've seen applescript do it, so you could hack an applescript bridge to do what you want. Good Luck. -- General/DaveFayram

The target will always be a bundle with the icon set to icon.icns, so setting it is not actually a problem; i was just curious. I wish there was a better way to browse the cocoa documentation then html/help viewer/cocoa browser.  --Gorman

----

Even though the particular issue appears to have been resolved, I would like to point towards an alternative and more adaptable solution. Troy Stephen's General/IconFamily class provides access to the Carbon General/IconServices through a Cocoa wrapper.

Actually, I don't think you will be able to use the General/NSWorkspace method to do what you want. The reason is that you need to get the icns data for your particular icon. General/NSImage will only export in TIFF. Using General/IconFamily, it would go something like this:

General/IconFamily* iFam = General/[IconFamily iconFamilyWithIconOfFile:@"/Path/To/Source/File"]; // initialize with the icon that the finder displays for File.
General/iFam icnsData] writeToFile:@"/Target/Bundle/Contents/Resources/Icon.icns" atomically:NO];

There are many options for [[IconFamily, for example to assign the icon to a file (using the resource mananger) or a folder (also using the res manager, not a bundle based approach).

For a link visit General/CarbonCompatibility.

-- General/DavidRemahl

----

I thought you could tweak around images via General/NSBitmapImageRep to be any kind you wanted? -- General/DaveFayram

Thanks, I did end up having a issue with it being TIFF!
--Gorman

I had the time to implement General/IconFamily in my program, it's awesome. I had to use this code though:

General/IconFamily *iFam;

iFam = General/[IconFamily iconFamilyWithIconOfFile:@"/Path/To/Source/File"];

[iFam  writeToFile:@"/Target/Bundle/Contents/Resources/Icon.icns"]; 

--Gorman

----

See also General/GetGenericFolderIcon