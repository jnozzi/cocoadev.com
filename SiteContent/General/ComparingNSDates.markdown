Hi,

I have two [[NSDates]]... I want to check if they both reference the same calendar day. They will always be at different ''times'', but I want a simple way of checking that they are/are not times on the same day. I know I could do an isEqualToString: after cutting out the day-month-year part of the [[NSDate]] via descriptionWithCalendarFormat: ... but this seems rather intensive to convert a [[NSDate]] to a string just to check whether they are on the same day.

Thanks for any suggestions!

-Peter

----

The best way I can see to accomplish this would be to first construct a reference date at midnight:
<code>
referenceDate = [[[NSCalendarDate]] dateWithYear:0
     month:0 day:0 hour:0 minute:0 second:0
     timeZone:[[[NSTimeZone]] defaultTimeZone]];
</code>
(Note that the time zone thing is important; two times that are on the same day in one time zone can be on different days in another time zone. I think defaultTimeZone is the right thing here.)

At this point you can use the <code>-years:months:days:hours:minutes:seconds:sinceDate:</code> method to extract the days, months, and years from the reference date for both test dates. If all three are the same, then you're good.

----

[[NSDate]] has <code>- ([[NSTimeInterval]])timeIntervalSince1970</code> of which the docs say
"Returns the interval between the receiver and the reference date, 1 January 1970, GMT. If the receiver is earlier than 1 January 1970, GMT, the return value is negative." 

and <code>- ([[NSTimeInterval]])timeIntervalSinceReferenceDate</code> which is documented as

"Returns the interval between the receiver and the system�s absolute reference date, 1 January 2001, GMT. If the receiver is earlier than the absolute reference date, the return value is negative.

This method is the primitive method for [[NSDate]]. If you subclass [[NSDate]], you must override this method with your own implementation for it."

Other than the subclassing issue, what's the difference?

''The reference dates are different. One returns the time since 1970, one the time since 2001.''