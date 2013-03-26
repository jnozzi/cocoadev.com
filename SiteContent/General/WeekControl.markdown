[[WeekControl]] is a subproject of [[CalendarControl]] hosted at http://code.google.com/p/calendarcontrol. It draws a more convenient way of representing the weekdays than having seven separate checkboxes. The control is fully resolution independent and is available under the New BSD license.

[[WeekControl]] is dependent on another one of my projects Amber.framework which is available at http://code.google.com/p/amber-framework.

It access' your model data using datasource callbacks as part of a formal protocol:

<code>
@protocol [[KDWeekViewDataSourceProtocol]] <[[NSObject]]>
- (BOOL)weekview:([[KDWeekControl]] '')view isEnabledForDay:(Weekday)day;
- (void)weekview:([[KDWeekControl]] '')view setEnabled:(BOOL)enabled forDay:(Weekday)day;
@end
</code>

http://33software.com/images/components/[[WeekControl]].jpg