Using General/WebKit to print data can be a lot easier than printing using the General/AppKit General/NSView classes.  I used this code to print tabular data from out application and it was much easier than mucking with General/NSTableView


    

- (void)printShowingPrintPanel: (BOOL)flag
{
	General/NSPrintInfo *printInfo = [self printInfo];
	[printInfo setTopMargin:15.0];
	[printInfo setLeftMargin:15.0];
	[printInfo setRightMargin:15.0];
	[printInfo setBottomMargin:15.0];
	[printInfo setHorizontallyCentered:NO];
	[printInfo setVerticallyCentered:NO];

	[printInfo setHorizontalPagination:General/NSFitPagination];
	[printInfo setHorizontallyCentered:NO];
	[printInfo setVerticallyCentered:NO];

	General/NSRect imageableBounds = [printInfo imageablePageBounds];
	General/WebView *webView = General/[[WebView alloc] initWithFrame:imageableBounds frameName:nil groupName:nil];
	[webView setFrameLoadDelegate:self];
	General/WebFrame *mainFrame = General/webView mainFrame] retain];

	[[NSMutableString *html = General/[NSMutableString stringWithString: @"<html><head></head><body>"];
	
	/* Magic to create the HTML you want to print here */
	// load the html into the web frame.  This is asyncronous.
	[mainFrame loadHTMLString: html baseURL:nil];
}

// this delegate is called when the webframe is done loading the HTML string, so lets print from here!
- (void)webView:(General/WebView *)webView didFinishLoadForFrame:(General/WebFrame *)frame
{
	General/NSPrintOperation *printOperation;
	General/NSPrintInfo *printInfo = [self printInfo];

	printOperation = General/[NSPrintOperation printOperationWithView: General/[webView mainFrame] frameView] documentView] printInfo: printInfo];
	[printOperation setShowPanels:YES];
	[self runModalPrintOperation:printOperation delegate:nil didRunSelector:NULL contextInfo:NULL];
}

 

-- [[AdhamhFindlay