General/CocoaDev is probably not the best place to ask this question since it isn't strictly Cocoa related. But, having said that, people here are friendly and have always helped me out.

I'm attempting to write a nice credits.rtf for my About... box -- in it I want to provide links to the various open-source project sites which supplied libraries I use. I figured it would be the Right Thing; now, the trouble is, I have no freaking idea how to make textEdit do two things:


*Set margins
*Make href links clickable


I've read the help files for General/TextEdit and with regards to setting margins, I follow the instructions ( dragging the down-facing ruler arrows ) and this resultedin exactly nothing. And with regards to clickable links, I have no idea at all. There's no "Make URL..." menu item or command that I can find, and General/TextEdit doesn't seem smart enough to detect and clickable-ify obvious href:// type links.

Any ideas?

--General/ShamylZakariya

----

You can use an index.html for your About box, and it happily lets you make hyperlinks.  Dunno about margins, but it does support stuff like <blockquote>.

*If it's using General/WebKit, rather than the old General/HTMLRendering.framework, you could use CSS for margins.*

Lord knows what the standard about box uses (which is the crux of the question here).

----

I, too, have been frustrated by margins.  I have been able to do left and right, but General/TextEdit seemingly has nothing for top and bottom.

----

You can always add it yourself. An RTF document is just plain text, and the format is on Microsoft's web site.

----

True. But that's like saying a program which edits a filetype is not responsible for doing it correctly, provided a low-level specification is available. I've spent plenty of time decoding file formats; hell, I wrote a photoshop file parser/loader ( & general API ) for General/BeOS's image services ( http://www.bebits.com/app/1343 ) -- I'm comfortable decoding file formats and I'm comfortable with a Hex editor.

But, I am *not* interested in decoding the RTF format so I can add margins when I have more important work to do. General/TextEdit should work correctly, or else Apple should remove the margin setter from the ruler.

--General/ShamylZakariya

I'm not sure if I will be answering the question, but the answer for the margins looks obvious.  You just use the square thing on General/TextEdit's ruler, as well as the triangle thing on the ruler.  As for the hyperlinks, you can go into iChat and copy out a hyperlink, as noted in the following Mac OS X hint: http://www.macosxhints.com/article.php?story=2003110321205582 -- General/RossDude

----
The URL's in General/TextEdit are just plain simple RTF.
    
\f0\fs24 \cf0 visit General/CocoaDev! - {\field{\*\fldinst{HYPERLINK "http://www.cocoadev.com"}}{\fldrslt General/CocoaDev

Microsoft Word and General/TextEdit both recognize it, but not General/AppleWorks (if you were curious) :) -- General/KevinWojniak

----
If you go to OSXHINTS and search for General/TextEdit you will find a discussion about how to customize General/TextEdit for changing margins. Let us know how you do...
Richard

----

Inablility to click links in credits rtf file is a panther bug, and the workaround is to use an html file instead.

<http://www.cocoabuilder.com/archive/message/cocoa/2004/9/4/116648>

(Ali is an Apple employee)

*If it's using General/WebKit, rather than the old General/HTMLRendering.framework, you could use CSS for margins.*

Sadly, it does not use General/WebKit.  You could take a shot at doing margins the old-fashioned way in html, maybe that would work..

-General/KenFerry

[Later] Oops, looks like this is an old question resurrected.