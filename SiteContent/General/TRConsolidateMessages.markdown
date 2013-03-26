[[TRConsolidateMessages]] is a small class I wrote to consolidate messages for myself, it was inspired by [[NSNotificationQueue]].

Unlike [[NSNotificationQueue]] I didn't want to mess around with [[NSNotificationCenter]] for this code which must be called often yet is relatively slow (redrawing).

I am releasing this code to the everyone under the BSD Licence so that everyone may benefit.

'''Upsides:'''

* Only one message instead of many is sent, speeding up your interface.


'''Downsides'''

* Messages are sent in the next run loop.


'''Usage:'''
<code>#import "Controller.h"
#import "[[TRConsolidatingObject]].h"

@implementation Controller
- test:(id)sender
{
	[[TRScheduleMessage]](@selector(cpuhog),self,nil);
	[[TRScheduleMessage]](@selector(cpuhog),self,nil);
	[[TRScheduleMessage]](@selector(cpuhog),self,nil);
	[[TRScheduleMessage]](@selector(cpuhog),self,nil);
	
	[[TRScheduleMessage]](@selector(cpuhogWithObject:),self,[[[NSArray]] arrayWithObject:@"blah!"]);
	[[TRScheduleMessage]](@selector(cpuhogWithObject:),self,[[[NSArray]] arrayWithObject:@"blah!"]);
	[[TRScheduleMessage]](@selector(cpuhogWithObject:),self,[[[NSArray]] arrayWithObject:@"weee!"]);
	[[TRScheduleMessage]](@selector(cpuhogWithObject:),self,[[[NSArray]] arrayWithObject:@"blah!"]);
	return self;
}

- cpuhog
{
	[[NSLog]](@"cpu limiting function called");
	return self;
}

- cpuhogWithObject:([[NSArray]] '')array
{
	[[NSLog]](@"%@",array);
	return self;
}

@end
</code>

You may also use the objC method: <code>[[[[TRConsolidatingObject]] consolidator] scheduleMessage:selector to:target withObject:object];</code> However the function is easier to type.

'''Download:'''
http://triage-software.com/leach?id=[[TRConsolidateMessages]]

'''Comments:'''
----