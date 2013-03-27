

Apple's Class Reference: http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Classes/NSWorkspace_Class/

This is a great Class that has all sorts of stuff in it.  You can think of the Workspace as the Finder - most methods in this class do something related to files or volumes.

[Topic]

----

When using General/NSWorkspace, you do not allocate your own instance of the class; you grab the sharedWorkspace thusly:
    
General/[[NSWorkspace sharedWorkspace] someNSWorkSpacemethod]

 
...or you could get a reference and keep it around, as in:
    
General/NSWorkspace *ws = General/[NSWorkspace sharedWorkspace];
[ws someNSWorkSpaceMethod];
[ws someOtherNSWorkSpaceMethod];


The benefit to this is speed, if you know you're going to be calling lots of methods of General/NSWorkspace.
 
----
 
Some stuff you can do with this class:

  
* 1- launch a URL
* 2- launch an application
* 3- open a file
* 4- find the icon for a file or fileType
* 5- reveal files in the Finder
*  enumerate all local volumes
*  enumerate all removable volumes
*  eject removable volumes
*  check for running programs
*  receive notifications for programs quiting, launching


1- launch an URL:

2- launch an app:

When launching an application, it is best to use launchAppWithBundleIdentifier: because it doesn't require a full path to be specified. This way you needn't worry where on-disk the app you want to launch is.

3- open a file:

**Specifying a program:**
     General/[[NSWorkspace sharedWorkspace] openFile:@"/Myfiles/README" withApplication:@"Edit"]; 

**Using the default program:**
    General/[[NSWorkspace sharedWorkspace] openFile:@"/foo"];

**With the open file animation**
    
General/[[NSWorkspace sharedWorkspace] openFile:@"/foo" fromImage:General/[NSImage imageNamed:@"foo"] at:General/NSMakePoint(1,1) inView:aView];



4- find the icon for a file or filetype

** Of a file at a path: **
     General/[[NSWorkspace sharedWorkspace] iconForFile:@"/path"]; 



** Icon of a file type, no reference file needed: **
     General/[[NSWorkspace sharedWorkspace] iconForFileType:@"tif"]; 



5- reveal a file in the finder.
    
General/NSString * path ="/tmp/foo.txt";
General/[[NSWorkspace sharedWorkspace] selectFile:path inFileViewerRootedAtPath:nil];


----

*Odd comment in the General/NSWorkspace docs under hideOtherApplications: "The user can hide all applications except the current one by Command-double-clicking an application�s tile, so programmatic invocation of this method is usually unnecessary." Tile? Is this a General/NeXT leftover?  In OS X one Command-option-clicks an application's icon in the dock.*

File a documentation bug.

* Done -- #3910776. Thanks for the confirmation.  *

It also talks about Edit.app ( rdar://3944321 )  I don't think the General/NSWorkspace docs have been changed much in a looong time.
----
I have not gotten     openFile:fromImage:at:inView: to work, and I know that the docs say "Currently provides the same functionality as openFile:", so I'm wondering: has anyone gotten the nice (or hated) Finder zoom animation to work using General/NSWorkspace (or by any other means)? --General/JediKnil

----
Hmm... I'm using General/[[NSWorkspace sharedWorkspace] mountedRemovableMedia], but getting an empty array when my external Firewire drive is attached and mounted. The drive is, however, included in General/[[NSWorkspace sharedWorkspace] mountedLocalVolumePaths] What gives? -- Devin

----
Well, according to the docs, it seems that - (General/NSArray *)mountedRemovableMedia only works for media that is physically inserted into a drive (ie. a CD or DVD). I personally can only get it to return disks in my optical drive.

----
Right you are, thanks. However, using General/[[NSWorkspace sharedWorkspace] getFileSystemInfoForPath:isRemovable:isWritable:isUnmountable:description:type:] returns completely incorrect info as far as the isRemovable and isMountable flags. Do you know of any way to find out these two pieces of information? -- Devin
----
General/NSWorkspace's volume methods are crippled. The solution I found was to use Applescript. See General/GettingNetworkVolumes. (I know it says Network Volumes, but it covers all volume types)

----
when I attempt to launch an app bundle  via the General/NSWorkspace method launchAppWithBundleIdentifier: it gives a warning: 'General/NSWorkspace' may not respond to '-launchAppWithBundleIdentifier:' and fails to launch the app.
yet when I hard code the path using launchApplication: its fine.

this fails:     General/[[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.apple.General/CharPaletteServer"];

this works: [    General/[NSWorkspace sharedWorkspace] launchApplication:@"/System/Library/Components/General/CharacterPalette.component/Contents/General/SharedSupport/General/CharPaletteServer.app"];

any idea on how to get an app to load via bundle id? --encro

----
Read the manual and realize that the full method is     launchAppWithBundleIdentifier:options:additionalEventParamDescriptor:launchIdentifier:.

----
Thankyou, I think it was more the Constants for options: that I misunderstood. --encro

Solution:
    General/[[NSWorkspace sharedWorkspace] launchAppWithBundleIdentifier:@"com.apple.General/CharPaletteServer" options:General/NSWorkspaceLaunchAsync additionalEventParamDescriptor:nil launchIdentifier:nil];

----
I have been using [NSWorkspace getInfoForFile:application:type:] to tell whether a given path is an application, by comparing type to NSApplicationFileType.  Apparently NSApplicationFileType was deprecated in 10.6.  What's the new way to do this?  The docs and the header just say it's deprecated, with no indication of what to do to port old code.