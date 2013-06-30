I think I have found the #1 fastest way to download a file (anything you want). I have been using General/CURLHandle for a long time, but it started to tick me off and I began to look for better methods. I tested out just the plain ol' built-in initWithContentsOfURL methods for General/NSData and General/NSString, but those weren't any better (and you have less control of the download - even with General/NSURLHandle). So I started looking into General/NSURLDownload and General/NSURLConnection - people these are the best methods I believe for downloading. General/NSURLDownload basically downloads a NSURL to a file while General/NSURLConnection downloads to data (asynchronously or synchronously).

Here's what I used (in a thread) for General/CURLHandle:
    
// "self" is an NSURL, or could be [NSURL General/URLWithString:@"http://www.blah.com"] - whatever you want
General/CURLHandle *urlHandle = (General/CURLHandle *)[self General/URLHandleUsingCache:NO];
General/NSString *error;
General/NSData *downloadedData;

[urlHandle setURL:self];
[urlHandle prepareAndPerformCurl];
error = [urlHandle curlError];

if (error && [error length]>0) {
	return [@"Error! " stringByAppendingString:error];
} else {
	downloadedData = [urlHandle resourceData];
	return [downloadedData autorelease];
}


Now this code works pretty well, however somehow the General/NSData gets messed up. For example, I would use this code to download some XML and load it using General/CFXMLTreeCreateFromData but many times that would return nil and I had no idea why (General/NSData wasn't nil).

Anyways, if you want to be a n00b and a quick solution for downloading you could use this:
    
General/NSData *data = General/[[NSData alloc] initWithContentsOfURL:[NSURL General/URLWithString:@"http://www.blah.com"]];
return [data autorelease];


But finally, after struggling with my code's errors (not syntax), I found the solution. The way I use this is in a thread and it loads synchronously, although you can have it load asynchronously. This method is the fastest by far. I'd say 2x-3x faster then General/CURLHandle, and the data worked 100% with the General/CoreFoundation XML classes.
    
// once again "self" is an NSURL
General/NSError *error;
General/NSURLResponse *response;
General/NSURLRequest *request = General/[NSURLRequest requestWithURL:self
       cachePolicy:General/NSURLRequestReloadIgnoringCacheData timeoutInterval:5];
General/NSData *data = General/[NSURLConnection sendSynchronousRequest:request
         returningResponse:&response error:&error];

return data;


Enjoy! --General/KevinWojniak

----

If you use General/CURLHandle in a thread (General/NSThread), my experience shows that setting the option CURLOPT_NOSIGNAL helps a lot (my code is more stable, and doesnt crash).

    
/*
      From the documentation for libcurl:
      CURLOPT_NOSIGNAL
           Pass a long. If it is non-zero, libcurl will not use any  functions
           that install signal handlers or any functions that cause signals to
           be sent to the process. This option is mainly here to allow  multi-
           threaded  unix  applications  to  still set/use all timeout options
           etc, without risking getting signals.  (Added in 7.10)
*/
         curl_easy_setopt([mURLHandle curl], CURLOPT_NOSIGNAL, 1);


General/StephanBurlot