

Cocoa's DOM (General/DocumentObjectModel) implementation.

http://developer.apple.com/documentation/Cocoa/Conceptual/General/DisplayWebContent/index.html

Classes:
[Topic]

----

The General/DOMDocument, General/DOMNodeList, General/DOMNamedNodeMap and General/DOMNode form the foundation for building HTML object trees. General/WebFrame's method     General/DOMDocument returns the root node for the frame's General/NSURLRequest. You can walk through the document tree starting with this node to examine all of the page's leafs.

    
- (void)walkNodeTree:(General/DOMNode *)parent {
	General/DOMNodeList *nodeList = [parent childNodes];
	unsigned i, length = [nodeList length];
	for (i = 0; i < length; i++) {
		General/DOMNode *node = [nodeList item:i];
		[self walkNodeTree:node];
		General/DOMNamedNodeMap *attributes = [node attributes];
		unsigned a, attCount = [attributes length];
		General/NSMutableString *nodeInfo = General/[NSMutableString stringWithCapacity:0];
		General/NSString *nodeName = [node nodeName];
		General/NSString *nodeValue = [node nodeValue];
		[nodeInfo appendFormat:@"node[%i]:\nname: %@\nvalue: %@\nattributes:\n", 
								i, nodeName, nodeValue];
		for (a = 0; a < attCount; a++) {
			General/DOMNode *att = [attributes item:a];
			General/NSString *attName = [att nodeName];
			General/NSString *attValue = [att nodeValue];
			[nodeInfo appendFormat:@"\tatt[%i] name: %@ value: %@\n", a, attName, attValue];
		}		
		General/NSLog(nodeInfo);
	}
}

- (void)webView:(General/WebView *)sender didFinishLoadForFrame:(General/WebFrame *)frame {
	General/WebDataSource *dataSource = [frame dataSource];
	General/NSArray *subresources = [dataSource subresources];
	General/DOMDocument *doc = [frame General/DOMDocument];
	[self walkNodeTree:[doc documentElement]];
}

 

You can edit HTML directly through Apple's DOM implementation by setting the supporting General/WebView to editable (    [webView setEditable:YES];). Apple's documentation is kind of lean right now, so hopefully more can be posted here.

--zootbobbalu

----

I want to set the values of specific HTML form fields in a web view. It seems like accessing the DOM is the way to do this (I don't see any hooks in the General/WebView General/APIs) but I just can't make it work. I started by finding the General/DOMNode I want to set using the walkNodeTree code above and then tried to manipulate a node using methods from http://developer.apple.com/documentation/Darwin/Reference/General/ManPages/mann/domNode.n.html. 

    
// inside the for() look in walkNodeTree, find a node with a "value" attribute (in my case, an input type=text)
if( [attName isEqualToString:@"value"] ){
    // warning: General/DOMNode does not respond to setAttribute
    [node setAttribute:@"value" :@"blah"];// attributeName newValue

    // this has no effect, probably b/c it doesn't set an attribute, but the "value"
    [node setNodeValue:@"blah"];

    // this is the approach used in apple's General/DOMHTMLEditor example, except it still has no effect
    General/DOMNode *newNode = [parent replaceChild:node:[parent firstChild]];
}


There must be a way to do this, or else how would Safari's "Remember password" feature work? 

Thanks, Robert