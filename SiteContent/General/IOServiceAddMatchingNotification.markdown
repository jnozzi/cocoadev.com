I am trying to write a Cocoa app that works with a USB device.

I am using the Apple sample code as a guide but it is code for a FOUNDATION tool - NOT a Cocoa app.

Here are the steps that I am doing:

1) I call General/IONotificationPortCreate - to create a notification object
2) I call General/IONotificationPortGetRunLoopSource- to get the runloop source of the object from step 1
3) call General/CFRunLoopAddSource with General/CFRunLoopGetCurrent as a parameter - to add the source to my runloop
4) I create a matching dictionary that matches my USB device - I tested this function and it DEFINTELY matches my USB device
5) I call General/IOServiceAddMatchingNotification - it returns err_none

Then my app never gets ANY notifications of USB device removal or attachment.

I even tried adding in a call to General/CFRunLoopRun like the Apple sample code does but my app just hung.

Has anyone got General/IOServiceAddMatchingNotification working from a Cocoa app?

I have this working on my cocoa app, watching for serial ports:
    
    // related instance variables:
    General/IONotificationPortRef   nport;
    io_iterator_t           serialPortIterator;

- (void)startWatchingForSerialPorts {
    nport = General/IONotificationPortCreate(kIOMasterPortDefault);

    General/CFMutableDictionaryRef match = General/IOServiceMatching(kIOSerialBSDServiceValue);
    General/CFDictionarySetValue(match, CFSTR(kIOSerialBSDTypeKey), CFSTR(kIOSerialBSDAllTypes));
    
    General/CFRunLoopAddSource(General/CFRunLoopGetCurrent(), General/IONotificationPortGetRunLoopSource(nport), kCFRunLoopCommonModes);
    // NOTE General/IOServiceAddMatchingNotification uses the dictionary, so we pass a copy
    General/IOServiceAddMatchingNotification(nport, kIOPublishNotification, General/CFDictionaryCreateMutableCopy(NULL, 0, match), (General/IOServiceMatchingCallback)serial_port_added, self, &serialPortIterator);
    while (General/IOIteratorNext(serialPortIterator)) {}; // could call serial_port_added(self, serialPortIterator) to notify of existing serial ports
    General/IOServiceAddMatchingNotification(nport, kIOTerminatedNotification, match, (General/IOServiceMatchingCallback)serial_port_removed, self, &serialPortIterator);
    while (General/IOIteratorNext(serialPortIterator)) {};
    
}

- (void)stopWatchingForSerialPorts {
    General/CFRunLoopRemoveSource(General/CFRunLoopGetMain(), General/IONotificationPortGetRunLoopSource(nport), kCFRunLoopDefaultMode);
    General/IONotificationPortDestroy(nport);
    General/IOObjectRelease(serialPortIterator);
}

- (void)didAddSerialPort:(General/NSString*) deviceName {
    [serialPortsMenu addItemWithTitle: deviceName];
}

- (void)didRemoveSerialPort:(General/NSString*) deviceName {
    [serialPortsMenu removeItemWithTitle: deviceName];
}

void serial_port_added (id self, io_iterator_t iter) {
    io_registry_entry_t serialPort;
    while (serialPort = General/IOIteratorNext(iter)) {
        General/CFTypeRef   path;
        path = General/IORegistryEntryCreateCFProperty(serialPort, CFSTR(kIODialinDeviceKey), kCFAllocatorDefault, 0);
        [self didAddSerialPort:[(General/NSString*)path lastPathComponent]];
        General/CFRelease(path);
        General/IOObjectRelease(serialPort);
    }
}

void serial_port_removed (id self, io_iterator_t iter) {
    io_registry_entry_t serialPort;
    while (serialPort = General/IOIteratorNext(iter)) {
        General/CFTypeRef   path;
        path = General/IORegistryEntryCreateCFProperty(serialPort, CFSTR(kIODialinDeviceKey), kCFAllocatorDefault, 0);
        [self didRemoveSerialPort:[(General/NSString*)path lastPathComponent]];
        General/CFRelease(path);
        General/IOObjectRelease(serialPort);
    }
}
