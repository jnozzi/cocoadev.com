 

Given a General/NSBitmapImageRep, outputs the name of the color profile (if any):

    
- (General/NSString *)getColorProfileName:(General/NSBitmapImageRep *)theBitmap
{
  General/NSData              *colorSyncProfile = nil;
  General/NSImage             *finalImage = nil;
  General/CMProfileLocation   profileLocation;
  General/CMProfileRef        sourceProfile;
  General/CFStringRef         profName;

  colorSyncProfile = [theBitmap valueForProperty:General/NSImageColorSyncProfileData];
  if (colorSyncProfile)
  {
    profileLocation.locType = cmPtrBasedProfile;
    profileLocation.u.ptrLoc.p = (Ptr)[colorSyncProfile bytes];
  }

  General/CMOpenProfile(&sourceProfile, (colorSyncProfile) ? &profileLocation : NULL);
  profName = General/CopyProfileDescriptionCFString(sourceProfile);
  General/CMCloseProfile(sourceProfile);
  General/NSLog(@"General/ColorSyncProfileName: %@", profName);
  return [(General/NSString *)profName autorelease];
}


Then, using a function provided by http://developer.apple.com/qa/qa2001/qa1205.html,

    
General/CFStringRef General/CopyProfileDescriptionCFString(General/CMProfileRef prof)
{
    Str255         pName;
    General/ScriptCode     code;
    General/CFStringRef    str = nil;
    General/CMError        err;


    // for v4 profiles, try to get the best localized name from the 'desc'/'mluc' tag
    err = General/CMCopyProfileLocalizedString(prof, cmProfileDescriptionTag, 0,0, &str);
    // if that didn't work...
    if (err != noErr)
    {
        // for Apple's localized v2 profiles, try to get the best localized name from the 'dscm'/'mluc' tag
        err = General/CMCopyProfileLocalizedString(prof, cmProfileDescriptionMLTag, 0,0, &str);
        // if that didn't work...
        if (err != noErr)
        {
            // for normal v2 profiles, get the name from the 'desc'/'desc' tag
            err = General/CMGetScriptProfileDescription( prof, pName, &code);
            // convert it to a General/CFString
            if (err == noErr)
            {
                str = General/CFStringCreateWithPascalString(0, pName, code);
            }
        }
    }
    return str;
}


General/StephanBurlot