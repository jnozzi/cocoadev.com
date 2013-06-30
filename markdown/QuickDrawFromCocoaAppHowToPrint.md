I have a Cocoa application in which I would like to print patterns as view backgrounds (like the old PAT# resource in OS 9 and earlier). Since General/NSPatternColor isn't documented (at least not that I can find) and may not be implemented, I have had to resort to using General/QuickDraw. In OS 9 and earlier a set of standard patterns was stored in the system file and could be accessed using General/QuickDraw routines. It turns out these patterns are also in the OS X system file, but there appear to be no Cocoa routines to access them. IF I AM WRONG ABOUT THIS I WOULD LOVE TO HEAR ABOUT IT!


So I am using General/NSQuickDrawView (which inherits from General/NSView) and include the General/ApplicationsServices framework in my project. I get the desired Pattern structure out of the system file using General/GetIndPattern, a General/QuickDraw function. Then I use General/BackPat and General/EraseRect to fill the view with the pattern. All subsequent drawing into the view is done using standard Cocoa application kit routines.


On the screen everything works fine. But when the view is printed, the pattern is not drawn. How do I get General/QuickDraw graphics to print from within a Cocoa program?  Is there some manipulation of graphics ports or the graphics context required? I have been unable to find any documentation on this.

An interesting phenomenon---The code tests to see if drawRect was called while printing or not, and draws the patterns only if printing. After printing a wndow  (the patterns did not show up on the paper), I covered the window with the application's Preferences panel and then closed the Preferences. The window on the screen now showed the patterns! They went away as soon as I forced the window to redraw. Does this mean the problem is in the printer drivers? I have tried this with an Epson and an HP printer with the same reults.

I am developing in OS 10.1.5.