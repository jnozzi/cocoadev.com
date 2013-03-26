

Hi,

are there some methods to easily read xml files and their nodes?
The same for writing them. I haven�t found anything yet.

Greetings

[[ThomasSempf]]

----

Hi [[ThomasSempf]],
for getting an xml file into an array: [[[[NSArray]] alloc] initWithContentsOfFile: @"myinput.xml"].
for saving an array to an xml file: [anArray writeToFile: @"myoutput.xml" atomically: NO]

Then you can simply read/write the single elements within the array.
Hope it helps.

Bye
peacha

----

Be careful not to confuse XML files with [[XmlPropertyLists]]. An XML file can contain a variety of data in a variety of formats. [[XmlPropertyLists]] refers to a specific XML format to store arrays, strings, dictionaries, for [[ObjC]] and [[CoreFoundation]] applications.

Anyone know how you read and write arbitrary XML files? Can it be done with [[CoreFoundation]]?

-- [[MikeTrent]]

----

An [[NSArray]] reads/writes "pure" XML files, while an [[NSDictionary]] operates (with the same methods as [[NSArray]]) on property lists.
You can do it even with [[CoreFoundation]]: there is "Property List Services" for that.
In [[CoreFoundation]]/[[CFPropertyList]].h there is function [[CFDataRef]] [[CFPropertyListCreateXMLData]] ([[CFAllocatorRef]], [[CFDictionaryRef]]);

peacha

----

Eh? You're still talking about property lists, which can only support strings, arrays, dictionaries, numbers and booleans. In [[CoreFoundation]] you can use XML Services for generic XML parsing. See http://developer.apple.com/techpubs/macosx/[[CoreFoundation]]/[[XMLServices]]/xmlservices_carbon.html

''Apple's new layout is a bit different: you might want to try'' http://developer.apple.com/documentation/[[CoreFoundation]]/Conceptual/CFXML/index.html ''instead.''

-- [[FinlayDobbie]]

----

Hey, you're right Finlay. And wow, it even lets you customize the parser! I must admit that I am missing a lot of interesting things about [[CoreFoundation]].

peacha

----

If you want a Framework for XML see here: http://www.subsume.com/static/[[WebObjects]]/[[SubsumeSite]]/[[SubsumeSite]]/Tech/Software/STXML.html

----

Also check out [[XMLTree]], a Public Domain Objective-C wrapper for Apple's XML parser.

----

A real, DOM-compliant, XML framework is Iconara DOM Framework ([[IconaraDOM]]). It's similar to the Java frameworks JDOM (www.jdom.org) and XOM (www.xom.nu). What's more: it's GPL'ed. 

[[IconaraDOM]]: http://sourceforge.net/projects/iconaradom

----

I'm trying to use [[XMLTree]] to read an XML file. This is what I'm trying to read:

<code>
<?xml standalone="yes" version="1.0" ?>
<Preferences>
	<Registration>
		<Name>[[TestPerson]]</Name>
	</Registration>
</Preferences>
</code>

Now when I call [[[XMLTree]] description], it returns "[[TestPerson]]" (minus the quotes). When I call [[[XMLTree]] count], it returns 3. Now I wan't to read the "Name" item. Here's what I'm trying:

<code>
[[XMLTree]] ''file = [[[XMLTree]] treeWithURL:[NSURL fileURLWithPath:[_HOME stringByAppendingString:_acpAlarmsPathComponent]]];
[[XMLTree]] ''prefs = [file descendentNamed:@"Preferences"];
[[XMLTree]] ''registration = [prefs descendentNamed:@"Registration"];
[[NSString]] ''theName = [registration attributeNamed:@"Name"];
</code>

However, no matter what I do, theName is always nil. I can't figure it out. I was hoping someone here could help me out a little bit. Thanks.

''It looks like Name is a descendent, not an attribute.''

----

The same example with Iconara DOM (see above):

<code>
[[DOMDocument]] ''document = [[[DOMBuilder]] documentFromFile:@"whicheverfile"];
[[DOMElement]] ''prefs = [document rootElement];
[[DOMElement]] ''reg = [[prefs children] objectAtIndex:0];
[[NSString]] ''theName = [[[reg children] objectAtIndex:0] string];
</code>

or in v1.1 (comming soon)

<code>
[[DOMDocument]] ''document = [[[DOMBuilder]] documentFromFile:@"whicheverfile"];
[[NSString]] ''theName = [[document getElementsByTagName:@"name"] objectAtIndex:0];
</code>

or you could do it with an [[XPath]] filter.

-- [[TheoHultberg]]/Iconara

----

It appears the the [[CFXMLTree]] create functions don't like XML that defines variable numbers of child elements, e.g.

<code>
<?xml version="1.0" standalone="yes"?>
<!DOCTYPE person [
<!ELEMENT first_name (#PCDATA)>
<!ELEMENT last_name (#PCDATA)>
<!ELEMENT profession (#PCDATA)>
<!ELEMENT name (first_name, last_name)>
<!ELEMENT person (name, profession'')>      <--- THIS LINE
]>
<person>
  <name>
    <first_name>Alan</first_name>
    <last_name>Turing</last_name>
  </name>
  <profession>computer scientist</profession>
  <profession>mathetician</profession>
  <profession>cryptographer</profession>
</person>
</code>

Note the '' after the profession. I get a nil [[CFXMLTree]] if I put that in, but  if I take it out and make no other changes, the [[CFXMLTree]] is created. Is this to be expected? Is there something about [[CFXMLTrees]] that require a single child (or equal number of children) per node?
-- [[GKinnel]]