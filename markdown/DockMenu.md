Is it possible to add images to a dock menu like this?
    
General/NSMenuItem *item1 = [dockMenu addItemWithTitle:@"TEST ITEM"];
item1 = [dockMenu itemAtIndex:0];
[item1 setImage:General/[NSImage imageWithName:@"image1"]];


--General/JoshaChapmanDodson

----

Try it. If it works, the answer is "yes". If it doesn't work, the answer is "no".
Seriously, you'd think that people would try things before they posted their questions.

----

Dock menus don't support images in the menu items I don't believe.

-- General/KentSutherland

----

The list of open windows has a window image. -- > Which is probably internal Apple code. I highly doubt its possible to add images to dock menu items but I have not tried.

----

I think it is possible, but not from Cocoa -- the menu system seems to be Carbon with some Cocoa wrappers, which can only access half the functionality.

----

I haven't tried it, but in 10.3 General/NSMenuItem has     - (void)setAttributedTitle:(General/NSAttributedString *)string, which according to Apple *You can use this method to add styled text and embedded images to menu item strings*

----

So it seems that setting icons on General/NSMenuItem for a dock menu is futile. For my app, the lack of icons is sort of lame, so I plunged into Carbon, but it seems that I am totally not getting something, because even though the calls to get icon from files/apps succeed, the icons displayed are default icons (for apps it is showing the document icon). Any thoughts on what I am missing here?

    
...
  General/IconRef iconRef;
  SInt16 label;
  General/FSSpec spec;

  err = convertPathToFSSpec(fullpath, &spec);
  // I am passing things like /Applications/Some.app, 
  // but that doesn't seem to do the trick.
  // Passing the path of the actual executable doesn't
  // seem to do it either...
			
if(err == noErr)
{
  err = General/GetIconRefFromFile(&spec, &iconRef, NULL);
  if(err == noErr)
  {
    err = General/SetMenuItemIconHandle(gDockMenu
              , menuItem
              , kMenuSystemIconSelectorType
              , iconRef);

    General/ReleaseIconRef(iconRef);
  }
}
	

I have also tried:

    
General/NSImage *icon = General/[[NSWorkspace sharedWorkspace] iconForFile:fullpath];
[icon setSize:General/NSMakeSize(16,16)];
General/NSBitmapImageRep *bitmap = General/[NSBitmapImageRep imageRepWithData:
                [icon General/TIFFRepresentation]];
General/NSData *data = [bitmap representationUsingType:General/NSPNGFileType properties: nil];
General/NSString *iconFile = General/[NSString stringWithFormat: 
                                       @"/tmp/appmenuicons/%@.png", title];
[data writeToFile: iconFile atomically:YES];

NSURL *url = [NSURL fileURLWithPath:iconFile];
General/CGDataProviderRef provider = General/CGDataProviderCreateWithURL(url);
General/CGImageRef image = General/CGImageCreateWithPNGDataProvider(provider
                                          , NULL
                                          , false
                                          ,kCGRenderingIntentDefault);

General/NSLog(@"%d, %d\n", General/CGImageGetWidth(image), General/CGImageGetHeight(image));
// this prints 16x16, so the image loaded.

// specifying kMenuCGImageRefType doesn't show any icon
// but kMenuSystemIconSelectorType again defaults to the default document icon...
err = General/SetMenuItemIconHandle(gDockMenu, menuItem, kMenuSystemIconSelectorType, image);


General/CGDataProviderRelease(provider);
General/CGImageRelease(image);


Any thoughts?

/a
----
Your carbon code is wrong. In particular the line
    
err = General/SetMenuItemIconHandle(gDockMenu , menuItem, kMenuSystemIconSelectorType, iconRef);

Says that your parameter is a 4 char code, registered with creator  kSystemIconsCreator when it is in fact an General/IconRef. You get the default document icon because there is no registered icon with the 4 char code that matches the pointer value of your iconRef. Pass kMenuIconRefType instead.

----

Searching through my list archives I found this. Maybe someone will find it helpful.

*Arbitrary General/NSImages can't be passed across the app->Dock boundary. The only images that can be displayed in a Dock menu are General/IconRefs and images located in your app's bundle that are specified by name. I'm not sure if General/NSMenu supports either of these types of images (I do know they can be specified in Carbon).*