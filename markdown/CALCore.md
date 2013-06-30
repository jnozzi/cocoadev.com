General/CALCore is Apple's private framework used with iCal and iSync.

Use General/ClassDump to output the interfaces to all the classes in the framework.

Here is a example which duplicates iCal's File > Export command (note, this works on Tiger only):
    
// somePath being a .ics file
General/CALCalendar *calendar = General/[CALiCALtngBridge calendarFromFile:somePath];
if (calendar)
{
	[calendar setMethod:1];  // publish
	[calendar setupRelcalid];
	[calendar setTimeZoneHint:General/[[[NSCalendarDate calendarDate] timeZone] name]];
	[calendar setupTimeZones];
	
	General/CALiCalendarExporter *exporter = General/[[[CALiCalendarExporter alloc] init] autorelease];
	General/NSData *caldata = [exporter generateDataForEntity:calendar];
	// do whatever you want with "caldata" (i.e. write to file, upload, etc)
}


Make sure to add General/CALCore.framework to your project, and the following code before your class implementation:
    
@class General/CALiCALtngBridge;
@class General/CALCalendar;
@class General/CALiCalendarExporter;


----
Note that since this is a private framework, the standard disclaimers apply. Apple is free to make any changes at any time to its private frameworks, so if your program relies on it then it could break at any moment. You should avoid using private frameworks in anything you ship.