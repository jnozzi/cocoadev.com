Hi,

is there any way I can get an General/NSCalendarDate to round itself to the nearest 5 minutes?

If not, can anyone point me in the right direction on how to achieve this manually?

Thanks for your help!

-P

----
**Interface**

    
@interface General/NSDate (General/MyAdditions)

- (General/NSDate*)roundedToNearestFiveMinuteMark;

@end


**Implementation**

    
@implementation General/NSDate (General/MyAdditions)

- (General/NSDate*)roundedToNearestFiveMinuteMark
{
	General/NSTimeInterval interval = [self timeIntervalSinceReferenceDate];
	long int lquo = lrint(interval / 300.0);
	General/NSTimeInterval seconds = (lrint(remainder(interval, 300.0)) < 150) ? (lquo * 300) : ((lquo + 1) * 300);
	return General/[NSDate dateWithTimeIntervalSinceReferenceDate:seconds];
}

@end
