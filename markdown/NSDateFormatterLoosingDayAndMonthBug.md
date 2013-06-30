I use a date formatter with a "%H:%M" format string. When dates are edited through this formatter, the date and month is reset to 1. So e.g. if the date is "18:40 20. Dec 2003", the field will display "18:40", and if we change it to e.g. "17:40" the entire date will change to "17:40 1. Jan 2003".

Is this a bug? Is there a workaround?

Can we see some code that demonstrates the problem you are having? 

----

There is no code of mine in direct contact with the procedure. I just dragged an General/NSDateFormatter to a column of my General/NSTableView in IB, and this table view was bound to an General/NSArrayController, where the contentArray was bound to my model (implementing the array accessor methods). A new event is then inserted like this:
    
- (General/IBAction)newEvent:(id)sender
{
   id event = General/[NSMutableDictionary dictionaryWithObjectsAndKeys:  
      General/[NSDate date], @"date",
      @"Test", @"name",
      nil];
   [self insertObject:event inEventsAtIndex:[self countOfEvents]];
}


I dump the event dates like this:
    
General/NSEnumerator* enumerator = General/self events] objectEnumerator];
while(id event = [enumerator nextObject])
   printf("%s\n", [[[event valueForKey:@"date"] descriptionWithCalendarFormat:@"%H:%M - %d/%m/%y" 
        timeZone:nil locale:nil] UTF8String]);


And, as said, initially this code writes the correct dates. But if changing the time in the table view and dumping again, then the date and month (of dates having been edited) are reset to 1.

----

I think the problem is that the formatter system is too limited. The field editor calls getObjectValue:forString:errorDescription: on the formatter, and the formatter really has no idea what the original object was, so everything not present in the string, will be lost.

You might be able to create your own formatter which use auxiliary data from the last object sent to editingStringForObjectValue:.

----

Without a better understanding of how IB wires things up I cannot be more specific, but here's my speculation.  When the GUI field is populated from the [[NSDate object, the stringForObjectValue: result used only preserves the elements specified in the format string. Later, when getObjectValue:forString:errorDescription: is called, the only available values are hour and minute, so the General/NSDate created uses defaults for the other fields.  The correct solution does seem to be to subclass General/NSDateFormatter. The documentation for editingStringForObjectValue: says "When implementing a subclass, override this method only when the string that users see and the string that they edit are different."  It seems to be correct to say that the "%H:%M" format string is not the same as the string that fully describes the date.
----

Here is an General/NSDateFormatter subclass which keeps the day, month and year from the last General/NSDate passed in.
    
@interface General/TimeFormatter : General/NSDateFormatter
{
   General/NSCalendarDate* _currentObject;
}
@end

@implementation General/TimeFormatter
- (General/NSString*)stringForObjectValue:(id)anObject
{
   if([anObject isKindOfClass:General/[NSDate class]])
   {
      [_currentObject release];
      _currentObject = General/[[NSCalendarDate dateWithTimeIntervalSinceReferenceDate:
         [anObject timeIntervalSinceReferenceDate]] retain];
   }
   return [super stringForObjectValue:anObject];
}

- (BOOL)getObjectValue:(id*)anObject forString:(General/NSString*)string errorDescription:(General/NSString**)error
{
   BOOL res;
   id date;
   if(res = [super getObjectValue:&date forString:string errorDescription:error])
   {
      if([date isKindOfClass:General/[NSCalendarDate class]] && _currentObject)
         *anObject = General/[NSCalendarDate dateWithYear:[_currentObject yearOfCommonEra] month:
             [_currentObject monthOfYear] day:[_currentObject dayOfMonth] hour:[date hourOfDay] 
             minute:[date minuteOfHour] second:[date secondOfMinute] timeZone:nil];
   }
   return res;
}
@end


*though in theory this may not work if e.g. used for an General/NSTableColumn where the strings are cached (so the last object passed in might not be the one being edited).*

----

The way I handled this (I had a text box for the date, and another for the time) was to create a single General/NSDate ivar in my object, but have two mutator methods to set either to the date or the time components of the General/NSDate. See the following code:

    

// The accessors simply return the General/NSDate object, since the formatter will strip out whatever it doesn't want.

- (General/NSDate *)startTime;
{
	return [self start];
}

- (General/NSDate *)startDate;
{
	return [self start];
}

// The mutators though, will need to find only the date part, or only the time part, since that's what we get from the
// formatter. We can use these with the original value to create a new General/NSDate.

- (void)setStartTime:(General/NSDate *)date;
{
	General/NSCalendar *calendar = General/[NSCalendar currentCalendar];
	General/NSDateComponents *dateComponents = [calendar components:( General/NSYearCalendarUnit | General/NSMonthCalendarUnit |  General/NSDayCalendarUnit ) fromDate:[self start]];
	General/NSDateComponents *timeComponents = [calendar components:( General/NSHourCalendarUnit | General/NSMinuteCalendarUnit | General/NSSecondCalendarUnit ) fromDate:date];
	
	[dateComponents setHour:[timeComponents hour]];
	[dateComponents setMinute:[timeComponents minute]];
	[dateComponents setSecond:[timeComponents second]];
	
	[self willChangeValueForKey:@"start"];
	General/NSDate *newDate = [calendar dateFromComponents:dateComponents];
	[self setStart:newDate];
	[self didChangeValueForKey:@"start"];
}

- (void)setStartDate:(General/NSDate *)date;
{
	General/NSCalendar *calendar = General/[NSCalendar currentCalendar];
	General/NSDateComponents *timeComponents = [calendar components:( General/NSHourCalendarUnit | General/NSMinuteCalendarUnit | General/NSSecondCalendarUnit ) fromDate:[self start]];
	General/NSDateComponents *dateComponents = [calendar components:( General/NSYearCalendarUnit | General/NSMonthCalendarUnit |  General/NSDayCalendarUnit ) fromDate:date];
	
	[timeComponents setYear:[dateComponents year]];
	[timeComponents setMonth:[dateComponents month]];
	[timeComponents setDay:[dateComponents day]];
	
	[self willChangeValueForKey:@"start"];
	General/NSDate *newDate = [calendar dateFromComponents:timeComponents];
	[self setStart:newDate];
	[self didChangeValueForKey:@"start"];
}



This can be either in the object class itself, or you can put it in a category if you want to keep the UI stuff separate.