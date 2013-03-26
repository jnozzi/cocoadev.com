[[XMLTree]] is a Public Domain Objective-C wrapper for Apple's [[CFXMLParser]] which is provided in the [[CoreFoundation]]. Only basic access to the XML trees are available with v0.2.1 (December 2002).

http://iharder.net/macosx/xmltree/

[[XMLTree]] is useful if you need to work with XML with any version of OS X before 10.4. However, if working with only Tiger, [[NSXml]] works great.

----

Remember, to read the text from a CDATA node, be sure to use:
<code>
[[[tree  descendentNamed:@"name"] childAtIndex:0] description];
</code>