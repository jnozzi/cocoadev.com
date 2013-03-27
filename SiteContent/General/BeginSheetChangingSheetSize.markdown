

I'm trying to programmatically change the height of my sheet, but an interesting thing happens.  The first time I open the sheet, it is about 20 pixels too short, cutting off the top.  But, every time it is opened after that, it's the correct height.

Here is my Code, along with some checks via General/NSLog:

    

General/NSLog( @"Before Resize: %d", (int)General/NSHeight([exportWindow frame]) );
		
General/NSRect r;
int newWinSizeV = 204;
int newWinSizeH = (int) General/NSWidth([exportWindow frame]);
		
r = General/NSMakeRect([exportWindow frame].origin.x, [exportWindow frame].origin.y, newWinSizeH, newWinSizeV);
[exportWindow setFrame:r display:YES animate:NO];
		
General/NSLog( @"After Resize: %d", (int)General/NSHeight([exportWindow frame]) );
		
General/[NSApp beginSheet: exportSheet
   modalForWindow: mainWindow
   modalDelegate: self
   didEndSelector: nil
   contextInfo: nil];
		
General/NSLog( @"After Showing Sheet: %d", (int)General/NSHeight([exportWindow frame]) );
General/NSLog( @"  " );



And here is the General/NSLog result

    

2005-12-18 14:32:24.131 Application[2867] Before Resize: 226
2005-12-18 14:32:24.132 Application[2867] After Resize: 204
2005-12-18 14:32:24.622 Application[2867] After Showing Sheet: 182
2005-12-18 14:32:24.633 Application[2867]   
2005-12-18 14:32:25.574 Application[2867] Before Resize: 182
2005-12-18 14:32:25.592 Application[2867] After Resize: 204
2005-12-18 14:32:26.100 Application[2867] After Showing Sheet: 204
2005-12-18 14:32:26.100 Application[2867]   
2005-12-18 14:32:25.574 Application[2867] Before Resize: 204
2005-12-18 14:32:25.592 Application[2867] After Resize: 204
2005-12-18 14:32:26.100 Application[2867] After Showing Sheet: 204
2005-12-18 14:32:26.100 Application[2867]   
...



So, it is clear that the window resizes appropriately the first time, but after the <code>beginSheet:</code> call, the window is too small.  But every time after that, the window is correct and stays correct.

Does anybody have any insight as to why this might be happening?  Does <code>beginSheet:</code> do something to the window size when running, but only the first time?  Thanks for the help.

----

The difference in size you are seeing is the window - minus the title bar.  It does happen the first time you show a sheet, so you'll need to adjust your calculations by the fixed height of the title bar after you show the window as a sheet - I've also seen this behaviour.

JKP