I am working on a program that needs to scroll large (ie. long and with a variable font-size, ie. could be small could be large) text across the screen in a looping fashion.

Currently, I am using an General/NSTextField that I simply slide across the Window to scroll. The text within the General/NSTextField is repeated twice and I simply loop back to the start once it gets to the middle point.

However, this is causing major CPU usage... at around 20% for a large string at a size 12 font. This is probably because the whole large box has to be dragged across the window. I also have to call setNeedsDisplay.

What is the best way to this? Some special controls, General/QuickDraw or something?

----

**Possible Answer** Why not use Quartz drawing instead? You can draw into an image buffer, and simply display that buffer twice. Here are two methods you would find in a custom General/NSView class:

    

- (void)drawRect:(General/NSRect)rect {	
	General/NSRect rectBounds = [self bounds];	
	General/[self controller] backgroundColor] set];
	[[NSRectFill(rectBounds);

	// draw the text image (twice!)	
	General/self textImage] compositeToPoint:_textBounds.origin operation:[[NSCompositeSourceOver];
	General/NSSize textSize = General/self textImage] size];
	[[NSPoint secondPoint = General/NSMakePoint(_textBounds.origin.x,_textBounds.origin.y);
	secondPoint.x += textSize.width;
	General/self textImage] compositeToPoint:secondPoint operation:[[NSCompositeSourceOver];

}


-(void)redrawText {
	// create the text image
	General/NSImage* textImage = General/[[NSImage alloc] initWithSize:General/self controller] size;
	[textImage autorelease];
		
	// redraws the text into a graphics buffer, for later displaying on the screen
        // I assume there is an array of textual items, stored in a controller object,
        // which need to be displayed one after another, horizontally
	[textImage lockFocus];
	General/NSPoint origin = General/NSMakePoint(0.0,0.0);
	for(unsigned index = 0; index < General/self controller] count]; index++) {
		[[NSString* title = General/self controller] titleAtIndex:index];
		[[NSDictionary* attributes = General/self controller] attributesAtIndex:index];
		[[NSSize titleSize = [title sizeWithAttributes:attributes];
		[title drawAtPoint:origin withAttributes:attributes];
		origin.x += titleSize.width + 20.0;
	}
	[textImage unlockFocus];

	// text has changed, therefore we need to update the display
	[self setTextImage:textImage];
	[self setNeedsDisplay:YES];
}



You could make lots of improvements to bring the resource usage right down.

----

It works just fine for smaller font sizes and strings, but if I try to use a font size of say, 400, with a string of maybe 50 characters or so... it is unable to allocate the memory it needs (i guess it needs too much memory since its a large uncompressed image that it needs to buffer):

    Exception raised during posting of notification.  Ignored.  exception: Can't cache image

What should I do about this? :-/

----

OK, so if you want letters 6 inches tall you might be better off creating an image buffer for each letter beforehand. During operation, you'd only then use the images you need for any particular frame. During the rendering, quartz will mainly use the graphics processor to do the image copy, rather than your CPU, (which would be used to generate the glyphs initially). 

----

I am sure I can work with this code, haven't tried it yet, but sounds like a good idea, and probably would be even better if only the needed glyphs are generated. But, I am wondering if all the code in the drawRect method will end up using a lot of CPU?

----

The only thing drawRect really does is repeatedly call General/NSImage's compositeToPoint method. I assume (rightly or wrongly) that this method is passed off to the graphics card for processing, rather than being done by the CPU. Give it a go!

----

I've written the code below to generate the glyph images and store them in an General/NSMutableDictionary, however after a few characters, it seems to soon run right back to the same problem:

    

2004-04-20 19:53:10.640 General/NewsTicker[1081] Creating a character..
2004-04-20 19:53:10.682 General/NewsTicker[1081] Creating a character..
<I cut a bunch of repeated lines here>
2004-04-20 19:53:10.985 General/NewsTicker[1081] Creating a character..
2004-04-20 19:53:11.001 General/NewsTicker[1081] Exception raised during posting of notification.  
Ignored.  exception: Can't cache image



    

- (void)updateGlyphDictionary
{
	_glyphDictionary = General/[[NSMutableDictionary alloc] init];
	General/NSString *glyphSet = 
                @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890.,:|\"'!";
	General/NSDictionary *attributes = General/[NSDictionary dictionaryWithObjectsAndKeys:_font, 
                General/NSFontAttributeName, _textColor, General/NSForegroundColorAttributeName, nil];
	int currentCharacter;


	for(currentCharacter = 0; currentCharacter < [glyphSet length]; currentCharacter++)
	{
		General/NSLog(@"Creating a character..");
		General/NSString *glyphString = [_string substringFromIndex:currentCharacter];
		
		General/NSImage *glyphImage = General/[[NSImage alloc] initWithSize:
                                       [glyphString sizeWithAttributes:attributes]];
		
		[glyphImage lockFocus];
		[glyphString drawAtPoint:General/NSMakePoint(0, 0) withAttributes:attributes];
		[glyphImage unlockFocus];
		[_glyphDictionary setObject:glyphImage 
                           forKey:General/[[NSNumber numberWithInt:currentCharacter] stringValue]];
	}
}



----

I think your call to method substringFromIndex will not take a single character but almost the whole string each time. You could also look into General/NSImage's caching abilities, maybe there's too much caching going on. I whipped up an example for you here. It works for me with point sizes up to 600pt without using too much CPU on my 667Mhz 512Mb powerbook (it's dependent on window size).

Does this one work any better?

    

- (void)drawRect:(General/NSRect)rect {
	General/NSRect rectBounds = [self bounds];      
	General/[[NSColor blackColor] set];
	General/NSRectFill(rectBounds);
	
	int currentCharacter = 0;
	General/NSPoint currentPoint = General/NSMakePoint(m_position,0);
	while(currentPoint.x < General/NSMaxX(rectBounds)) {
		General/NSImage* aGlyph = [self getImage:currentCharacter];
		General/NSSize glyphSize = [aGlyph size];
                if(currentPoint.x + glyphSize.width >= General/NSMinX(rectBounds)) {
		    [aGlyph compositeToPoint:currentPoint operation:General/NSCompositeCopy];
                }
		currentPoint.x += glyphSize.width;
		currentCharacter = (currentCharacter + 1) % 26;
	}
}

-(void)update {	
	// empty the current dictionary
	[m_glyphs removeAllObjects];
	
	// add new images to dictionary
	General/NSString* glyphSet = @"abcdefghijklmnopqrstuvwxyz";
	General/NSDictionary* attributes = General/[NSDictionary dictionaryWithObjectsAndKeys:
                General/[NSColor whiteColor], General/NSForegroundColorAttributeName, 
		[self font],General/NSFontAttributeName,
                nil];
	unsigned currentCharacter;
	for(currentCharacter = 0; currentCharacter < 26; currentCharacter++) {
		General/NSRange range = General/NSMakeRange(currentCharacter,1);
		General/NSString* glyphString = [glyphSet substringWithRange:range];		
		General/NSImage* glyphImage = General/[[NSImage alloc] initWithSize:
                         [glyphString sizeWithAttributes:attributes]];
		[glyphImage lockFocus];
		[glyphString drawAtPoint:General/NSMakePoint(0, 0) withAttributes:attributes];
		[glyphImage unlockFocus];
		[self addImage:glyphImage forGlyph:currentCharacter];
		[glyphImage release];
	}
}



----

It's working beautifully... but the CPU usage seems higher, right now it runs around 20% (on 1ghz g4) at a font size of 14 (scrolling across the General/PowerBook screen, 1280 pixels)...

I wonder if there is a way to get this down to around 1%?

I know using the previous method (2 large General/NSImages) it could be put down to 0%. Within the loop, most of the CPU is spent on :

    
[aGlyph compositeToPoint:currentPoint operation:General/NSCompositeCopy];



----

If you're using a font size of 14 points, use the first method (compose the text to scroll into an General/NSImage). But I was under the impression you wanted your text at 400 points?? And you don't have much memory?? I think it matters a lot which method you choose. To be honest, I'm suprised the compositeToPoint method uses so much CPU. Maybe it's not optimised for graphics processors. In which case, maybe you'd be better off using General/OpenGL, which should definately be GPU bound. Are you interested in this kind of solution? It would mean learning a whole new way of doing things....

----

I need to be able to do both large and small size, its user-configurable, that is the problem. This code does fix the memory issue, which is more important than CPU, because at least it works this way! I think I will leave it at this for now, but if you do have some General/OpenGL sample code please do post it, I may want to make it utilize General/OpenGL in the future, that definitely would free the CPU.

----

Now, you may encounter problems cutting the string up into characters and laying them out one at a time -- especially if this is as you say user configurable:


* Glyphs may not break cleanly at "unichar" values. There is no guarantee that a single 16-bit unichar is large enough to hold a unicode character. You can even imagine simple cases where a character is "composed" of two separate glyphs (say something like an A w/ an umlaut). If you rely on code that breaks strings up into characters for the purpose of compositing, you'll encounter problems where international text is garbled.
* And actually -- the implementation above only implements a subset of the ASCII range, which makes your program basically useless for non-English-speakers. So much for user configurability ...
* The rules for laying out text are complicated for many reasons: each language may have its own "rules" for text layout (text line direction, glyph orientation, etc.), some of the parameters may be user controlable, etc.


It's my understanding that the text rendering in Panther is very fast, and some say it will only get faster. With that in mind, you might consider instead using General/NSTextView to composite entire text blocks, instead of General/NSTextField or cutting things up into individual images. You could, for example, install an General/NSScrollView with an General/NSTextView in your window, configure the text view accordingly, and scroll simply by using General/NSScrollView API. Naturally you would turn off the scrollbars because you won't need them.

This approach has several huge advantages:


* It is international-text friendly -- at least as friendly as General/AppKit is.
* The General/NSLayoutManager and General/NSScrollView mechanisms are already optimized to draw only what it needs, when it is needed.
* Drawing will take advantage of Quartz Extreme (either now, or in the future, I'm not quite sure). So you can take advantage of the power of General/OpenGL without its awkward interface.
* The code should be light on memory and CPU resources since this text drawing is in the critical performance path to the entire Mac OS X operating system.


I haven't done this myself, at least not recently, so I don't have any sample code, but it should be very easy to implement and require a lot less effort on your part than driving individual character compositing yourself.

(I rearranged the code examples so people w/ screens smaller than 23" can read the text w/o scrolling all the time.)

-- General/MikeTrent

----

This is the approach I took originally, only I used an General/NSTextField inside an General/NSScrollView, but there were some limitations that made it unusable. I am not sure I can recall all of them as I have made total rewritings quite a few times (as you can see here), but... there was an issue with the General/NSScrollView only able to fit an General/NSTextField of a certain width until it would force it to wrap, the problem was either with General/NSTextField or General/NSScrollView, I cannot recall, but I could not find any way around it or to disable the text wrapping. 

When I tried to use larger sized images, it would have problems with allocating cache at larger font sizes and/or longer text strings. The system would lock up even, if the text was too large, trying to allocate memory. This is probably because the General/NSImages are uncompressed and very large.

As for international support, would rendering an General/NSString onto an General/NSImage make it lose its international attributes? I can do some testing... For width of character, as you can see in the code samples above, each character's width is calculated as per its 'sizeWithAttributes'. It is generally working fine for any font, the only font I saw a little distortion with was a very wide script font, the far right edge would sometimes be missing (decorative anyway) a pixel or two of width, but that is not a big deal at all, it looks fine and readable.

I wonder how safari goes about doing it for the <marquee/> tag... Oh and yes I thought about using a General/WebView with a marquee tag, but I think I want to keep this pure Cocoa, without any html/css/javascript.

----

You said you were using General/NSTextField, not General/NSTextView. Comments about view size restrictions are interesting, they seem to jog something in my memory ... 

*As for international support, would rendering an General/NSString onto an General/NSImage make it lose its international attributes?*

Depends. Are you trying to render individual characters and do the layout yourself or are you rendering the entire string in one pass? The former is much harder to do in an international-friendly way. Simply driving rendering one glyph at a time and preserving General/NSAttributedString attributes is not sufficient (those "attributes" are just font color, etc., and say nothing to which direction the text is rendered, if the glyphs are composed of multiple glyphs, etc.). From my understanding of the problem, you either need to start drivng the ATSUI API directly, or you need to use Cocoa API that hides that complexity for you (General/NSTextView, General/NSLayoutManager, etc...). The latter is much easier because you delegate all of that nastiness to the General/AppKit.

Personally, when I have done this in the past, I just used the General/NSTextField approach that you describe at the top of this article. It worked great for me. I didn't pay close attention to the performance, but 20% seems too high. It might be worth actually sampling the implementation and find out where that 20% is going. Perhaps its not really related to string drawing at all, or perhaps you're trying to update the window 1000 times a second ... 

-- General/MikeTrent

----

I'm a lurker to this discussion, but it interests me. I'm thinking that considering the advantage of using General/AppKit's internationalization ( and the severe disadvantages of *not* using it ) the best bet might be to create your text in an General/NSTextView or whatever, and then save it as a PDF. Let the General/AppKit display the PDF into your view -- and then you can *zoom* the PDF to whatever size you want, and let your view show a moving window into the huge PDF. 

This may sound backwards, but consider: you can open any PDF in Preview or the PDF browser plugin and zoom in until letters are 800 pixels tall, and you can still smoothly scroll about.

So, what I'm guessing, is that Apple has already solved this problem, in a non-obvious way. Let their code do the work for you, before you write a half-baked kludge. Believe me, I've written half-baked kludges too many times. It hurts when you realize that something else already does it, and better.

--General/ShamylZakariya

----

@General/MikeTrent:

I am not all that concerned about writing direction, but I think multi-glyphs such as "�" should be just fine, since after all; if you can render a whole string, you can render a part of a string, right?

Scrolling (via General/NSScrollView) an General/NSTextField does not use 20% (got it down to 0% actually), but it has a limitation on the amount of characters that can be scrolled across until it wraps the text. I would actually prefer it to be an General/NSTextField or General/NSTextView because it is a lot easier to work with for adding other functionality.

I believe I have tried both an General/NSTextField and an General/NSTextView, both seemed to behave exactly the same.

@General/ShamylZakariya:

Using a PDF would probably use a lot of RAM/CPU, no? Have you worked with generating a PDF? If so, would it be quick to dynamically change the font, resize, etc? This is definitely something to look into, I am going to try and read up on it.


Oh and I am ;-)

--General/MaksimRogov

----

*@General/MikeTrent:

I am not all that concerned about writing direction, but I think multi-glyphs such as "�" should be just fine, since after all; if you can render a whole string, you can render a part of a string, right?*

No, and believing so is an invalid induction proof: you are starting with N, assuming N-1, and trying to prove 1. Instead ask yourself "does [string characterAtIndex:x] always return a complete glyph?". Since the result is only a 16-bit integer value we might conclude the answer is no, and since F(1) isn't true, we can't build a correct induction proof (start with 1, assume N, prove N+1). Being C-programmers at heart we are used to the idea there is a 1:1 correspondence between a data type and a printable character; but in unicode that's just not true.

*Scrolling (via General/NSScrollView) an General/NSTextField does not use 20% (got it down to 0% actually), but it has a limitation on the amount of characters that can be scrolled across until it wraps the text.*

Hmmm ... I've never put a text field in a scroll view before, but I guess it should be equivalent to just using a text view. (The main differences being the field implementation is scattered between two other objects (General/NSTextField & General/NSTextFieldCell) and the 'Kit will create an General/NSTextView for you (the field editor) if for some reason you wanted to edit this text.) Regarding wrapping, if this is your only issue you're better off expending your energy addressing this issue rather than fishing around for "alternate" implementations, IMO.

-- General/MikeTrent

----

Use General/NSString (I think) methods to determine the width of the string, then adjust the width of the text field such that it won't wrap.

--

You probably mean General/NSAttributedString for the width and General/NSString for the length. -- General/MatPeterson

----

*Use General/NSString (I think) methods to determine the width of the string, then adjust the width of the text field such that it won't wrap.*

This is what I did, but it would still end up wrapping after a certain (rather large) size is reached... I am going to give this another try.

--General/MaksimRogov


----

What about going the opposite direction - large amounts of text (2-4k files) of moderate size? Would you guess that rendering to an image and sliding it around is the best bet? 

--General/JoshuaMarker

----

Right now I think it is best to use a fixed-size set of tiles, for example maybe twice the width of the scroll area in my case, being the screen, 1280 pixels times 2... because using tiles that are too small ends up wasting CPU drawing each tile across the scroll area, but having a tile too large causes memory problems. And I guess you would generate the next tile as needed. I have not yet tested this.

--General/MaksimRogov