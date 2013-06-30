----
To make things easier I've refactored the ideas below into a generic Uploader class. I've also included a working PHP web application to receive uploads. See General/HTTPFileUploadSample.
----

I would like to upload a file using HTTP POST and Objective C's built-in General/NSMutableURLRequest.  Ideally I would like to send a multipart POST message which contains a few regular name/value fields, followed by one file upload.  Here's the code I have so far, which sends one regular name/value field via POST:

    
// url is set to be some URL string.
General/NSMutableURLRequest* post = General/[NSMutableURLRequest requestWithURL: [NSURL General/URLWithString: url]];
[post setHTTPMethod: @"POST"];
[post setHTTPBody: General/[[[NSString alloc] initWithString: @"name=dude"] 
        dataUsingEncoding: General/NSASCIIStringEncoding]];
General/NSMutableData* theData = General/[[NSMutableData data] retain];
General/NSURLConnection* theConnection = General/[NSURLConnection connectionWithRequest: post
        delegate: self];
[theConnection retain];


I'm not using General/CurlHandle (see this page, General/POSTMethodANDNSURLRequest) because I'd rather use what's built-in already.

----

So, me again.  I still don't have file uploading yet, but now I have multipart forms.  Here's my code for that:

    
+ (General/NSString*) nameValString: (General/NSDictionary*) dict {
	General/NSString* boundary = @"0194784892923";
	General/NSArray* keys = [dict allKeys];
	General/NSString* result = General/[[NSString alloc] initWithString: @""];
	int i;
	for (i = 0; i < [keys count]; i++) {
		result = [result stringByAppendingString:
					[@"--" stringByAppendingString:
						[boundary stringByAppendingString:
							[@"\nContent-Disposition: form-data; name=\"" stringByAppendingString:
								General/keys objectAtIndex: i] stringByAppendingString:
									[@"\"\n\n" stringByAppendingString:
										[[dict valueForKey: [keys objectAtIndex: i stringByAppendingString: @"\n"]]]]]]];
	}
	result = [result stringByAppendingString: 
				[@"\n--" stringByAppendingString:
					[boundary stringByAppendingString:
						@"--\n"]]];
	return result;
}

General/NSMutableURLRequest* post = General/[NSMutableURLRequest requestWithURL: [NSURL General/URLWithString: url]];
General/NSString* regData = General/[HTMLTalk nameValString: 
					General/[NSDictionary dictionaryWithObjectsAndKeys: 
									@"val1",
									@"field1",
									@"val2",
									@"field2",
								        nil]];
[post addValue: @"multipart/form-data; boundary=0194784892923" forHTTPHeaderField: @"Content-Type"];
[post setHTTPMethod: @"POST"];
[post setHTTPBody: [regData
	                           dataUsingEncoding: General/NSASCIIStringEncoding]];
theData = General/[[NSMutableData data] retain];
theConnection = General/[NSURLConnection connectionWithRequest: post
                               delegate: self];
[theConnection retain];


----

I am having the same problem. Does anyone know how to POST a file - with or without using cURLHandle?

----

Ok here's something I quickly threw together (read: not optimized, not much errorhandling)

    

