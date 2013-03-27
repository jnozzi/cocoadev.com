Instances of the General/NSXMLElement class represent element nodes in an XML tree structure. 
An General/NSXMLElement object may have child nodes, specifically comment nodes, processing-instruction nodes, text nodes, and other General/NSXMLElement nodes. 
It may also have attribute nodes and namespace nodes associated with it (however, namespace and attribute nodes are not considered children). 
Any attempt to add a General/NSXMLDocument node, NSXMLDTD node, namespace node, or attribute node as a child raises an exception. 
If you add a child node to an General/NSXMLElement object and that child already has a parent, General/NSXMLElement raises an exception; the child must be detached or copied first.