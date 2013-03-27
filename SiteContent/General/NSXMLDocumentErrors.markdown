Big mistake on my part...duh!  I was releasing the NSURL, General/NSXMLDocument, and error...I should not be releasing those, as I did not allocate the memory...caused the application to crash... *Except the General/NSXMLDocument...don't forget to release that. --General/JediKnil*
----
I have a a very simple method that parses an XML file.  The parse of the XML causes a "sigterm 11" and my app crashes.  Below is the method that is executed:  I looked at Apple's documentation for General/NSXMLDocument, and I've
adapted their code sample here.  Any help/suggestions would be greatly appreciated. 

     
- (General/IBAction)parseXMLConfig:(id)sender
{
    General/NSString *file = @"/path-to/config.xml";
    General/NSXMLDocument *xmlDoc;
    General/NSError *err = nil;
    NSURL *furl = [NSURL fileURLWithPath:file];
    if (!furl) {
        General/NSLog(@"Can't create an URL from file %@.", file);
        return;
    }
    xmlDoc = General/[[NSXMLDocument alloc] initWithContentsOfURL:furl
												  options:(General/NSXMLNodePreserveWhitespace|General/NSXMLNodePreserveCDATA)
												  error:&err];
    //General/NSLog(@"General/XMLDocument: %@\n", xmlDoc);
    if (xmlDoc == nil) {
        xmlDoc = General/[[NSXMLDocument alloc] initWithContentsOfURL:furl
												  options:General/NSXMLDocumentTidyXML
	                  									  error:&err];
    }
    if (xmlDoc == nil)  {
        if (err) {
            General/NSLog(@"Handle an error");
        }
        return;
    }        
    if (err) {
		General/NSLog(@"Handle an error");
        
    }

	[furl release];
	[xmlDoc release];
	[err release];
	[file release];
}
 

*The only thing that should be released in the above code is xmlDoc. Everything else is autoreleased, meaning you don't release it.*