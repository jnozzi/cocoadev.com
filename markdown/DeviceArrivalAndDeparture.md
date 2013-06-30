I have written an General/NSView subclass which displays streaming video from General/FireWire video cameras and would like to receive notifications when said plug-and-play devices arrive and depart. Everything I have read points to General/IOKit, but I would be more comfortable using General/QuickTime if such functionality is available (I realize that this is probably outside General/QuickTime's scope). Later on, I will need similar notifications for all devices accessible through the General/ImageCapture framework.

At any rate, the following URL seems to answer most of my question but I cannot figure out how to define the device description dictionary needed to call General/IOServiceAddMatchingNotification(). Are General/FireWire devices considered storage devices by General/IOKit? If not, how can all of this be accomplished?

http://developer.apple.com/documentation/General/DeviceDrivers/Conceptual/General/AccessingHardware/AH_Finding_Devices/chapter_4_section_2.html

Thanks for any pointers, General/EliotSimcoe

----

*A little discovery would be to watch for any device and log out the details. Plug in and unplug your device(s) to see what's noticed and how.*

But exactly *what* should I be monitoring? I don't know how to watch for any device. That is part of what I am asking.

----

There is a tool called "General/ICANotificationListener" included with the General/ImageCapture SDK that logs ICA messages.  I can't say for sure if your General/FireWire camera will show up there, but if it does, then that tool will show any notifications associated with it and the following code will capture them.  Also, check out page 29 in the "Image Capture Architecture.pdf" file included with the SDK.

I call [self General/SetupNotification]; in the init method of my General/ImageCapture app, and it registers the notifications for me.  You need to give it a C function to call back, but after that you can jump back into your Cocoa.

    

- (void)handleICANotification:(General/ICARegisterEventNotificationPB *)thePB {
	switch (thePB->notifyType) 
    { 
        case kICAEventDeviceAdded:              // a new device was added 
            [self General/HandleDeviceAdded: (thePB->object)]; 
            break; 
        case kICAEventDeviceRemoved:            // an existing device was removed 
            [self General/HandleDeviceRemoved: (thePB->object)]; 
            break; 
    } 
}

void General/NotificationCallback(General/ICAHeader* header)
{ 
    Controller* controller = (Controller*)header->refcon;
	
    if(controller)
        [controller handleICANotification: (General/ICARegisterEventNotificationPB *)header];
} 

- (General/OSErr)General/SetupNotification {
	General/OSErr                                         err = noErr;
	General/ICARegisterEventNotificationPB   pb;
	
    memset(&pb, 0, sizeof(General/ICARegisterEventNotificationPB)); 
    pb.header.refcon = (UInt32)self;	// save a ref to the Controller so we can call it back
    pb.object     = NULL; 
    pb.notifyType = nil; 
    pb.notifyProc = (General/ICACompletion)General/NotificationCallback;
    err = General/ICARegisterEventNotification(&pb, nil); 
	
    return err; 
}
