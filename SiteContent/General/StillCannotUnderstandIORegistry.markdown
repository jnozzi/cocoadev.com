Well, I'm still struggling to understand just how to include code to recognize that a particular USB device has been plugged in, and how to access the file descriptor for that device. I am not a programmer by trade, so I'm sort of in over my head, but I really need this part to work. I'd REALLY appreciate any help you folks can offer. Here's the story: I have a Cocoa app that is supposed to respond to keyboard input (that works great) and to data coming from a custom-designed box that sends a serial stream to a Keyspan serial to USB converter. I know the [[VendorID]], [[ProductID]], and everything else from the [[IORegistryExplorer]], but I don't know how to write the code to get the Mac to hand me the /dev name for the device. I even have a sense of how to get the program to read from that file (I think I have an example somewhere), but this whole iterator concept has me stumped. Apple's otherwise excellent documentation really leaves me confused here. Can this be done as part of my [[ObjC]] program? Do I need to write separate code instead? If anyone has a sample chunk of code that would show me how to pull the /dev path from the above info, I'd be grateful. As it is, this is what I've been able to piece together, although I don't think it does anything given the debugger values I've seen....
<code>
	[[CFMutableDictionaryRef]] myUSBMatchDictionary = [[IOServiceMatching]]("Keyspan USA-19QW");    
         // When I use Apple's suggested kIOUSBDeviceName, the 
         // compiler complains that it doesn't recognize that.	
	// Create a generic USB dictionary....
	io_iterator_t myIterator;
	
	UInt32 value;
	[[CFNumberRef]] cfValue;
	
	value = kMyVendorID;				// for the Keyspan device
	cfValue = [[CFNumberCreate]]( kCFAllocatorDefault, kCFNumberSInt32Type, &value );
	[[CFDictionaryAddValue]]( myUSBMatchDictionary, CFSTR( "[[VendorID]]" ), cfValue);
	[[CFRelease]]( cfValue );
	
	value = kMyProductID;				// for the Keyspan device
	cfValue = [[CFNumberCreate]]( kCFAllocatorDefault, kCFNumberSInt32Type, &value );
	[[CFDictionaryAddValue]]( myUSBMatchDictionary, CFSTR( "[[ProductID]]" ), cfValue);
	[[CFRelease]]( cfValue );
	
	[[IOServiceGetMatchingServices]](kIOMasterPortDefault, 
            myUSBMatchDictionary, &myIterator);
</code>
Any advice or questions can be directed to: fibonacci_series ( a t ) yahoo.com

Thanks!
-dan wambold
----
For the [[KeySpan]] or any other USB Serial Device, don't look for USB devices, but serial devices. While the following article enumerates modems, you can enumerate raw serial devices with the kIOSerialBSDRS232Type constant. The [[IORegistery]] will hand you the serial device name and full path of the device file on a silver platter. If you set up your run loop correctly, you will get real time notifications when serial devices become available or when they disappear.

See: http://developer.apple.com/documentation/[[DeviceDrivers]]/Conceptual/[[WorkingWSerial]]/index.html

As for the file descriptor for the serial port, I suggest the method I use in my applications. I open it and set it up using the BSD system calls, similar to the above article, but then hand the file descriptor off to a [[NSFileHandle]] to worry about the Async I/O aspect of things. All of this is quite Cocoa friendly and in my case, works like a champ.

Just holler If you need further information.
----
I've read the document from Apple, Working with Serial I/O several times, but even copying the code straight out of the document into a new [[XCode]] program fails to identify any devices plugged into the Mac. They are so focused on finding modems that they don't even suggest where or how I should insert the code to look for specific vendor & product ID values. If you have some code that does this (and maybe even includes the notification part), that would be a huge help, I'm sure. If you know what frameworks I might need to add to this GUI Cocoa program, that would be great, too. I'm sorry if this is a fairly obvious thing, but like I said: I'm really not a programmer, so my knowledge of POSIX is virtually nil. I have a few books on Cocoa, and I can handle some C/[[ObjC]], but I have precious little experience.
Again, thanks for your time and guidance!

Any advice or questions can be directed to: fibonacci_series ( a t ) yahoo.com

Thanks!
-dan wambold
----
I need further information- See above (I deleted my earlier message to save space). My best efforts to understand this have failed. If you have some generic code lying around that you wouldn't mind posting or e-mailing, I'd be grateful!