- (General/NSData*)generateFormData:(General/NSDictionary*)dict
{
	General/NSString* boundary = General/[NSString stringWithString:@"_insert_some_boundary_here_"];
	General/NSArray* keys = [dict allKeys];
	General/NSMutableData* result = General/[[NSMutableData alloc] initWithCapacity:100];

	int i;
	for (i = 0; i < [keys count]; i++) 
	{
		id value = [dict valueForKey: [keys objectAtIndex: i]];
		[result appendData:General/[[NSString stringWithFormat:@"--%@\n", boundary] dataUsingEncoding:General/NSASCIIStringEncoding]];
		if ([value class] == General/[NSString class] || [value class] == General/[NSConstantString class])
		{
			[result appendData:General/[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\n\n", [keys objectAtIndex:i]] dataUsingEncoding:General/NSASCIIStringEncoding]];
			[result appendData:General/[[NSString stringWithFormat:@"%@",value] dataUsingEncoding:General/NSASCIIStringEncoding]];
		}
		else if ([value class] == [NSURL class] && [value isFileURL])
		{
			[result appendData:General/[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\n", [keys objectAtIndex:i], General/value path] lastPathComponent dataUsingEncoding:General/NSASCIIStringEncoding]];
			[result appendData:General/[[NSString stringWithString:@"Content-Type: application/octet-stream\n\n"] dataUsingEncoding:General/NSASCIIStringEncoding]];
			[result appendData:General/[NSData dataWithContentsOfFile:[value path]]];
		}
		[result appendData:General/[[NSString stringWithString:@"\n"] dataUsingEncoding:General/NSASCIIStringEncoding]];
	}
	[result appendData:General/[[NSString stringWithFormat:@"--%@--\n", boundary] dataUsingEncoding:General/NSASCIIStringEncoding]];
	
	return [result autorelease];
}


General/NSMutableDictionary* post_dict = General/[[NSMutableDictionary alloc] initWithCapacity:2];
[post_dict setObject:@"test_value" forKey:@"test_key"];
[post_dict setObject:[NSURL fileURLWithPath:@"/Butterfly.tif"] forKey:@"file1"];
General/NSData* regData = [self generateFormData:post_dict];
[post_dict release];

General/NSMutableURLRequest* post = General/[NSMutableURLRequest requestWithURL: [NSURL General/URLWithString:@"http://yourdomain.com/post.php"]];
[post addValue: @"multipart/form-data; boundary=_insert_some_boundary_here_" forHTTPHeaderField: @"Content-Type"];
[post setHTTPMethod: @"POST"];
[post setHTTPBody:regData];
General/NSURLResponse* response;
General/NSError* error;
General/NSData* result = General/[NSURLConnection sendSynchronousRequest:post returningResponse:&response error:&error];
General/NSLog(@"%@", General/[[[NSString alloc] initWithData:result encoding:General/NSASCIIStringEncoding] autorelease]);


// php page :

<?php
	print_r($_POST);
	$destfile = "/Webserver/upload/test.tif";
	if (move_uploaded_file($_FILES['file1']['tmp_name'], $destfile))
	{
		echo "SUCCESS";
		exit;
	}
	echo "FAILURE";
?>



So just put either an NSURL or an General/NSString into a dictionary and run it through the function. I don't know if dumping the file contents like that is RFC compliant. If somebody feels like looking it up, be my guest. I tested it on my server and it worked. -- General/KasPer

----

Sorry, just to let you guys know that General/KasPer's code does not work for me. Even though the server responds *as if* everything was ok, no values were uploaded. I tried changing the 'boundary' values, and the encoding to utf-8 instead of ascii, but it won't work... I have NMS's General/TFMail.pl as the form-processing cgi on my site. It is setup properly, and currently processes 'normal' file uploads done via HTML forms. I would *love* to be able to post information directly from inside my Cocoa apps. I thought your code would have worked, but...
Please, keep trying! Network newbies like us haven't got a chance in the world of making this happen... 

----

Make sure you have permissions on your web host to upload. Make sure it works through a normal General/HTMl form first before attempting to do it in Cocoa.

----

Thanks for the hints! Unfortunately, the cgi I'm using works perfectly when the submission comes from a simple form in Safari. I don't think this is a problem on my server. I tried a *very* simple http POST request emulation, and I still cannot get it to work. I posted a message to Apple's 'webkitsdk' mailing list, but so far have not received any replies... Here is what I tried to do:

I attempted to setup a *very* simple interface - one button, and one General/WebView. The General/WebView is called 'htmlView'. When the button is clicked, it triggers the following method - which is largely based on the sample code above:

    
- (General/IBAction)sendHTTPPost:(id)sender {

	NSURL *cgiUrl = [NSURL General/URLWithString:@"http://www.myserver.com/webToEmail.cgi"];
	General/NSMutableURLRequest *postRequest = General/[NSMutableURLRequest requestWithURL:cgiUrl];

	//setting the headers:
	[postRequest setHTTPMethod:@"POST"];
	General/NSString *boundary = General/[NSString stringWithString:@"------------0xKhTmLbOuNdArY"];
	General/NSString *contentType = General/[NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
	[postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];

	//adding the body:
	General/NSMutableData *postBody = General/[NSMutableData data];
	[postBody appendData:General/[[NSString stringWithFormat:@"%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:General/[[NSString stringWithString:@"Content-Disposition: form-data; name=\"realname\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:General/[[NSString stringWithString:@"Joe Doe"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:General/[[NSString stringWithFormat:@"\r\n%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:General/[[NSString stringWithString:@"Content-Disposition: form-data; name=\"email\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:General/[[NSString stringWithString:@"joe.doe@company.biz"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:General/[[NSString stringWithFormat:@"\r\n%@",boundary] dataUsingEncoding:NSUTF8StringEncoding]];

	[postRequest setHTTPBody:postBody];

	General/htmlView mainFrame] loadRequest:postRequest];
}


As you can see, all values have been *hardcoded* at this stage, to avoid any problems with interface, bindings, etc. - I just want to concentrate on getting the network communications happening... As you can see, it is intended to emulate the posting of a *very* simple html form, which would contain only 2 fields ("realname" and "email"). If I use an *actual* such form in Safari, the cgi works without any problems, and I get an email in my inbox.

However, when I click on my little button in my app, instead of seeing the 'success' page in htmlView, I get an error page, generated by the cgi. It states that "An error has occurred in the program: Malformed Multipart POST". Here is what I've tried doing already:

* changing the encoding of the strings from utf-8 to ascii,
* changing the line breaks from "\r\n" to "\n" and to "\r",
* several different 'boundary' values (the one I'm using now is Apple's own, used by the [[WebView, when *it* submits a successfull form),
* tried converting the final body object from an General/NSMutableData into an General/NSData (postBody = General/[NSData dataWithData:postBody];), just in case.

None of it seems to work. It keeps saying that the post is malformed... But I don't understand what else it is that I'm supposed to be doing to 'form' it properly! Any thoughts? I hope this is going to be something really stupid and trivial...

----

I recommend that you install a network sniffer and see what's going on at the network level. Ethereal is an excellent sniffer (although it requires X11 on OS X) and it can seamlessly show you an entire session's traffic. Compare the working upload with the one that doesn't work, and see what the differences are. This will probably help you a lot.

----
If you are using a General/WebKit General/WebView in your app, then you do not need a sniffer -- try this: 

set the resource load delegate for your webview to a class that implements something like this:

    
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
-(General/NSURLRequest *)webView:(General/WebView *)sender resource:(id)identifier willSendRequest:(General/NSURLRequest *)request redirectResponse:(General/NSURLResponse *)redirectResponse fromDataSource:(General/WebDataSource *)dataSource
{
	if ([request General/HTTPBody] != NULL)  //filter out just the form submissions that have a body
	{
		General/NSLog (@"request: %@\n", request);
		General/NSData* theBodyData = [request General/HTTPBody];
		General/NSString* theBody = General/[[NSString alloc] initWithData:theBodyData encoding:NSUTF8StringEncoding];
		General/NSLog (@"request body: %@\n", theBody);
		[theBody release];
	}
    return request;
}



Then you can submit the form using your webView and see exactly what it sends so that you can mimic it. --General/DaveParizek

----

I got it all working yesterday.!

To get General/KasPer's code working: replace all occurrences of "\n" with "\r\n", and replace "General/NSASCIIStringEncoding" with "NSUTF8StringEncoding". It works!

My code, which now works as well - and even uploads a test file - is below. The problems were in the boundaries. It seems that the boundaries are *much* more fiddly and sensitive than specified in the HTTP POST standards. Here is my working code:

    
- (General/IBAction)sendHTTPPost:(id)sender {
	
	//creating the url request:
	NSURL *cgiUrl = [NSURL General/URLWithString:@"http://www.myserver.com/webToEmail.cgi"];
	General/NSMutableURLRequest *postRequest = General/[NSMutableURLRequest requestWithURL:cgiUrl];
	
	//adding header information:
	[postRequest setHTTPMethod:@"POST"];
	
	General/NSString *stringBoundary = General/[NSString stringWithString:@"0xKhTmLbOuNdArY"];
	General/NSString *contentType = General/[NSString stringWithFormat:@"multipart/form-data; boundary=%@",stringBoundary];
	[postRequest addValue:contentType forHTTPHeaderField: @"Content-Type"];
	
	
	//setting up the body:
	General/NSMutableData *postBody = General/[NSMutableData data];
	[postBody appendData:General/[[NSString stringWithFormat:@"--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:General/[[NSString stringWithString:@"Content-Disposition: form-data; name=\"realname\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:General/[[NSString stringWithString:@"Joe Doe"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:General/[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:General/[[NSString stringWithString:@"Content-Disposition: form-data; name=\"email\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:General/[[NSString stringWithString:@"joe.doe@company.biz"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:General/[[NSString stringWithFormat:@"\r\n--%@\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:General/[[NSString stringWithString:@"Content-Disposition: form-data; name=\"uploadFile\"; filename=\"test.txt\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:General/[[NSString stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
	[postBody appendData:General/[NSData dataWithContentsOfFile:@"/test.txt"]];
	[postBody appendData:General/[[NSString stringWithFormat:@"\r\n--%@--\r\n",stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
	[postRequest setHTTPBody:postBody];
	
	//sending the request via the 'htmlView' General/WebView:
        General/htmlView mainFrame] loadRequest:postRequest];
}


I'm posting this here, as I believe it is a good basis for anyone wanting to write a little class that emulates an html form send/upload. It is easy enough to split the 'setting up the body' section into separate methods, and substitute the hard-coded strings for replaceable variables. I hope it helps others in the future!

----

It should be noted that new in 10.4 is the method      setHTTPBodyStream:  in the [[NSMutableHTTPURLRequest category of General/NSMutableURLRequest. One can use this instead of setHTTPBody: to ensure that entire files don't have to be read into memory before sending them.

I suppose one would do something like this:
    
[postRequest setHTTPBodyStream:General/[NSInputStream inputStreamWithFileAtPath:filePath]];


Though how one would combine this with a multi-part MIME header seems a bit more complex.


----
I am successfully posting several forms following the it works code above.  But one glitch.  With some forms, I need to leave a text input area blank, like say if there is no addressLine2 for a mailing address.
But if I write      @""  for the value that doesn't work, and sending a space does not work.  Sending even a single dash character does work.  What would the browser send if it is nothing?  And would that be referred to as NULL, Nil, or nil?
I will try to go get a network sniffer installed, but if anyone can give me some insight into this I would appreciate it.  --General/DaveParizek


----
It depends on how the server script expects its data.  I'm guessing that it doesn't see     foo == "" as equivalent to     !defined(foo).  So why not just omit     foo altogether?  Don't set it to anything.

----
I tried that.  Both not submitting anything (neither name or value) for that particular form field, and also submitting only the name of the field and omitting any value.  Safari must be sending some indication somehow that the name exists and value empty.  And Safari / General/WebKit would presumably do that in a consistent way.  So the server script would have to deal with how Safari packages it up.  So if I could figure out how it is packaged up when someone submits the form manually, then I could hopefully figure out how to do it thru a programatic post.  So far I have not been able to get ethereal/wireshark installed, once I solve that maybe I can see what it getting passed??  --General/DaveParizek

----
For a quick look at the raw data sent from Safari, you can use tcpdump, which you should already have. Try this: sudo tcpdump -X -s 2048 host myserver.example.com . "2048" displays the first 2K of each packet, because the default packet dump size is quite small. You may need to raise that depending on the size of your data. (If you don't know sudo, look it up before using this). -- General/PaulCollins

----
or General/RushManbert on webkitsdk-dev@lists.apple.com gave me a solution posted above where you can use a General/WebView to look at what is being posted.  thanks to everyone who helped me on this. --General/DaveParizek

----
It is odd that i cant get this to work using General/NSURLConnection sendSynchronousRequest and not General/WebView. I have tried many things and cant figure out why Kaspers code doesnt work, even with the the \r\n and UTF8 fix. I would rather not get General/WebKit involved especially since im not using General/WebView and hiding the window. -- Siavash

I got this to work btw... i was having boundary issues. All good now without General/WebKit
----
The key to make General/KasPer's code alive is to correct newline characters and create a correct boundary. I've done some tracing using General/HTTPScoop to find differences between General/KasPer's code requests and curl's requests and made it work. By the way I've allowed myself to change the way the function determines value's class, because the original wouldn't work as expected for me.
The code below works quite well, I've checked it against a few services. File uploads work like a charm.
    
+(General/NSData *)dataForPOSTWithDictionary:(General/NSDictionary *)aDictionary boundary:(General/NSString *)aBoundary {
    General/NSArray *myDictKeys = [aDictionary allKeys];
    General/NSMutableData *myData = General/[NSMutableData dataWithCapacity:1];
    General/NSString *myBoundary = General/[NSString stringWithFormat:@"--%@\r\n", aBoundary];
    
    for(int i = 0;i < [myDictKeys count];i++) {
        id myValue = [aDictionary valueForKey:[myDictKeys objectAtIndex:i]];
        [myData appendData:[myBoundary dataUsingEncoding:NSUTF8StringEncoding]];
        //if ([myValue class] == General/[NSString class]) {
        if ([myValue isKindOfClass:General/[NSString class]]) {
            [myData appendData:General/[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", [myDictKeys objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
            [myData appendData:General/[[NSString stringWithFormat:@"%@", myValue] dataUsingEncoding:NSUTF8StringEncoding]];
        } else if(([myValue isKindOfClass:[NSURL class]]) && ([myValue isFileURL])) {
            [myData appendData:General/[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", [myDictKeys objectAtIndex:i], General/myValue path] lastPathComponent dataUsingEncoding:NSUTF8StringEncoding]];
            [myData appendData:General/[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [myData appendData:General/[NSData dataWithContentsOfFile:[myValue path]]];
        } // eof if()
        [myData appendData:General/[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    } // eof for()
    [myData appendData:General/[[NSString stringWithFormat:@"--%@--\r\n", aBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
    return myData;
} // eof dataForPOSTWithDictionary:boundary:

Big thanks to General/KasPer for submitting the original piece.
-- General/TomekWojcik

----
Extended the last version by a few lines to allow passing a General/NSData object. Comes in handy when you already have a file in loaded, e.g. from the image picker.

    

+(General/NSData *)dataForPOSTWithDictionary:(General/NSDictionary *)aDictionary boundary:(General/NSString *)aBoundary {
    General/NSArray *myDictKeys = [aDictionary allKeys];
    General/NSMutableData *myData = General/[NSMutableData dataWithCapacity:1];
    General/NSString *myBoundary = General/[NSString stringWithFormat:@"--%@\r\n", aBoundary];
    
    for(int i = 0;i < [myDictKeys count];i++) {
        id myValue = [aDictionary valueForKey:[myDictKeys objectAtIndex:i]];
        [myData appendData:[myBoundary dataUsingEncoding:NSUTF8StringEncoding]];
        //if ([myValue class] == General/[NSString class]) {
        if ([myValue isKindOfClass:General/[NSString class]]) {
            [myData appendData:General/[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", [myDictKeys objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
            [myData appendData:General/[[NSString stringWithFormat:@"%@", myValue] dataUsingEncoding:NSUTF8StringEncoding]];
        } else if(([myValue isKindOfClass:[NSURL class]]) && ([myValue isFileURL])) {
            [myData appendData:General/[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", [myDictKeys objectAtIndex:i], General/myValue path] lastPathComponent dataUsingEncoding:NSUTF8StringEncoding]];
            [myData appendData:General/[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [myData appendData:General/[NSData dataWithContentsOfFile:[myValue path]]];
        } else if(([myValue isKindOfClass:General/[NSData class]])) {
            [myData appendData:General/[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", [myDictKeys objectAtIndex:i], [myDictKeys objectAtIndex:i]] dataUsingEncoding:NSUTF8StringEncoding]];
            [myData appendData:General/[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
            [myData appendData:myValue];
        } // eof if()

        [myData appendData:General/[[NSString stringWithString:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    } // eof for()
    [myData appendData:General/[[NSString stringWithFormat:@"--%@--\r\n", aBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
            
    return myData;
} // eof dataForPOSTWithDictionary:boundary:

-- Bob

----

How to use General/TomekWojcik's solution above for reading the file as stream as the request is being sent? Does General/NSData do that automatically? 

I think that it may read the data from the file into the memory, i.e. to the General/NSData instance. For a large file that is not what I want. I could test it, but I thought that I had better ask before I do.

Thanks.

-- yoichi