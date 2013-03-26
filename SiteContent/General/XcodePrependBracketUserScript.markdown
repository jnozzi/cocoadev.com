

This is only marginally related to [[CocoaDevelopment]], and is more a matter of an annoyance while typing [[ObjC]] code into [[XCode]].

Having had past experience with [[CPlusPlus]] nested structures and Java method calling and liking how that [[ObjC]] declares it valid for [[MessagingNil]] most of the time, I'm finding that I'm stringing together 2 or 3 consecutive calls to various [[AppKit]] or Foundation methods, like so...

<code>
style = [[[[[NSParagraphStyle]] defaultParagraphStyle] mutableCopy] autorelease];
</code>

I'm finding all to often, than when I start typing a line, I don't accurately forecast the [[MethodBracket]] depth. As a result, I find myself repeatedly backspacing or mousing back to earlier in the line to insert a leading bracket, or enduring [[XCode]] beeping at me when I type a trailing bracket before balancing them.

Does anybody here have a short [[AppleScript]] or Perl script suitable for the User Script menu that I can use to do the following...


*Travel backwards in the current source file across the mostly recently balanced method invocation
*Insert a leading bracket before the balanced bracket pair
*Return the text insertion point back to before the script executed


For example, starting with the source editor with this state... ([[PipeCharacter]] is the cursor.)

<code>
style = [[[NSParagraphStyle]] defaultParagraphStyle] mutableCopy|
</code>

I want the script to leave the following result...

<code>
style = [[[[NSParagraphStyle]] defaultParagraphStyle] mutableCopy|
</code>

I'd write it myself, but [[AppleScript]] is lousy at [[TextManipulation]], and concerning Perl, I am not even [[KnowingEnoughToBeDangerous]]. I also suspect other developers here would appreciate having such a script as well. I '''can't''' be the only one annoyed by this; there doesn't seem to be an obvious keyboard shortcut to navigate text by punctuation balancing, just words and lines.

-- [[DLWormwood]]

----

Just a further note, I've since attempted to use [[AppleScript]] with Xcode to solve this issue, but while I'm able to reliably get the current selection via a script method, I'm unable to do anything with it. Script Editor will kindly display exactly where in the document and what kind of state it is when returned as the result, but refuses to script any property extraction. When I get the record of properties, AS lists the content as "private." I guess this means selection manipulation isn't possible with Xcode 2.4 yet...