Describe [[XcodeDebuggerPO]] here.

The command '''gdb>po <NS obj>''' doesn't work.

My environment:
Xcode 3.0 running on a [[MacBook]] Pro (intel) via Tiger (OS 10.5.1).

Here's a snippet of the code:

<code>
-(void)awakeFromNib {
    [[NSLog]](@"{awakeFromNib}");
    [[NSXMLElement]] ''root = ([[NSXMLElement]] '')[[[NSXMLNode]] elementWithName:@"addresses"];
    xmlDoc = [[[[NSXMLDocument]] alloc] initWithRootElement:root];
    [xmlDoc setVersion:@"1.0"];
    [xmlDoc setCharacterEncoding:@"UTF-8"];
    
    // The following [[NSXMLElement]] generates a parent.  Hence you can't add it to root.
    [[NSXMLElement]] ''xmlNoodle; 
    [xmlNoodle setName: @"[[RicNode]]"];         
    [xmlNoodle setStringValue:@"Pumpkin"];  // Note: this node has a parent; hence can't use "addChild".
    [xmlNoodle attributeForName:@"Spanky"];
    
    [[NSString]] ''myString = [[[NSString]] stringWithString:@"Hello World!"];
...
</code>

I can reveal the [[NSXMLElement]] object, but not [[NSString]]:

<code>
(gdb) po myString
Cannot access memory at address 0x0
(gdb) po xmlNoodle
<[[RicNode]]>Pumpkin</[[RicNode]]>
Current language:  auto; currently objective-c
(gdb) 
</code>

I have the optimization off.
I suspect it's because I'm debugging on the Intel chip vs PPC.
Everything had worked on my G4 & G3.

Any ideas?

Ric.

----

You haven't told us where you're breaking. If you're breaking on the line where myString is created, there's your problem. The line hasn't been executed yet.

----
Can you elaborate on the problem? From what you post, the <code>po</code> command is working absolutely fine. The first time you give it nil, and it tells you that you can't do this on nil. The second time you give it an object, and it prints its description. What is wrong with that?