In a controller class, I have an instance variable General/NSMutableArray* General/TagVektorH.
It is set with 
General/TagVektorH=General/[NSMutableArray arrayWithCapacity:0]
later it is filled with
    
(for (z=0;z<max;z++)
{
General/NSNumber* tempTag =General/[NSNumber numberWithInt:(10*z)];
General/[TagVektorH addObject:tempTag];
}


Everything works fine, and I can see the array in the debugger with the right number of objects.
Accesing the array just now works fine and it returns his objects correctly.
But going to the array later within an action method of th controller class ends up in  a BAD_ACCESS after a call like
General/[TagVektorH count];
Looking at the array in this moment shows in the summary column:
 {int)[$VAR count]} objects
instead of the number of objects as before. 
What is going wrong?
Thanks for help
Ruedi Heimlicher

----

Are you sure you're General/RetainingAndReleasing correctly?     +arrayWithCapacity: returns an General/AutoRelease**'d object, so you'll have to retain it.