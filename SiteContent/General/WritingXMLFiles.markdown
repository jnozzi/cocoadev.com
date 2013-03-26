There are four ways to write XML on OS X:


* [[XmlPropertyLists]] by calling writeToFile:atomically:
* using a third party library such as Xerces, [[IconaraDOM]] (see bottom for code example) or [[XMLTree]]
* using Apple's [[CFXMLParser]] API
* since Tiger, using Apple's NSXML API


This article explains the third method, using [[CFXMLParser]] in the [[CoreFoundation]] API.  Here is the XML document we will be creating:

<code>
<?xml version="1.0" encoding="utf-8"?>

<person>
	<name> Alan Turing </name>
	<website href="http://turing.org" />
</person>
</code>

The above XML is made up of a tree of [[CFXMLNode]] objects.  The particular type of node is based on [[CFXMLNodeTypeCode]].  The following is a break down of the various types used in the example:

<code>
1)  kCFXMLNodeTypeDocument
2)      kCFXMLNodeTypeProcessingInstruction -- "<?xml version="1.0" encoding="utf-8"?>"
3)      kCFXMLNodeTypeElement -- "<person>"
4)         kCFXMLNodeTypeElement -- "<name>"
5)            kCFXMLNodeTypeText -- "Alan Turing"
6)            kCFXMLNodeTypeElement -- "<website href="http://turing.org" />"
</code>

''' 1) Document '''

We begin by creating a document node.  All further nodes will be added as children to this node (xmlDocument).

<code>
	[[CFXMLDocumentInfo]] documentInfo;
	documentInfo.sourceURL = NULL;
	documentInfo.encoding = kCFStringEncodingUTF8;
	[[CFXMLNodeRef]] docNode = [[CFXMLNodeCreate]](
		kCFAllocatorDefault,
		kCFXMLNodeTypeDocument,
		CFSTR(""),
		&documentInfo,
		kCFXMLNodeCurrentVersion);
	[[CFXMLTreeRef]] xmlDocument = [[CFXMLTreeCreateWithNode]](kCFAllocatorDefault, docNode);
	[[CFRelease]](docNode);
</code>

''' 2) Instruction Tag '''

The first line of our document needs to be the <?xml /> processing instruction.  Here's how we create and add it to the document.

<code>
	[[CFXMLProcessingInstructionInfo]] instructionInfo;
	instructionInfo.dataString = CFSTR("version=\"1.0\" encoding=\"utf-8\"");
	[[CFXMLNodeRef]] instructionNode = [[CFXMLNodeCreate]](
		NULL, 
		kCFXMLNodeTypeProcessingInstruction,
		CFSTR("xml"),
		&instructionInfo,
		kCFXMLNodeCurrentVersion);
	[[CFXMLTreeRef]] instructionTree = [[CFXMLTreeCreateWithNode]](kCFAllocatorDefault, instructionNode);
	[[CFTreeAppendChild]](xmlDocument, instructionTree);
	[[CFRelease]](instructionTree);
	[[CFRelease]](instructionNode);
</code>


''' 3) Document's Root Element '''

The <person> tag is the document's root element.  We'll later add two sub-elements to this node.  Notice how personInfo.isEmpty is set to NO.  This tell [[CFXMLParser]] that the tag will have child nodes added to it later.  If you forget to do this you output will look like this: '' <person /> <name>Alan Turing </name> ''.

<code>
	[[CFXMLElementInfo]] personInfo;
	personInfo.attributes = NULL;
	personInfo.attributeOrder = NULL;
	personInfo.isEmpty = NO;	
	[[CFXMLNodeRef]] personNode = [[CFXMLNodeCreate]] (
	   kCFAllocatorDefault,
	   kCFXMLNodeTypeElement,
	   ([[CFStringRef]])@"person",
	   &personInfo,
	   kCFXMLNodeCurrentVersion);	
	[[CFXMLTreeRef]] personTree = [[CFXMLTreeCreateWithNode]](kCFAllocatorDefault,personNode);
	[[CFTreeAppendChild]](xmlDocument, personTree);
	[[CFRelease]](personNode);
</code>


''' 4) Name Sub-Element '''

Now we add the name node.  The text it contains is a separate node we'll add next.

<code>
	[[CFXMLElementInfo]] nameInfo;
	nameInfo.attributes = NULL;
	nameInfo.attributeOrder = NULL;
	nameInfo.isEmpty = NO;	
	[[CFXMLNodeRef]] nameNode = [[CFXMLNodeCreate]] (
	   kCFAllocatorDefault,
	   kCFXMLNodeTypeElement,
	   ([[CFStringRef]])@"name",
	   &nameInfo,
	   kCFXMLNodeCurrentVersion);	
	[[CFXMLTreeRef]] nameTree = [[CFXMLTreeCreateWithNode]](kCFAllocatorDefault,nameNode);
	[[CFTreeAppendChild]](personTree, nameTree);
	[[CFRelease]](nameTree);
	[[CFRelease]](nameNode);
</code>

''' 5) Text Element '''

The actual value of the name element is a separate node.

