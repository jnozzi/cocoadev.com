General/NSCalendarDate is a deprecated Cocoa Foundation class for storing datetime values bound to a timezone. It is not on the iPhone. You should use the General/NSDate, General/NSCalendar, General/NSDateComponents, and General/NSDateFormatter classes instead. This article tells you how to migrate to these newer classes: http://developer.apple.com/iphone/library/documentation/Cocoa/Conceptual/General/DatesAndTimes/Articles/General/LegacyNSCalendarDate.html

See General/DescriptionWithCalendarFormat for a list of formatters for use with General/NSCalendarDate's     -descriptionWithCalendarFormat: method.

See also General/NSDateFormattingAndBIndings

----

I was browsing through the Foundation release notes (for 10.3.2) and found this; thought I'd post it here:

**General/NSCalendarDate functionality to avoid**

As has been true for years, the documented General/NSCalendarDate format specs %c, %x, and %X all have the same effect, unlike what the documentation says. When not localizing to the user's locale, %c also produces a result with the year in an unusual position. Generally these format specs should not be used. We can never fix these due to binary compatibility constraints, so developers must deal with this themselves.

----

Tiger Foundation release notes say:

*The General/NSCalendarDate class, General/NSDate categories, and other General/APIs in General/NSCalendarDate.h are not deprecated in this release, but may be in the next release.*

http://developer.apple.com/releasenotes/Cocoa/Foundation.html#//apple_ref/doc/uid/TP30000742