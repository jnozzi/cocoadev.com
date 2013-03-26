I wish to have [[WebKit]] running without connection to real window. I want to have just [[WebKit]] engine, with no output to window.
Is it possible?

----

I find it out. It is idioticaly simple:
%%BEGINCODESTYLE%% <code>
[[WebView]]''    _webView;
_webView = [[[[WebView]] alloc] initWithFrame:[[NSZeroRect]]];
[_webView autorelease];
[_webView stringByEvaluatingJavaScriptFromString:@"document.location.href='http://www.site.com/'"];
[[NSLog]]([_webView stringByEvaluatingJavaScriptFromString:@"document.location.href"]);
[[NSLog]](@"see me?");
</code> %%ENDCODESTYLE%%