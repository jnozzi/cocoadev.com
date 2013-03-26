I have seen Apple use a question mark embedded in a circle (in textual context), which I think is a glyph somewhere, but I cannot find it.

Does anybody know if this glyph has a legal unicode mapping?

----

That glyph is for the Help key. [[NSEvent]].h defines it as U+F746, which is in Unicode's Private Use Area. -- [[DustinVoss]]

----

I'm not sure if there's a single composed Unicode character representing this glyph, but one mapping that works is the following decomposed two-character sequence:
<code>
  0x003F   QUESTION MARK
  0x20DD   COMBINING ENCLOSING CIRCLE
</code>

You can get this glyph in a form that you can copy-and-paste using the following. This just prints out the Unicode dual-byte-ordering hint (0xFEFF) followed by the two characters, all using their octal equivalents. The glyph draws in most fonts, although the rendering in every font seems to be identical which makes me think that it's using a default glyph.
<code>
printf "\376\377\000\077\040\335\000\n" > /tmp/qmic.txt
open -e /tmp/qmic.txt
</code>

--[[DrewThaler]]

----

Thanks, this works! except that the glyph has like a space in front of it or similar, and I get the following from the console:
<code>
Font GB18030Bitmap: in _readBasicMetricsForSize, claims 0 max advance but is fixed-pitch.
Font Screen-GB18030Bitmap: in _readBasicMetricsForSize, claims 0 max advance but is fixed-pitch.
</code>

This is how I create the string (which I use for a button title, using setTitle: on [[NSButton]]):
<code>
unichar chars[] = { 0xFEFF, '?', 0x20DD };
[[NSString]] ''str = [[[NSString]] stringWithCharacters:str length:sizeof(chars)/sizeof(chars[0])];
</code>

----

You shouldn't need the byte-order metacharacter in an [[NSString]]; all the unicode characters in an [[NSString]] are implicitly in native byte order. The 0xFEFF was simply to make sure [[TextEdit]] recognized the .txt file as unicode. Try it without the 0xFEFF.

----

I'm an idiot :-) actually I did try the "COMBINING ENCLOSING CIRCLE" character before posting this question, but couldn't make it work -- then I saw your reply and figured that 0xFEFF was a hint that the next two characters were to be combined (not that the file was UTF-16 BE) -- but just removed the hint, and that works... so I don't know what I did in the first place, but thanks a lot for making it work!