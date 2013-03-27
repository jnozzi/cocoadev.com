General/AFCalendarControl is an iCal like bindings compatible control hosted at http://code.google.com/p/calendarcontrol. The project actually includes a second control; General/AFWeekControl. See that page for more details.

General/AFCalendarControl is dependent on my General/AppKit additions in another one of my projects Amber.framework which is available at http://code.google.com/p/amber-framework.

It exposes several bindings to access your model objects.


* General/AFCurrentMonthBinding, the month displayed by the control
* General/NSContentBinding, typically bound to the -arrangedObjects of an General/NSArrayController 
* General/AFContentDatesBinding, the collection subpath of the model objects' date property
* General/AFDateHighlightedBinding, another model subpath yielding a BOOL which determines if there should be a dot drawn beneath the day string
* General/NSSelectedIndexBinding, this is given instead of any selected date binding to allow for easier integration with the controller layer


Note: the control only expects a single object per date, once one is found it won't continue looking. If you have multiple objects sharing the same date in the General/NSContentBinding collection this will yield inconsistent results. Also, it is best to restrict the objects in the General/NSContentBinding collection to those in the General/AFCurrentMonthBinding range as expensive date comparison occurs.


A blank General/CalendarControl:

http://33software.com/images/components/General/CalendarControl-Blank.jpg

A populated General/CalendarControl illustrating the use of the General/AFDateHighlightedBinding:

http://33software.com/images/components/General/CalendarControl-Full.jpg


The control shadow isn't part of the view; it is drawn by setting the General/CoreAnimation shadow property.