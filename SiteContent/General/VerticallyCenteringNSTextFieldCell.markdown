

I'm have an [[NSMatrix]] with some [[NSTextFieldCells]], and I'd like to center the text inside each cell both vertically and horizontally, but it doesn't seem to be working. I figured that I could use some [[NSAttributedStrings]] to do this, but for some reason it's not working. Here's my code.

<code>
[[NSTextFieldCell]] ''cell = [grid cellAtRow:0 column:0]; // grid is an [[NSMatrix]]
[[NSFont]] ''stringFont = [[[NSFont]] fontWithName:@"Lucida Grande" size:12.0];
[[NSMutableParagraphStyle]] ''stringStyle = [[[[NSMutableParagraphStyle]] defaultParagraphStyle] mutableCopy];
[stringStyle setAlignment:[[NSCenterTextAlignment]]];
[[NSArray]] ''attrib = [[[NSArray]] arrayWithObjects:stringFont,[[[NSNumber]] numberWithFloat:10.0],stringStyle,nil];
[[NSArray]] ''attribnames = [[[NSArray]] arrayWithObjects:[[NSFontAttributeName]],[[NSBaselineOffsetAttributeName]],[[NSParagraphStyleAttributeName]],nil];
[[NSDictionary]] ''stringAttributes = [[[NSDictionary]] dictionaryWithObjects:attrib forKeys:attribnames];
[[NSAttributedString]] ''string = [[[[NSAttributedString]] alloc] initWithString:@"A" attributes:stringAttributes];
[cell setAttributedStringValue:string];
</code>

The horizontal centering is working fine, but I've tried many values (possitive, negative, big, small) for [[NSBaselineOffsetAttributeName]] but it doesn't seem to have any effect at all. Can someone tell me what am I doing wrong?

Thanks in advance,
- [[PabloGomez]]

----

See http://www.cocoadev.com/index.pl?[[VerticallyCenteringTableViewItems]]

----

I wanted to avoid subclassing [[NSTextFieldCell]]. Isn't there a way to do it without subclassing?
Nevermind, I finally gave up and decided to just go ahead and subclass [[NSTextFieldCell]] as you suggested. Thanks for helping.