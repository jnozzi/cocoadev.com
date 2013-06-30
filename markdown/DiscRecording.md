


Docs:
http://developer.apple.com/documentation/Carbon/Reference/discrecording/General/CocoaDoc/index.html

Sample Code: 
*http://developer.apple.com/samplecode/Sample_Code/General/DiscRecording.htm *(link broken)*
*http://developer.apple.com/samplecode/General/EnhancedAudioBurn/
*http://developer.apple.com/samplecode/General/AudioBurn/
*http://developer.apple.com/samplecode/General/DataBurn/
*http://developer.apple.com/samplecode/General/ContentBurn/
*http://developer.apple.com/samplecode/General/DeviceListener/
*http://developer.apple.com/samplecode/General/EnhancedDataBurn/


Mailing List:
http://lists.apple.com/mailman/listinfo/discrecording

----
http://www.diggory.net/grazing/burn.jpg

Burn General/CDs and General/DVDs from Cocoa!

General/DiscRecording seems to be made up of two frameworks, General/DiscRecording and General/DiscRecordingUI. First, the objects in General/DiscRecording.framework.

* General/DRDevice represents a physical CD/DVD drive connected to the computer. The class has methods for discovering CD/DVD burners, finding out their properties, examining media, and even a few simple commands such as opening and closing the tray. Unfortunately drives which can't burn (such as ordinary CD-General/ROMs) are not accessible through General/DRDevice.

* General/DRBurn handles the process of burning a CD or DVD disc. The burn itself happens on a separate thread, but you can sign up for notifications on the burn object to be notified of its progress.

* General/DRErase handles the process of erasing a rewritable CD or DVD disc. Similarly to General/DRBurn, the erase happens on a separate thread and you sign up for notifications on the object to know when it's complete.

* General/DRTrack represents a track on the burned disc. When you burn, you provide one or more tracks as a "layout" that is then written to the disc. You can provide your own data by implementing the General/DRTrackDataProduction protocol, or use the     +General/[DRTrack trackForRootFolder:] method to create a track containing a filesystem.

* General/DRFile and General/DRFolder are used by the filesystem content engine to represent files and folders. You can build a hierarchy of them just the way you'd imagine, and the engine will automatically build a hybrid filesystem with the layout you specify.

* General/DRNotificationCenter is a notification center class much like General/NSNotificationCenter that is specially equipped to handle General/DiscRecording notifications.

Don't forget the UI framework! Apple has provided some pretty nice panels in the General/DiscRecordingUI framework to help make it easy to burn. Be sure to check out General/DRBurnSetupPanel and General/DRBurnProgressPanel, and also General/DREraseSetupPanel and General/DREraseProgressPanel.