

I want to use a General/NSStepper to increment or decrement a date, by day, that is in a General/NSTextField with a Date Formatter on it.  Is this possible?  Here's the basic form i thought would work:

    
General/NSDate *date = General/[NSDate dateWithNaturalLanguageString:[dateField stringValue]];

if( 1 == [dateStepper intValue] )
	// increment date
elseif( -1 == [dateStepper intValue] )
	// decrement date

[dateStepper setIntValue:0];
	
[dateField setObjectValue:date];

----

Convert your date to a General/NSCalendarDate using     dateWithCalendarFormat:timeZone: and then use the     dateByAddingYears:months:days:hours:minutes:seconds: method.

You may be tempted to use General/NSDate's     addTimeInterval: method. For your purposes avoid it. General/NSCalendarDate will deal with Summer Time Saving adjustments for free. -- GCM

http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/General/NSDate.html
http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/General/NSCalendarDate.html

----

Yeah, i used     addTimeInterval: before i posted here, and found it didnt work.  but General/NSCalendarDate worked great.   thanks.