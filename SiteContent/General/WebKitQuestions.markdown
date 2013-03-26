Q: I set my applications name using setApplicationNameForUserAgent: but customUserAgent returns nil. Does it work?

A: ...

----

Q: I set my page contents using loadHTMLString:baseURL: but if the baseURL: I supply is of type file:// and the file doesn't exist, nothing changes in the [[WebView]]. Is this a bug?

A: I don't think it's a bug. If you're giving it a file:// URL, it must point to an html/htm file, and the file must exist. If not, it will not work properly.

----

Q: How do I "flush" the resources cached by the [[WebView]] (i.e. stylesheets and images).

A:  There is a private class that you can use for this called [[WebCoreCache]], it has only two class methods.

<code>@interface [[WebCoreCache]]
+ (void) setDisabled:(BOOL) disabled;
+ (void) empty;
@end
</code>

- [[TimothyHatcher]]

----

Q: Each time I click a link, the [[WebView]] loses first responder status. Is this a bug? I see the Help Viewer seems to suffer from the same problem.

A: A [[WebView]] controls many subviews. There are one or more [[WebFrameViews]] inside a [[WebView]]. So your frame view is likely becoming the first responder. - [[TimothyHatcher]]

----

Q: If I set my page content using loadHTMLString:baseURL:, click a link, and then press cmd-back so that the [[WebView]] goes one page back, it will load the contents found at the base URL. What is the simplest way to have it show the string that I'd given it?

A: You could intercept links and open them always in the default web browser, preventing navigation in your [[WebView]], if this is the desired affect.

<code>[webView setPolicyDelegate:self];

- (void) webView:([[WebView]] '') sender decidePolicyForNavigationAction:([[NSDictionary]] '') actionInformation request:([[NSURLRequest]] '') request frame:([[WebFrame]] '') frame decisionListener:(id <[[WebPolicyDecisionListener]]>) listener {
	NSURL ''url = [actionInformation objectForKey:[[WebActionOriginalURLKey]]];

	if( [[url scheme] isEqualToString:@"about"] ) {
		if( [[[url standardizedURL] path] length] ) [listener ignore]; // prevents a crash
		else [listener use]; // do this to allow loading of a string with loadHTMLString:baseURL:
	} else {
		[[[[NSWorkspace]] sharedWorkspace] openURL:url];
		[listener ignore];
	}
}
</code>

- [[TimothyHatcher]]