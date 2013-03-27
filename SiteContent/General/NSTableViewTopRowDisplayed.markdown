Hey

Does anyone know how I would go about getting the row index of the top row that is being displayed in a General/NSTableView?

By this I mean, I have a General/NSTableView inside of a General/NSScrollView, and I want to know the top row that the user could currently see that is not clipped. So this would start of as row index 0, but if I moved down a little (such that that row was no longer visible, the value I am interested in would be row index 1.

Thanks

----
General/NSRange     visibleRows = [myTableView rowsInRect:[myTableView visibleRect]];

// first visible row index is visibleRows.location
// last visible row index is visibleRows.location + visibleRows.length - 1

This was really an General/RTFineM situation.

----
Hey

Thanks for replying despite it being a General/RTFineM situation :). The answer was not originally obvious to me at the time. Now that I see it I am woundering why I did not notice it earlier. I always try to RTFM before posting here. Sorry again.