I'm developing an app that needs to be able to generate reports in PDF format. What would be the easiest way to do this? I tried taking a look at Tiger's General/PDFKit, but apparently that's only to view General/PDFs, am I missing something? If not, then what would be the easiest way to do this? Thanks in advance.

*Well, you could use the Cocoa printing architecture...*

As noted above, the Cocoa printing architecture will output pdf, so anything that can be rendered into a view can be fairly easily printed and saved to pdf. Couple web General/WebView, it's pretty easy to desigh reports in html, render in General/WebView, then output to pdf. I've done quite alot of this; a product I'm working on uses html for all report generation, using General/WebView for render and output.

Mike Ross

*I do this also. Quite simple to build an HTML templating system using General/NSString and the CSS of your choice, shove it into a General/WebView, and laugh all the way to the bank. -- General/RobRix*

----

How do I create an HTML document within Cocoa and then how do I display that in a General/WebView?

Build your html as an General/NSString these set it to your General/WebView with:
    
General/m_webView mainFrame] loadHTMLString:m_theHtml baseURL:nil]


----

I managed to get this working, but I'm having a few problems. First, I'm trying to save the contents of my [[WebView right after I tell it to load the HTML from my string the problem seems to be that the print operation takes place before the General/WebView is finished loading my HTML. Also, once the PDF is generated it's the size of my General/WebView rather than the size of an A4 page, and when the content is too long it does not paginate, it just creates a huge PDF. Here's the code I'm using:

    
General/webview mainFrame] loadHTMLString:htmlString baseURL:nil];
[[NSFileManager *filemanager = General/[NSFileManager defaultManager];
General/NSMutableData *data = General/[NSMutableData data];
General/NSPrintInfo *info = General/[NSPrintInfo sharedPrintInfo];
[info setPaperSize:General/[NSPrintInfo sizeForPaperName:@"A4"]];
General/NSPrintOperation* operation = General/[NSPrintOperation General/PDFOperationWithView:General/[ventana mainFrame] frameView] documentView] insideRect:[[[[ventana mainFrame] frameView] documentView] frame] toData:data printInfo:info];
[operation runOperation];
[filemanager path contents:data attributes:nil];


I'm using [[PDFOperationWithView:insideRect:toData:printInfo: because when I tried using General/PDFOperationWithView:insideRect:toPath:printInfo: with the path being the exact same one as the one I'm using with the filemanager, the PDF file was not being created.

Nevermind, I got it working using the same method used in Cocoa Dev Central's PDF tutorial. http://cocoadevcentral.com/articles/000074.php