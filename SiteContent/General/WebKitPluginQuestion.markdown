I'm trying to learn how to make plugins for [[WebKit]] apps, namely
Safari.  Using the [[WebKitMoviePlugin]] example from here as a starting
point:

http://developer.apple.com/documentation/[[InternetWeb]]/Conceptual/WebKit_PluginProgTopic/Tasks/[[WebKitPlugins]].html

Then I want to trigger a javascript method, I added the js to the page
but am struggling with how to call this.  I added a few lines noted by
a comment below.  It's pretty basic but so far I've utterly failed at
get access to the [[WebView]]'s scripting environment.  Help!  I'm a bit
of a Cocoa newbie and a total [[WebKit]] newbie.

<code>
- (void)webPlugInStart

{
   
if (!_loadedMovie) {

       _loadedMovie = YES;

       [[NSDictionary]] ''webPluginAttributesObj = [_arguments objectForKey:[[WebPlugInAttributesKey]]];

       [[NSString]] ''[[URLString]] = [webPluginAttributesObj objectForKey:@"src"];


               // added these lines before the if statement
               [[NSDictionary]] ''webPluginContainerKey = [_arguments objectForKey:[[WebPlugInContainerKey]]];

               myWebView = [[webPluginContainerKey webFrame] webView];

               [myWebView evaluateWebScript:@"pluginLaunchSuccess()"];


       if ([[URLString]] != nil && [[[URLString]] length] != 0) {

           NSURL ''baseURL = [_arguments objectForKey:[[WebPlugInBaseURLKey]]];

           NSURL ''URL = [NSURL [[URLWithString]]:[[URLString]] relativeToURL:baseURL];

           [[NSMovie]] ''movie = [[[[NSMovie]] alloc] initWithURL:URL byReference:NO];

           [self setMovie:movie];

           [movie release];

       }

   }

   [self start:self];
}
</code>