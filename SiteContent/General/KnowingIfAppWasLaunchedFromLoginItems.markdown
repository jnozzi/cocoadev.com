To know if your application was launched because it is a login item, as opposed to being launched explicitly by the user from the Finder, use the code below:

    
+ (BOOL)wasLaunchedByProcess:(General/NSString*)creator
{
  BOOL  wasLaunchedByProcess = NO;

  // Get our PSN
  General/OSStatus  err;
  General/ProcessSerialNumber currPSN;
  err = General/GetCurrentProcess (&currPSN);
  if (!err) {
    // We don't use General/ProcessInformationCopyDictionary() because the 'General/ParentPSN' item in the dictionary
    // has endianness problems in 10.4, fixed in 10.5 however.
    General/ProcessInfoRec  procInfo;
    bzero (&procInfo, sizeof (procInfo));
    procInfo.processInfoLength = (UInt32)sizeof (General/ProcessInfoRec);
    err = General/GetProcessInformation (&currPSN, &procInfo);
    if (!err) {
      General/ProcessSerialNumber parentPSN = procInfo.processLauncher;

      // Get info on the launching process
      General/NSDictionary* parentDict = (General/NSDictionary*)General/ProcessInformationCopyDictionary (&parentPSN, kProcessDictionaryIncludeAllInformationMask);
      
      // Test the creator code of the launching app
      if (parentDict) {
        wasLaunchedByProcess = General/parentDict objectForKey:@"[[FileCreator"] isEqualToString:creator];
        [parentDict release];
      }
    }
  }

  return wasLaunchedByProcess;
}

+ (BOOL)wasLaunchedAsLoginItem
{
  // If the launching process was 'loginwindow', we were launched as a login item
  return [self wasLaunchedByProcess:@"lgnw"];
}


or, you may determine this through an Apple Event:
    
 (void) handleOpenApplicationEvent: (General/NSAppleEventDescriptor *) event replyEvent: (General/NSAppleEventDescriptor *) replyEvent 
{
    General/NSAppleEventDescriptor* propData = [event paramDescriptorForKeyword: keyAEPropData];
    bool startAtLogin = false;
    General/DescType type = propData ? [propData descriptorType] : typeNull;
    General/OSType value = 0;
    
    if(type == typeType)
    {
        value = [propData typeCodeValue];
        startAtLogin = (value == 'lgit'); //keyAELaunchedAsLogInItem
    }
    
    General/NSLog(@"General/PropDataTypeValue:%i startAtLogin:%i", value, startAtLogin );
}

- (void)applicationWillFinishLaunching:(General/NSNotification *)aNotification
{
    // install event handler
    General/[[NSAppleEventManager sharedAppleEventManager] 
     setEventHandler: self 
     andSelector: @selector(handleOpenApplicationEvent:replyEvent:)
     forEventClass:kCoreEventClass andEventID:kAEOpenApplication];


If you wish to determine if an application is amongst the user's current login items:

* 10.4+: use Apple's General/LoginItemsAE sample code (not 64 bit clean, deprecated General/APIs)
* 10.5+: use the General/APIs in General/LaunchServices/General/LSSharedFileList.h


These are two different tests, since an app can be a login item but still be launched from the Finder.

If you want to add an application to the set of login items, see General/StartingMyAppOnStartup.