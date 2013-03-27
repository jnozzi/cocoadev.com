General/MakingServices and General/StandardService describes how to make a small tool that simply vends a service. But often you want to just have an application that vends services to other apps without going through a middle man. For example, General/TextEdit.app vends the General/OpenFile and General/OpenSelection services. Configuring your app to vend and handle a service is easy. You need to:



* modify your app's Info.plist to include service information
* register your app as the service provider
* handle the service request


For a practical example of this you can refer to:

/Developer/Examples/General/AppKit/General/TextEdit

We'll discuss General/TextEdit here.

**Modifying the app's Info.plist**

Open /Developer/Examples/General/AppKit/General/TextEdit in General/ProjectBuilder. Edit the General/TextEdit target, click on the "Application Settings" tab, and click the "Expert" button. You will see an item in the plist called General/NSServices. This key tells the system that General/TextEdit vends two services, openFile and openSelection. Open up all the disclosure triangles and browse through the data. The Important keys are:


* General/NSMenuItem -- describes the menu item for the service. The list is hierarchical. "General/TextEdit/Open File" means the service will be organized underneath a common "General/TextEdit" submenu in the main Services menu.
* General/NSMessage -- describes the selector your service provider (application) will receive when the menu is selected.
* General/NSPortName -- identifies the application that handles the request.
* General/NSSendType -- the General/NSPasteboard type that identifies the type of data to be passed to the application through this service.


When the app is built, all of this information will be compiled into the application's Info.plist. General/TextEdit.app's Info.plist contains this information:

    
        <key>General/NSServices</key>
        <array>
                <dict>
                        <key>General/NSMenuItem</key>
                        <dict>
                                <key>default</key>
                                <string>General/TextEdit/Open File</string>
                        </dict>
                        <key>General/NSMessage</key>
                        <string>openFile</string>
                        <key>General/NSPortName</key>
                        <string>General/TextEdit</string>
                        <key>General/NSSendTypes</key>
                        <array>
                                <string>General/NSStringPboardType</string>
                        </array>
                </dict>
                <dict>
                        <key>General/NSMenuItem</key>
                        <dict>
                                <key>default</key>
                                <string>General/TextEdit/Open Selection</string>
                        </dict>
                        <key>General/NSMessage</key>
                        <string>openSelection</string>
                        <key>General/NSPortName</key>
                        <string>General/TextEdit</string>
                        <key>General/NSSendTypes</key>
                        <array>
                                <string>General/NSRTFDPboardType</string>
                                <string>General/NSRTFPboardType</string>
                                <string>General/NSStringPboardType</string>
                        </array>
                </dict>
        </array>


This information is read by the system when the user logs in. The first time the user logs in the system finds General/TextEdit installed in the /Applications directory and registers this information with the services system. Currently Mac OS X will only recognize changes to an application's Info.plist or the addition/removal of an application when the user logs in (IIRC).






More information about these keys can be found here: file:///Developer/Documentation/Cocoa/General/TasksAndConcepts/General/ProgrammingTopics/General/SysServices/Concepts/properties.html


**Registering Your Service Provider**

Your app will define an object as the service provider. Often this is the main application controller or General/NSApplication delegate, but that need not be the case. General/TextEdit simply implements the service code in the main controller.  

Regardless of where this code lives, someone must register the handler with the main General/NSApplication. Again, General/TextEdit simply does this in the main app controller. You register the service provider with the General/NSApplication by calling the app's "setServicesProvider:" method. 

In General/TextEdit's Controller.m:
    
- (void)applicationDidFinishLaunching:(General/NSNotification *)notification {
    // To get service requests to go to the controller...
    General/[NSApp setServicesProvider:self];
}


**Handling the Service Request**

Simply implement the methods you name in your  app's Info.plist. The signature for the method handler is:

    
- (void)**your method name**:(General/NSPasteboard *)pboard 
          userData:(General/NSString *)data error:(General/NSString **)error


