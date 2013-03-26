'''Important:''' Apple Type Services for Fonts is deprecated in Mac OS X v10.6 and later. Please use Core Text instead.

----

I created a great little interface but didn't realize I had used some non system-fonts, so when other people launch it, it looks all whack.  How do I embed these in my application with xcode?

----

You could try copying them into your resources directory and see if they show up in [[NSFontManager]]'s <code>availableFonts</code>. I doubt that'll work though - just make a .tiff image of your text and show it that way.

''Comment: This is possibly the worst advice I've ever seen on this site. Never heard of localization?''

----

You can activate arbitrary fonts (e.g. in your Resources folder) with the Carbon call <code>[[ATSFontActivateFromFileSpecification]]()</code>. Pass in <code>[[ATSFontContextLocal]]</code> as the context if you want the font to be available only to your application.

----

If this type of application was distributed, would there be any copyright issues to worry about?

----

Yes, fonts are copyrighted software and you'd need permission to distribute them.

''Unless the font is in the public domain or under a license that would allow you to do so, of course.''

----
Taken from http://www.cocoabuilder.com/archive/message/cocoa/2005/1/16/125883, this loads all fonts from the application's bundle.

<code>
- (void)loadLocalFonts
{
   [[NSString]] ''fontsFolder;    
   if ((fontsFolder = [[[[NSBundle]] mainBundle] resourcePath])) {
       NSURL ''fontsURL;
       if ((fontsURL = [NSURL fileURLWithPath:fontsFolder])) {
           [[FSRef]] fsRef;
           [[FSSpec]] fsSpec;
           (void)[[CFURLGetFSRef]](([[CFURLRef]])fontsURL, &fsRef);
           if ([[FSGetCatalogInfo]](&fsRef, kFSCatInfoNone, NULL, NULL, &fsSpec,
NULL) == noErr) {
               [[FMActivateFonts]](&fsSpec, NULL, NULL, kFMLocalActivationContext);
           }
       }
   }
}
</code>

----

Does anyone know how to retrieve the [[PostScript]] name from an activated font -- so that you could use [[NSFont]] fontWithName:? The code above assumes that you  know the name of the font you're activating.

----

Okay, answering my own questions is fun. :) If you use [[ATSFontActivateFromFileSpecification]] instead of [[FMActivateFonts]], you're given a font container which you can use with [[ATSFontFindFromContainer]]. This then gives you an array of [[ATSFontRefs]], and then you can finally use [[ATSFontGetPostScriptName]] to obtain the individual typeface names. Isn't [[AppleTypeServices]] fun?

-- [[DustinMacDonald]]

----

[[FMActivateFonts]] is deprecated. it has been replaced with [[ATSFontActivateFromFileSpecification]]

<code>
- (void)loadLocalFonts
{
	[[NSString]] ''fontsFolder;    
	if(fontsFolder = [[[[NSBundle]] mainBundle] resourcePath])
	{
		NSURL ''fontsURL;
		if(fontsURL = [NSURL fileURLWithPath:fontsFolder])
		{
			[[FSRef]] fsRef;
			[[FSSpec]] fsSpec;
			[[CFURLGetFSRef]](([[CFURLRef]])fontsURL, &fsRef);
			if([[FSGetCatalogInfo]](&fsRef, kFSCatInfoNone, NULL, NULL, &fsSpec, NULL) == noErr)
			{
				[[ATSFontActivateFromFileSpecification]](&fsSpec, kATSFontContextLocal, kATSFontFormatUnspecified, 
													 NULL, kATSOptionFlagsDefault, NULL);
			}
		}
	}
}
</code>

----
Could you perhaps load the font data using [[NSData]] and then use [[ATSFontActivateFromMemory]] instead of mucking around with [[FSRef]]<nowiki/>s?

----

[[ATSFontActivateFromFileSpecification]] is deprecated in Leopard.  Here's another version that uses [[ATSFontActivateFromFileReference]] and expects fonts in subdir (Resources/fonts).  Note: be sure to check "Preserve HFS Data" in your build settings if you are copying font suitcases to your resource directory.

<code>
- (BOOL)loadLocalFonts:([[NSError]] ''')err requiredFonts:([[NSArray]] '')fontnames
{
	[[NSString]] ''resourcePath, ''fontsFolder,''errorMessage;    
  NSURL ''fontsURL;
  resourcePath = [[[[NSBundle]] mainBundle] resourcePath];
  if (!resourcePath) 
  {
    errorMessage = @"Failed to load fonts! no resource path...";
    goto error;
  }
  fontsFolder = [[[[[NSBundle]] mainBundle] resourcePath] stringByAppendingPathComponent:@"/fonts"];
  
  [[NSFileManager]] ''fm = [[[NSFileManager]] defaultManager];
  
  if (![fm fileExistsAtPath:fontsFolder])
  {
    errorMessage = @"Failed to load fonts! Font folder not found...";
    goto error;
  }
  if(fontsURL = [NSURL fileURLWithPath:fontsFolder])
  {
    [[OSStatus]] status;
    [[FSRef]] fsRef;
    [[CFURLGetFSRef]](([[CFURLRef]])fontsURL, &fsRef);
    status = [[ATSFontActivateFromFileReference]](&fsRef, kATSFontContextLocal, kATSFontFormatUnspecified, 
                                              NULL, kATSOptionFlagsDefault, NULL);
    if (status != noErr)
    {
      errorMessage = @"Failed to acivate fonts!";
      goto error;
    }
  }
  if (fontnames != nil)
  {
    [[NSFontManager]] ''fontManager = [[[NSFontManager]] sharedFontManager];
    for ([[NSString]] ''fontname in fontnames)
    {
      BOOL fontFound = [[fontManager availableFonts] containsObject:fontname]; 
      if (!fontFound)
      {
        errorMessage = [[[NSString]] stringWithFormat:@"Required font not found:%@",fontname];
        goto error;
      }
    }
  }
  return YES;
error:
  
  if (err != NULL) {
    [[NSString]] ''localizedMessage = [[NSLocalizedString]](errorMessage, @"");
    [[NSDictionary]] ''userInfo = [[[NSDictionary]] dictionaryWithObject:localizedMessage forKey:[[NSLocalizedDescriptionKey]]];
    ''err = [[[[NSError]] alloc] initWithDomain:[[NSCocoaErrorDomain]] code:0 userInfo:userInfo];
  }
  
  return NO;

}
</code>

This is how you might use it:

<code>
if (![self loadLocalFonts:&err requiredFonts:[[[NSArray]] arrayWithObject:@"[[BellGothicBT]]-Black"]])
{
  [[NSAlert]] ''alert = [[[NSAlert]] alertWithError:err];
  [alert runModal];
  exit(0);
}
</code>

----

Snow Leopard has a new [[CTFontManager]] object for loading fonts. See [[CTFontManagerRegisterFontsForURL]]()
http://developer.apple.com/mac/library/documentation/Carbon/Reference/CoreText_FontManager_Ref/Reference/reference.html

----

There sure is a lot of code on this page for doing something that only requires using the [[ATSApplicationFontsPath]] Info.plist key.
http://developer.apple.com/mac/library/documentation/[[MacOSX]]/Conceptual/[[BPRuntimeConfig]]/Articles/[[PListKeys]].html#//apple_ref/doc/uid/20001431-SW8