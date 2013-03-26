I'm seeing something strange, and I need some help. I'm using a [[WebView]] object in my code to generate content that I then print or save. I'm using 
<code>
	[[m_webView mainFrame] loadHTMLString:m_theHtml baseURL:nil];
</code>
to generate my main frame, the handling the:
<code>
      - (void)webView:([[WebView]] '')sender didFinishLoadForFrame:([[WebFrame]] '')frame
</code>
delegate to either save or print. If I print to pdf file, all is well. If I use [[NSPrintOperation]] like this:
<code>
	printOp	= [[[NSPrintOperation]] printOperationWithView:docView printInfo:printInfo];
	[printOp setShowPanels:YES];
	[printOp runOperation];
</code>
I get the print dialog, and my output prints just fine. If I instead use the modal sheet:
<code>
	printOp	= [[[NSPrintOperation]] printOperationWithView:docView printInfo:printInfo];
	[printOp setShowPanels:YES];
	[printOp runOperationModalForWindow:win delegate:self didRunSelector:@selector(printOperationDidRun:success:contextInfo:) contextInfo:nil];
</code>
My sheet is displayed as it should be, but my output is blank/an empty page. This same logic, when invoked from a visible [[WebView]] gives me the correct output. I'm stuck here. I suspect, that [[[NSPrintOperation]] runOperation] is either doing some additional configuration that make it all good, or maybe it's spinning the run loop, which is allowing [[WebView]] to so something important. Anybody have any clues? Thanks!

Mike Ross
Ross Data Systems/Pretty Good Software

I think the problem is that [[WebView]] uses [[NSURLConnection]] which doesn't work when running in a modal loop. Chris Suter, Coriolis Systems