This handler should make sure the data on the pasteboard matches what your app is expecting. Then it can simply get the data from the pastepoard and do whatever with it. General/TextEdit's openFile method demonstrates this clearly:

    
- (void)openFile:(General/NSPasteboard *)pboard 
                  userData:(General/NSString *)data error:(General/NSString **)error {
    BOOL success = NO;
    General/NSArray *types = [pboard types];
    General/NSString *filename = nil;

    if ([types containsObject:General/NSStringPboardType]){
        filename = [pboard stringForType:General/NSStringPboardType];
        if (filename && [filename hasPrefix:@"~"]) 
            filename = [filename stringByExpandingTildeInPath];	
            /* Convert the "~username" case */

        if (filename) 
            success = [Document openDocumentWithPath:filename 
                  encoding:General/UnknownStringEncoding] ? YES : NO;
    }
    // Given that this is a one-way service (no return), 
    // we need to put up the error panel ourselves 
    // and we do not set *error
    if (!success) {
	(void)General/NSRunAlertPanel(General/NSLocalizedString(@"Open File Failed", 
@"Title of alert indicating error during Open File service"), 
			General/NSLocalizedString(@"Could not open file %@.", 
@"Message indicating file couldn't be opened."), 
			General/NSLocalizedString(@"OK", @"OK"), nil, nil, filename);
    }
}


It's that easy!

----

