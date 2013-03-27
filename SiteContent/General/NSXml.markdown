NSXML is a set of classes introduced in OS X 10.4 (Tiger) that deals with a complete XML tree.

It is comprised of these General/FoundationKit classes:

*General/NSXMLNode
*General/NSXMLDocument
*General/NSXMLElement
*NSXMLDTD (wikified as General/NSXmlDtd)
*General/NSXMLDTDNode

It does not include General/NSXMLParser, though NSXML does use it to parse XML.

Apple's unusually good overview is at < http://developer.apple.com/documentation/Cocoa/Conceptual/NSXML_Concepts/index.html >.

----

NSXML supports many cool things:

*User data associated with XML elements and attributes
*General/NSValueTransformer
*DTD manipulation
*XML namespaces
*General/XQuery and General/XPath
*XSLT document transformations (wikified as General/XSLTransformations)
*General/XInclude
*General/CocoaBindings


In particular, General/XPath takes all the drudgery out of reading XML values.