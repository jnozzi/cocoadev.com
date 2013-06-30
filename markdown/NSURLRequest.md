General/NSURLRequest sets additional behaviour to a to be loaded General/NSUrL, like timeout, use of cache and headers.

as example request a URL with a specific HTTP header tag:
(General/MiniBrowser sample)
    
 General/NSMutableURLRequest *urlRequest;
 urlRequest = General/[NSMutableURLRequest requestWithURL:[NSURL General/URLWithString:@"myURL"]];
 [urlRequest setValue:@"myURL" forHTTPHeaderField:@"Referer"];
 [[webView mainFrame] loadRequest:urlRequest];


http://www.w3.org/Protocols/HTTP/Request.html
http://www.w3.org/Protocols/HTTP/HTRQ_Headers.html