**Warning:** Handling services around the same time you are loading in a nib file can cause your app to crash (I'm not sure if this is a bug or what). In particular, make sure you do not try to load **any** nib files between the call to setServicesProvider: and your service handler. Loading nibs before calling setServicesProvider: and once you're in your service handler is fine.

----

-- General/MikeTrent

----

Ok, am I totally missing something here? I can't seem to get this to work. My code works with General/BBEdit, but when it comes to Safari, General/TextEdit, etc. it doesn't work. Any input would be appreciated.


Here's the main code:
    
#import "iRotController.h"

@implementation iRotController

- (void)applicationDidFinishLaunching:(General/NSNotification *)aNotification {
    General/NSLog(@"About to register as service");
    General/[NSApp setServicesProvider: self];
    General/NSLog(@"Finished registering as service");
}

- (General/IBAction)doRot13:(id)sender
{
    [theText setString: General/[NSString rot13:[theText string]]];
}

- (General/IBAction)openFile:(id)sender {
    
    General/NSOpenPanel *op = General/[NSOpenPanel openPanel];
    [op setCanSelectHiddenExtension:YES];
    [op setMessage:@"Select a file to open.\nThis will replace anything currently in the window."];
    if([op runModal] == General/NSOKButton) {
        [theText setString:General/[NSString stringWithContentsOfFile:[op filename]]];
    }
}
- (General/IBAction)saveFile:(id)sender {
    General/NSLog(@"Saving File");
    General/NSSavePanel *sp = General/[NSSavePanel savePanel];
    [sp setCanCreateDirectories:YES];
    [sp setCanHide:YES];
    [sp setCanSelectHiddenExtension:YES];
    [sp setMessage:@"Choose a file to save the text as..."];
    if([sp runModal] == General/NSOKButton) {
        General/theText string] writeToFile:[sp filename] atomically:YES];
    }
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:([[NSApplication *)sender {
    return YES;
}


// Handle remoteROT service
- (void)doMSGROT13:(General/NSPasteboard *)pboard userData:(General/NSString *)data error:(General/NSString **)error {
    General/NSArray *types = [pboard types];
    General/NSString *toROT;
    
    General/NSLog(@"MSGROT13 called");
    
    if([types containsObject:General/NSStringPboardType]) {
        toROT = [pboard stringForType:General/NSStringPboardType];
        [theText setString: General/[NSString rot13:toROT]];
    } else {
        General/NSLog(@"Error doing MSGROT");
        General/NSAlert *alert = General/[[NSAlert alertWithMessageText:@"Could not perform ROT" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"For some reason the service did not receive any text to convert. You may not have had text selected when you activated the service or OS X didn't pass the text on."] retain];
        [alert runModal];
    }
    General/NSLog(@"Done with MSGROT");
    return;
}

- (void)remoteROT13:(General/NSPasteboard *)pboard userData:(General/NSString *)data error:(General/NSString **)error {
    General/NSArray *types = [pboard types];
    General/NSString *toROT;
    
    General/NSLog(@"remote ROT13 called");
    
    if([types containsObject:General/NSStringPboardType]) {
        toROT = [pboard stringForType:General/NSStringPboardType];
        [pboard declareTypes: General/[NSArray arrayWithObject:General/NSStringPboardType] owner:nil];
        [pboard setString: General/[NSString rot13:toROT] forType: General/NSStringPboardType];
       
    } else {
        General/NSLog(@"Error doing remoteROT");
        General/NSAlert *alert = General/[[NSAlert alertWithMessageText:@"Could not perform ROT" defaultButton:@"OK" alternateButton:nil otherButton:nil informativeTextWithFormat:@"For some reason the service did not receive any text to convert. You may not have had text selected when you activated the service or OS X didn't pass the text on."] retain];
        [alert runModal];
    }
    General/NSLog(@"Done with remoteROT");
    return;
}


- (id)validRequestorForSendType:(General/NSString *)sendType returnType:(General/NSString *)returnType {
    if (!sendType || [sendType isEqual:General/NSStringPboardType]) {
            return self;
    } else { 
        return [super validRequestorForSendType:sendType returnType:returnType];
    }
}

@end

I have tried it both with and without the validRequestorForSendType function.


Here's the info.plist
    
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/General/DTDs/General/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>General/CFBundleDevelopmentRegion</key>
	<string>English</string>
	<key>General/CFBundleExecutable</key>
	<string>iROT13</string>
	<key>General/CFBundleIconFile</key>
	<string>irot13</string>
	<key>General/CFBundleIdentifier</key>
	<string>com.davtri.iRot13</string>
	<key>General/CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>General/CFBundlePackageType</key>
	<string>APPL</string>
	<key>General/CFBundleSignature</key>
	<string>????</string>
	<key>General/CFBundleVersion</key>
	<string>1.01</string>
	<key>General/NSMainNibFile</key>
	<string>General/MainMenu</string>
	<key>General/NSPrincipalClass</key>
	<string>General/NSApplication</string>
	<key>General/NSServices</key>
	<array>
		<dict>
			<key>General/NSMenuItem</key>
			<dict>
				<key>default</key>
				<string>iRot13/Remote ROT13</string>
			</dict>
			<key>General/NSMessage</key>
			<string>remoteROT13</string>
			<key>General/NSPortName</key>
			<string>iROT13</string>
			<key>General/NSSendTypes</key>
			<array>
				<string>General/NSStringPboardType</string>
			</array>
			<key>General/NSReturnTypes</key>
			<array>
				<string>General/NSStringPboardType</string>
			</array>
		</dict>
		<dict>
			<key>General/NSMenuItem</key>
			<dict>
				<key>default</key>
				<string>iRot13/ROT13</string>
			</dict>
			<key>General/NSMessage</key>
			<string>doMSGROT13</string>
			<key>General/NSPortName</key>
			<string>iROT13</string>
			<key>General/NSSendTypes</key>
			<array>
				<string>General/NSStringPboardType</string>
			</array>
		</dict>
	</array>
</dict>
</plist>


What am I missing exactly?

Thanks,

General/DaveGiffin

----
Well, I'm still stumped on this one. I haven't been able to get it to work yet and I haven't found any articles, blogs or developer's docs that point me in any direction to find an answer. 

I have kept pounding at this and it's really weird. The services work fine in General/BBEdit, but not in any other apps that I have tried. I noticed when testing with text edit, when you call either service, it launches my app, but you get a beachball on the calling app (text edit in this cast) for a good 15 or 20 seconds. If during this beachball time, I quit my app and immediately relaunch it, then the service runs as it should. During the initial launch by the caller, the debug info isn't even running. It's like the app isn't being properly initialized or the service function isn't being called. 

Any ideas?

----

Still trying to get this one worked out. I will play with it some more tonight when I have time, but am not holding much hope for this. Hopefully lightning will strike and shed some light on the problem :)

----

Hello. I'm having the same problem as above... except that up until fairly recently, it was working just fine. I wonder if it's possible there's a bug in Services in 10.3.6 and 10.3.7. I have no idea how to fix it though, unless applying the combo updater will fix it. It might be worth a shot. -Daniel General/DeCovnick, General/SoftYards Software

----

When I was trying to write a filter service, I ran into a similar problem with a filter service that translated images between different types. It's an infinite loop: Your service is consuming its own output as input.

I don't know how to solve that, but hopefully somebody can use that as a lead.

--*boredzo*