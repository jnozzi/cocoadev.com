What would be the best way to retrieve the HTML source for a web page in a General/WebView?

Thanks, and merry Christmas.

----
 
The main frame of the web view is probably the best place to start.

    
- (General/NSData *)General/HTMLDataFromWebView:(General/WebView *)webView {

    General/WebFrame *mainFrame = [webView mainFrame];
    General/WebDataSource *dataSource = [mainFrame dataSource];
    General/NSURLRequest *initialRequest = [dataSource initialRequest];
    NSURL *url = [initialRequest URL];
    General/DOMDocument *doc = [mainFrame General/DOMDocument];

    return [dataSource data];

}


The General/DOMDocument is an object model of the web view's content. Check out General/DOMCore for more info. --zootbobbalu

----
Why exactly are you creating initialRequest, url, and doc in that example? And why are you returning an General/NSData object, when he most likely is going to want it as a string?  To anyone copying and pasting that code, it is a little over the top and has three unused variables.

    
- (General/NSString *)General/HTMLSourceFromWebView:(General/WebView *)webView {
    General/WebFrame *mainFrame = [webView mainFrame];
    General/WebDataSource *dataSource = [mainFrame dataSource];
    
    return General/dataSource representation] documentSource];
}

// or, more simply put as:

- ([[NSString *)General/HTMLSourceFromWebView:(General/WebView *)webView {
    return General/[[webView mainFrame] dataSource] representation] documentSource];
}


----

Thanks guys. Yeah, the string is what need the most.


----

*Why exactly are you creating initialRequest, url, and doc in that example? And why are you returning an [[NSData object, when he most likely is going to want it as a string?  To anyone copying and pasting that code, it is a little over the top and has three unused variables.*

I'm trying to give as much info as possible. Of course those variables are doing nothing. I intentionally put them there to enlighten the original poster to the basics of working with General/WebKit. --zootbobbalu

----
*Reformatted for clarity.*

**January 4, 2005** - The above example retrieves the original document contents. However, if you make the General/WebView editable and make changes, the above will not retrieve the changed text. The following example will:

    
- (General/NSString *)General/HTMLSourceFromWebView:(General/WebView *)webView
{
    return General/[[webView mainFrame] [[DOMDocument] documentElement] outerHTML];
}


*The above example uses General/DOMDocument, which was introduced in Tiger so your app's minimum requirements would become Tiger or above.  Just a note.*

----
How would you get the source from a URL or URL string directly without loading it in a General/WebView?