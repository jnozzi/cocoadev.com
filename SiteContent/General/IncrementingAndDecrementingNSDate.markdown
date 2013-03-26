

I want to use a [[NSStepper]] to increment or decrement a date, by day, that is in a [[NSTextField]] with a Date Formatter on it.  Is this possible?  Here's the basic form i thought would work:

<code>
[[NSDate]] ''date = [[[NSDate]] dateWithNaturalLanguageString:[dateField stringValue]];

if( 1 == [dateStepper intValue] )
	// increment date
elseif( -1 == [dateStepper intValue] )
	// decrement date

[dateStepper setIntValue:0];
	
[dateField setObjectValue:date];</code>

----

Convert your date to a [[NSCalendarDate]] using <code>dateWithCalendarFormat:timeZone:</code> and then use the <code>dateByAddingYears:months:days:hours:minutes:seconds:</code> method.

You may be tempted to use [[NSDate]]'s <code>addTimeInterval:</code> method. For your purposes avoid it. [[NSCalendarDate]] will deal with Summer Time Saving adjustments for free. -- GCM

http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/[[NSDate]].html
http://developer.apple.com/documentation/Cocoa/Reference/Foundation/ObjC_classic/Classes/[[NSCalendarDate]].html

----

Yeah, i used <code>addTimeInterval:</code> before i posted here, and found it didnt work.  but [[NSCalendarDate]] worked great.   thanks.