<code>
	[[CFXMLNodeRef]] nameTextNode = [[CFXMLNodeCreate]] (
	   kCFAllocatorDefault,
	   kCFXMLNodeTypeText,
	   ([[CFStringRef]])@"Alan Turing",
	   NULL,
	   kCFXMLNodeCurrentVersion);	
	[[CFXMLTreeRef]] nameTextTree = [[CFXMLTreeCreateWithNode]](kCFAllocatorDefault,nameTextNode);
	[[CFTreeAppendChild]](nameTree, nameTextTree);
	[[CFRelease]](nameTextTree);
	[[CFRelease]](nameTextNode);
</code>

''' 6) Adding Attributes '''

In this node we'll add an attribute.  [[CFXMLElementInfo]]::attributes is a dictionary of attributes.  The key is the attribute's name as a string (in this case "href").  The object is the attribute's value (in this case "http://turing.org").  [[CFXMLElementInfo]]::attributeOrder is a list of all the attribute names in the same order as they should be written out in the final document.

<code>
	[[NSDictionary]] ''attributeDictionary = [[[NSDictionary]]
	   dictionaryWithObject:@"http://turing.org" forKey:@"href"];
	[[NSArray]] ''attributeArray = [[[NSArray]] arrayWithObject:@"href"];
	[[CFXMLElementInfo]] websiteInfo;
	websiteInfo.attributes = ([[CFDictionaryRef]]) attributeDictionary;
	websiteInfo.attributeOrder = ([[CFArrayRef]]) attributeArray;
	websiteInfo.isEmpty = YES;	
	[[CFXMLNodeRef]] websiteNode = [[CFXMLNodeCreate]] (
	   kCFAllocatorDefault,
	   kCFXMLNodeTypeElement,
	   ([[CFStringRef]])@"website",
	   &websiteInfo,
	   kCFXMLNodeCurrentVersion);	
	[[CFXMLTreeRef]] websiteTree = [[CFXMLTreeCreateWithNode]](kCFAllocatorDefault,websiteNode);
	[[CFTreeAppendChild]](personTree, websiteTree);
	[[CFRelease]](websiteTree);
	[[CFRelease]](websiteNode);
</code>

''' 7) Saving and Clean Up '''

Now the final step, to write the document to disk.  This is achieved with the [[CFXMLTreeCreateXMLData]] function.  If you view the resulting xml file in a text editor you'll notice that all the output is on one line.

<code>
	[[CFDataRef]] xmlData = [[CFXMLTreeCreateXMLData]](kCFAllocatorDefault, xmlDocument);
	BOOL result = [([[NSData]] '')xmlData writeToFile:@"foo.xml" atomically:YES];
	[[NSAssert]](result, @"Writing to file failed");
	[[CFRelease]](xmlData);
	[[CFRelease]](personTree);  // god kills a kitten every time you leak memory :-P
	[[CFRelease]](xmlDocument);
</code>

--[[SaileshAgrawal]]

----

Another way of doing this is to use [[XMLTree]], or the DOM framework ([[IconaraDOM]]). Both ways are considerably simpler, and, being the author of the DOM framework, I would say that it is the prefered way of doing it.

Now, to produce the same XML-document as in the example above, do this:

<code>
id <[[DOMDocument]]> document;
id <[[DOMElement]]> personElement, nameElement, websiteElement;
id <[[DOMText]]> text;
id <[[DOMAttribute]]> hrefAttribute;

// 1) Create a document
document = [[[DOMDocument]] document];

// 2) Instruction tag
// not necessary, will be added by the formatter

// 3) Document's root element
personElement = [[[DOMElement]] elementWithName:@"person"];
[document setDocumentElement:personElement]; 

// 4) Name subelemet
nameElement = [[[DOMElement]] elementWithName:@"name"];
[personElement appendChild:nameElement];

// 5) Text element
text = [[[DOMText]] textWithString:@"Alan Turing"];
[nameElement appendChild:text];

// 6) Adding attributes
websiteElement = [[[DOMElement]] elementWithName:@"website"];
hrefAttribute = [[[DOMAttribute]] attributeWithName:@"href" value:@"http://turing.org"];
[websiteElement addAttribute:hrefAttribute];
[personElement appendChild:websiteElement];

// 7) Saving and cleaning up
[[[DOMFormatter]] writeNode:document [[ToFile]]:@"foo.xml"];
</code>

Update: the adding the prolog is not necessary (and really an error), so that step has been removed.
Update: rewrote example to work with the v2.0 interface.

This is also the way it is done in other DOM-compliant frameworks, such as DOM, JDOM and XOM for Java. If you have worked with any of these, the DOM framework for Cococa ([[IconaraDOM]]) will look familiar. 
The DOM (Document Object Model) is the prefered way of working with XML-documents if you need to insert, remove and rearrange parts of it. This can also be done with CFXML, NSXML or [[XMLTree]], but it is more cumbersome.

-- [[TheoHultberg]]/Iconara

----

[[XMLTree]] doesn't support creating XML, correct? Maybe I'll go ahead and do that :-)