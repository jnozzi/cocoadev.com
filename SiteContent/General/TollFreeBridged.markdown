The following classes are toll-free bridged:

*Foundation
*[[NSArray]] = [[CFArray]]
*[[NSMutableArray]] = [[CFMutableArray]]
*[[NSAttributedString]] = [[CFAttributedString]] (Mac OS X only, not iOS)
*[[NSMutableAttributedString]] = [[CFMutableAttributedString]] (Mac OS X only, not iOS)
*[[NSCalendar]] = [[CFCalendar]]
*[[NSCharacterSet]] = [[CFCharacterSet]]
*[[NSMutableCharacterSet]] = [[CFMutableCharacterSet]]
*[[NSData]] = [[CFData]]
*[[NSMutableData]] = [[CFMutableData]]
*[[NSDate]] = [[CFDate]]
*[[NSDictionary]] = [[CFDictionary]]
*[[NSMutableDictionary]] = [[CFMutableDictionary]]
*[[NSError]] = [[CFError]]
*[[NSLocale]] = [[CFLocale]]
*[[NSNumber]] = [[CFNumber]]
*[[NSNumber]] ''partially bridged with'' [[CFBoolean]], for booleans only
*[[NSTimer]] = [[CFRunLoopTimer]]
*[[NSTimeZone]] = [[CFTimeZone]]
*[[NSSet]] = [[CFSet]]
*[[NSMutableSet]] = [[CFMutableSet]]
*[[NSStream]] = [[CFStream]]
*[[NSInputStream]] = [[CFReadStream]]
*[[NSOutputStream]] = [[CFWriteStream]]
*[[NSString]] = [[CFString]]
*[[NSMutableString]] = [[CFMutableString]]
*[[NSUrL]] = CFURL
*[[AppKit]]
*[[NSFont]] = [[CTFont]]
*[[NSFontDescriptor]] = [[CTFontDescriptor]]
*Disc Recording
*[[DRBurn]] = [[DRBurnRef]]
*[[DRErase]] = [[DREraseRef]]
*[[DRDevice]] = [[DRDeviceRef]]
*[[DRTrack]] = [[DRTrackRef]]
*[[DRFile]] = [[DRFileRef]]
*[[DRFolder]] = [[DRFolderRef]] (starting with 10.3)
*Address Book
*[[ABAddressBook]] = [[ABAddressBookRef]]
*[[ABGroup]] = [[ABGroupRef]]
*[[ABMultiValue]] = [[ABMultiValueRef]]
*[[ABMutableMultiValue]] = [[ABMutableMultiValueRef]]
*[[ABPerson]] = [[ABPersonRef]]
*[[ABRecord]] = [[ABRecordRef]]
*[[ABSearchElement]] = [[ABSearchElementRef]]


The following classes are '''''not''''' toll-free bridged:

*[[NSBundle]] and [[CFBundle]]
*[[NSCountedSet]] and [[CFBag]]
*[[NSDateFormatter]] and [[CFDateFormatter]]
*[[NSNumberFormatter]] and [[CFNumberFormatter]]
*[[NSHost]] and [[CFHost]]
*[[NSNotificationCenter]] and [[CFNotificationCenter]]
*[[NSRunLoop]] and [[CFRunLoop]]
*[[NSSocket]] and [[CFSocket]]
*[[NSUserDefaults]] and [[CFPreferences]]
*[[AppKit]]
*[[NSColor]], [[CIColor]], and [[CGColor]]
*[[NSColorSpace]] and [[CGColorSpace]]
*[[NSFont]] and [[CGFont]]
*[[NSGradient]] and [[CGGradient]]
*[[NSImage]] and [[CGImage]]


See also [[TollFreeBridging]].

----

If you wonder whether an [[ObjC]] class is bridged and can't find docs, send an object of the class the _cfTypeID message.  If you get back '1', it isn't bridged.  For more detail see [[HowToCreateTollFreeBridgedClass]].