I am constructing some HTML and putting it into a General/WebView with     -loadHTMLString:baseURL:, as shown below. I would like the links in the view to open in a new window of the user's default browser, however, I can't figure out quite how to get it to work. I'm sure there is an easy solution to this - but I'm a little stuck as to what it might be.

    

General/NSString * header = [ General/NSString stringWithFormat:@"<html><body>%@", [ selectedObject title ]];
General/NSString * footer = [ General/NSString stringWithFormat:@"<br /><br />&raquo; <a href='%@'>More information</a></body></html>", [ selectedObject link ]];
General/NSString * webString = [ header stringByAppendingString:[ selectedObject content ] ];
webString = [ webString stringByAppendingString:footer ];

[ [ webView mainFrame ] loadHTMLString:webString baseURL:nil ];



As it stands, the link opens in the General/WebView, rather than in a new window. I have tried adding a "target" to the <A> link (_blank etc), but that leaves the link inactive. Any ideas or thoughts would be much appreciated!

~ General/TheMZA

----

You need to give your General/WebView a delegate by doing     -setUIDelegate:, and then you need to implement a method to catch links that open in new windows, like (I think)     -webView:createWebViewWithRequest:. From there, you should be able to extract the URL from the General/NSURLRequest and then use General/NSWorkspace to open it in the user's default browser.

----

Thanks - that was really helpful in pointing me in the right direction. I had some problems receiving a valid General/NSURLRequest using the UI delegate     -webView:createWebViewWithRequest: method, so instead set a General/WebPolicyDelegate and implemented     webView:decidePolicyForNewWindowAction:request:newFrameName:decisionListener: like this:

    
- (void)webView:(General/WebView *)sender decidePolicyForNewWindowAction:(General/NSDictionary *)actionInformation request:(General/NSURLRequest *)request newFrameName:(General/NSString *)frameName decisionListener:(id<General/WebPolicyDecisionListener>)listener {
	[ [ General/NSWorkspace sharedWorkspace ] openURL:[ request URL ] ];
}


It works nicely - however - the first clicked link from within my app opens Safari (my default browser) and puts the correct URL in the location text box, but does not load the content. You have to manually go to Safari and press return to get it to load the page. All subsequent links open correctly. Any thoughts?

~ General/TheMZA

----
I am using the General/NSWorkSpace openURL and it launches and opens the page for me just fine from what I remember. Maybe its a Safari bug? What URL are you trying to load?

--General/MaksimRogov

----

It looks like this could be a bug in Safari. I'm just loading General/URLs of normal web pages, however, sometimes I see the strange behaviour detailed above, and sometimes  it works perfectly. Odd.

~ General/TheMZA