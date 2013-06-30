

The "menu" outlet for General/NSBrowser doesn't seem to do very much, but in a similar way to the code for General/RightClickSelectInTableView you can make it work for General/NSBrowser cells (actually General/NSMatrix cells).

Firstly, subclass General/NSMatrix and call your subclass General/BrowserMatrixView. Include the following code (which could easily be improved upon, I would imagine):

    

@implementation General/BrowserMatrixView

-(General/NSBrowser* )browser {
	General/NSView* theView = [self superview];
	while(theView != nil) {
		if([theView isKindOfClass:General/[NSBrowser class]]) {
			return (General/NSBrowser* )theView;
		}
		theView = [theView superview];
	}	
	return nil;
}

-(int)matrixColumn {
	General/NSBrowser* theBrowser = [self browser];
	for(int i = [theBrowser firstVisibleColumn]; i <= [theBrowser lastVisibleColumn]; i++) {
		if([theBrowser matrixInColumn:i]==self) {
			return i;
		}
	}
	return -1;
}

-(General/NSMenu* )menuForEvent:(General/NSEvent* )event {
	General/NSPoint thePoint = [self convertPoint:[event locationInWindow] fromView:nil];
	int theRow = -1;
	int theCol = -1;
	if([self getRow:&theRow column:&theCol forPoint:thePoint] == NO) {
		return nil;
	}

	General/NSBrowser* theBrowser = [self browser];
	theCol = [self matrixColumn];
	if(theBrowser==nil || theCol==-1) {
		return nil;
	}
	if(General/theBrowser delegate] respondsToSelector:@selector(browser:selectRow:inColumn:)]) {
		[[NSLog(@"asking delegate to select row %d col %d",theRow,theCol);
		General/theBrowser delegate] browser:theBrowser selectRow:theRow inColumn:theCol];
	} else {
		[[NSLog(@"asking browser to select row %d col %d",theRow,theCol);
		[theBrowser selectRow:theRow inColumn:theCol];
	}

	// sets this matrix as the first responder for window
	General/self window] makeFirstResponder:self];
       // return the context menu for the browser
	return [[self browser] menu];
}
@end



Finally, in your controller (or [[NSBrowser subclass I suppose) you will need to tell the General/NSBrowser which class to use for matrix classes:

    

-(void)awakeFromNib {
	// set browser matrix class
	[myBrowser setMatrixClass:General/[BrowserMatrixView class]];
}



- General/DavidThorpe