-dan
----
Dan, I resurrected original post and cleaned up the timeline. It's not good idea to re-factor pages before a problem is resolved. Others readers would have a disjointed sense of the chronological order without the previous posts in place.  The framework you want to link with is [[IOKit]].framework.  My code does not bother with specific vendor & product ID, just the actual name of the device and it's absolute device path.  Just out of curiosity, why do you need this information?, I have been doing fine without it.  I will also note that [[IOKit]] and hence [[IORegistry]] is quite Mac OS X specific and will not be compatible with other POSIX platforms, IMHO, [[IOKit]] is allot more powerful.  I will put together and post a overview of my code sometime tomorrow when I get the chance.
----
Sorry about that. I'll keep my hands off previous posts! Regarding Vendor/Product ID: I used them because I thought I had to. If it's easier or wiser to use the device name instead, that's fine. It's a side effect (again) of my lack of experience. Mac OS X specific is perfectly fine. I have no intention of porting this to any other platform. It's just that, since the Apple documents all start by pointing out that the device access is based on POSIX, I assumed it was important in some way. As I mentioned, I'm not really trained in programming, but I managed to learn C a few years ago, then [[ObjC]] this year. Unfortunately, the books I got on [[ObjC]] only touch on these concepts, and I've been thoroughly confused by [[XCode]]'s rejection of most of the sample code Apple posted on this subject. In any event, the program I need to complete is very important to me, but is unlikely to be commercially available. I'm sort of a believer in open source anyway, so if anyone else thinks it's useful, I'll probably give them the source. The project is an anesthesia simulator, but it requires an expensive upper torso model (which hasn't been manufactured in years) and a custom-programmed jStamp analog-digital conversion that was created by a friend, who also wrote the original program in Java. It's buggy (he assumes the same /dev name every time, which is painful, and he never checks for the presence of the device, so if it becomes disconnected for any reason, the program immediately and ungracefully crashes), and not nearly as attractive as Cocoa makes it. Anyway, I've got the Cocoa part working fine ([[ObjC]] is amazing!), but I need to get the serial input part right so that the program doesn't crash. I just don't know enough about it even to know what I need to know.... Thanks for your ongoing help!
-dan
----
OK, so after a substantial amount of work, a derivative of /[[USBPrivateDataSample]].c (from Apple's site) correctly identifies the plugging or unplugging of the Keyspan Serial -> USB device. However, even though I can get a "path" to this device, it's not the path I'm looking for ("These aren't the droids you're looking for." - Obi Wan). It's an I/O Registry path, based on the "planes" of something or other. I really want either a pipe I can access or a file handle I can read. Despite changing the dictionary match parameter to "kIOSerialBSDAllTypes" from Apple's "matchingDict = [[IOServiceMatching]](kIOUSBDeviceClassName);", the program fails to see the device when it's plugged in. It seems to regard it only as a USB device, even though it gets a /dev entry. Any further help would be most helpful, since I'm stumped. I need to find a way to read the data that comes through this device, preferably in response to a notification such as the "readInBackgroundAndNotify" as shown in Cocoa Applications, by Garfinkle & Mahoney. Of course, any other solution would also be extremely welcome. Thanks again in advance.

-dan
----
Sorry for not getting back sooner; got tied up. The basic motions of my code is like this, sans error checking and what not...
Hint: You can have [[IOKit]] give you back a refernce to anything you want in the callbacks by passing it as the refCon parameter to the [[IOServiceAddMatchingNotification]] calls.

I store the serial devices in an [[NSDictionary]] in a singleton whose sole purpose in life is to track serial devices and forward the notifications via [[NSNotiificationCenter]]. That way, anything in my application that needs to know about new or lost serial ports just has to listen for my custom notifications.

<code>
#include <[[IOKit]]/[[IOKitLib]].h>
#include <[[IOKit]]/serial/[[IOSerialKeys]].h>
#include <[[IOKit]]/IOBSD.h>

// stored elsewhere (class members in my code); noted here as extern for example purposes...

extern [[IONotificationPortRef]] notePort;
extern [[CFRunLoopSourceRef]] runLoopSource;
extern io_iterator_t addedIter;
extern io_iterator_t removedIter;

static void [[MyDeviceAddedCallback]](void ''refCon, io_iterator_t it);
static void [[MyDeviceRemovedCallback]](void ''refCon, io_iterator_t it);
</code>

This is an abbreviated verion of the code that hooks it all up.

<code>
mach_port_t masterPort;

[[IOMasterPort]](NULL, &masterPort);

[[CFMutableDictionaryRef]] matchingServices = [[IOServiceMatching]](kIOSerialBSDServiceValue);
[[CFDictionarySetValue]](matchingServices, CFSTR(kIOSerialBSDTypeKey), CFSTR(kIOSerialBSDRS232Type));

notePort = [[IONotificationPortCreate]](masterPort);
runLoopSource = [[IONotificationPortGetRunLoopSource]](notePort);

// [[IOServiceAddMatchingNotification]] consumes a refernce count which would release this
// dictionary. Retain it here, we need it bellow.
[[CFRetain]](matchingServices);

[[IOServiceAddMatchingNotification]](notePort, kIOFirstMatchNotification, matchingServices, [[MyDeviceAddedCallback]], NULL, &addedIter);

// Call this directly to handle any pending additions.
[[MyDeviceAddedCallback]](NULL, addedIter);

// This will release the dictionary for us, no longer need to release it ourselves at this point.
[[IOServiceAddMatchingNotification]](notePort, kIOTerminatedNotification, matchingServices, [[MyDeviceRemovedCallback]], NULL, &removedIter);

// Call this directly to handle any pending removals.
[[MyDeviceRemovedCallback]](NULL, removedIter);

[[CFRunLoopAddSource]]([[CFRunLoopGetCurrent]](), runLoopSource, kCFRunLoopDefaultMode);
</code>

Examples of [[MyDeviceAddedCallback]] and [[MyDeviceRemovedCallback]]. Note that the path given
by the kIOCalloutDeviceKey is the serial ports path you can open for communications.

<code>
static void [[MyDeviceAddedCallback]](void ''refCon, io_iterator_t it)
{
	io_object_t svc;
	
	while (svc = [[IOIteratorNext]](it)) {
		[[CFTypeRef]] name = [[IORegistryEntryCreateCFProperty]](svc, CFSTR(kIOTTYDeviceKey), kCFAllocatorDefault, 0);
		if (NULL != name) {
			[[CFTypeRef]] path = [[IORegistryEntryCreateCFProperty]](svc, CFSTR(kIOCalloutDeviceKey), kCFAllocatorDefault, 0);
			if (NULL != path) {
				// TODO: Device has been inserted, handle it if you need to.
				[[CFRelease]](path);
			}
			[[CFRelease]](name);
		}
		[[IOObjectRelease]](svc);
	}
}

static void [[MyDeviceRemovedCallback]](void ''refCon, io_iterator_t it)
{
	io_object_t svc;
	
	while (svc = [[IOIteratorNext]](it)) {
		[[CFTypeRef]] name = [[IORegistryEntryCreateCFProperty]](svc, CFSTR(kIOTTYDeviceKey), kCFAllocatorDefault, 0);
		if (NULL != name) {
			[[CFTypeRef]] path = [[IORegistryEntryCreateCFProperty]](svc, CFSTR(kIOCalloutDeviceKey), kCFAllocatorDefault, 0);
			if (NULL != path) {
				// TODO: Device has been yanked, do whatever you need to do.
				[[CFRelease]](path);
			}
			[[CFRelease]](name);
		}
		[[IOObjectRelease]](svc);
	}
}
</code>

Cheers
----
That seems to have done it! There's a minor typo for those who may try this themselves: the <code>[[MyDeviceAppearedCallback]]</code> should read <code>[[MyDeviceAddedCallback]]</code>. Thanks for taking an interest in my problem! It's terrific to know there's a whole community out there trying to make Mac the best it can be. I suppose the same is true for Windoze, except they're all working on viruses... ;)

Sincerely,
Dan Wambold, MD
----
Typo fixed. Glad I could help Dan.
----
I'm not sure if anybody's still watching this page but, just in case, I'd like to add another question to this:

I can recognise my USB device being added and removed (using the product ID and vendor ID) and, using the second piece of sample code above, I can see the serial port it makes appear and disappear... but how can I tell that a particular serial port is created by a particular USB device? Ideally, I need to watch for a product ID and vendor ID, and get the serial device path back (the serial port is being generated by an FTDI driver, if that helps). Any ideas much appreciated!

Thanks, Matt W