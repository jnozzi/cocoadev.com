http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Classes/General/NSTextTab.html

----

General/NSTextTab is a class used to define "Tabs" (right, left, center, decimal) for a General/NSParagraphStyle.  This General/NSParagraphStyle can be applied to a number of different objects (see application to General/NSMutableAttributedString below).

I was disappointed to see that there wasn't a description or useful example of General/NSTextTab.  After hours of searching on the internet and tons of trial and error, I came up with a working General/NSTextTab example.  This example sets up some Tabs for an General/NSMutableAttributedString to be used to set the "attributed" title of an General/NSMenuItem.  There is an example of setting up a right tab, and a left tab.

    

General/NSMutableParagraphStyle *General/NPStyle	= General/[[[NSMutableParagraphStyle alloc] init] autorelease];
General/NSFont *boldFont					= General/[NSFont boldSystemFontOfSize:12];

General/[NPStyle setTabStops:General/[NSArray array]]; // delete default tabs



By default, a General/NSParagraphStyle has "12 left-aligned tabs, spaced at 28.0 points."  This threw me off the most because I didn't realize that this code generate these defaults.

    		
menuItemTitle = General/[NSString stringWithFormat:@"\t%@, %@: \t%@...%@ \t%@ \tprecip: %@",dayName,date,low,high,shortFore,precip];
attrMenuItemTitle = General/[[[NSMutableAttributedString alloc] 
					initWithString:menuItemTitle] autorelease];

// four tabs
General/[NPStyle addTabStop:General/[[[NSTextTab alloc] initWithType:General/NSRightTabStopType location:headIndent+8] autorelease]];
General/[NPStyle addTabStop:General/[[[NSTextTab alloc] initWithType:General/NSLeftTabStopType location:headIndent+15] autorelease]];
General/[NPStyle addTabStop:General/[[[NSTextTab alloc] initWithType:General/NSLeftTabStopType location:headIndent+15+sndIndent+8] autorelease]];
General/[NPStyle addTabStop:General/[[[NSTextTab alloc] initWithType:General/NSLeftTabStopType location:headIndent+15+sndIndent+8+thdIndent+8] autorelease]];



The documentation for +General/[NSTextTab initWithType:location:] doesn't mention what the units are for location, only that it is a float.  After hours, I deduced (from above) that the units are "points" (1/72 inch).  So we are setting the location of tabs based on points.

This code is used inside of a loop-- I am aligning the elements of several different menuitems.  headIndent is the max width of "%@, %@:" with the strings substituted in.  Likewise, sndIndent is the max width of "%@...%@" and thdIndent is the max of "%@."

In order to find the width of these various strings, I had to create intermediate strings.  The code looks like this:

    
start loop:
     General/NSAttributedString *title = General/[[[NSAttributedString alloc]
           initWithString:General/[NSString stringWithFormat:@"%@, %@:\t",date,dayName]] autorelease];
     headIndent = MAX(headIndent, [title size].width);
end loop;


Now we must attach attributes to the General/NSMutableAttributedString "attrMenuItemTitle".  To do this:

    
[attrMenuItemTitle addAttribute:General/NSFontAttributeName value:boldFont range:General/NSMakeRange(0,[dayName length] + [date length] + 4)];
[attrMenuItemTitle addAttribute:General/NSParagraphStyleAttributeName value:General/NPStyle range:General/NSMakeRange(0,[attrMenuItemTitle length])];


What does it look like? I thought a visual might help:
http://www.cs.lafayette.edu/~crobakj/nstexttab_usage.jpg

-Joe

----

This is real nice work. Perhaps we could turn it into one of the General/RecentTutorials? -- General/KritTer