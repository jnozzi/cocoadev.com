21 June 2004 - *Moved from General/ImplementSyntaxHighlighting*

----

I spent twenty minutes this morning trying to figure out General/NSLayoutManager and temporary attributes like was discussed eariler, and this is what I came up with: http://goo.gl/General/OeSCu

    
- (void)textStorageDidProcessEditing:(General/NSNotification *)notification
{
	General/NSTextStorage *textStorage = [notification object];
	General/NSRange found, area;
	General/NSString *string = [textStorage string];
	General/NSMutableDictionary *attr = General/[[NSMutableDictionary alloc] init];
	General/NSLayoutManager *lm = General/textStorage layoutManagers] objectAtIndex: 0];
	unsigned int length = [string length];
		
	[attr setObject: [[[NSColor blueColor]
			 forKey: General/NSForegroundColorAttributeName];
	
	area.location = 0;
	area.length = length;
	
	while (area.length)
	{
		found = [string rangeOfString: @"Jon"
					          options: General/NSCaseInsensitiveSearch
						     range: area];
		
		if (found.location == General/NSNotFound) break;
		[lm addTemporaryAttributes: attr forCharacterRange: found];
		
		area.location = General/NSMaxRange(found);
		area.length = length - area.location;
	}
	
	[attr release];
}


It seems to me like for this really simple example, it is alot more code, but there also seems to be absolutely no speed issues at all. 

-- Jon Raphaelson

----

It's worth noting that using General/NSLayoutManager's temporary attributes will only be useful if your syntax highlighter just supports colors or underlining.  A syntax highlighter I wrote supports arbitrary attributes, e.g. different fonts, so I had to use normal attributes.  This could also explain why Xcode uses normal attributes instead of temporary ones.

-- Prachi Gauriar

----

After about a week of wrestling, I've pretty much come to the conclusion that temporary attributes aren't useful for highlighting syntax at all, despite what the docs say. If you try the code above, you'll see that it doesn't color the last edited range, until a whitespace character is entered. This is acceptible for spell-checking (which is what General/AppKit uses them for), but not if you want language keywords to be colored as they're typed. I've looked and looked for any syntax highlighting example code that uses temporary attributes, but haven't found anything other than a few short 1-2 line snippets here and there, which all exhibited this behaviour. All of the real, working code I've looked at (from e.g. General/TeXShop or General/IDEKit) has used regular attributes. Now I know why! If anyone has gotten a temporary attribute-based syntax highlighter to work 'the right way', I'd love to hear about it.

----

Smultron, an open source (GPL) Cocoa based editor uses temporary attributes for syntax coloring. Also, I am currently rewriting the General/TeXShop syntax highlighting code (it is rather slow currently, if your document is a couple 100kb big, it slows down to a crawl). To me it seems temporary attributes are the only way to make syntax coloring with decent spent once you reach a certain file size. One of the problems is that a color change will cause the Cocoa text system to re-layout the affected text (even though that is not necessary for a simple color change). This can be avoided using a custom General/NSTextStorage subclass, but even then, I haven't been able to come up with code that allows decently fast editing of a 800kb file while using regular attributes.

-- Max Horn

----

When editing text at the end of the buffer, the temporary attribute code generates

Exception raised during posting of notification.  Ignored.  exception: *** -General/[NSBigMutableString characterAtIndex:]: Range or index out of bounds

when running on 10.4.4. Anyone have a fix?

*Are you sure it's not absolutely correct and simply didn't throw an error before? Kind of strange but entirely possible.*

----

I have the same error here in 10.4.5, and I am sure it is in the following line of code:
    
    [layoutManager setTemporaryAttributes:beginEndDict forCharacterRange:tokenRange];


"tokenRange" is valid; I catch the exception, and output the values in question:
    
@try {
    [layoutManager setTemporaryAttributes:beginEndDict forCharacterRange:tokenRange];
} @catch (id exception) {
    fprintf(stderr, "exception reason: %s\n", General/([[NSException *)exception reason] UTF8String]);
    fprintf(stderr, "tokenRange: %d, %d, type: %d\n", tokenRange.location, tokenRange.length, type);
    fprintf(stderr, "General/[layoutManager textStorage] string] length]: %d\n", [[[layoutManager textStorage] string] length]);
    exit(1);
}


I receive this output in the Run Log:
    
2006-03-30 18:08:11.496 myApp[15749] -[[[NSBigMutableString characterAtIndex:] called with out-of-bounds index. For apps linked on Tiger this will raise an exception. For earlier apps it will produce this one-time warning and continue with existing behavior (which is undefined).
exception reason: *** -General/[NSBigMutableString characterAtIndex:]: Range or index out of bounds
tokenRange: 19492, 4, type: 262
General/[layoutManager textStorage] string] length]: 19507


The tokenRange is set to a location of 19492, with a length of 4, and the length of the string is 19507. This error happens reproducibly. It does not happen with normal attributes.

Edit: I should give a little bit of context. This occurs when processing the changes from one of these:
    
- (void)textStorageDidProcessEditing:([[NSNotification *)notification

Notably, the changeInLength is -1 (I deleted a character). Nevermind why, but I am then scanning the document, and setting some temporary attributes.

-- Duncan Smith

----
The problem is that you can't remove temporary attributes in the notification.  Use performSelector:withObject:afterDelay:0

----
I still get the same errors using performSelector to release the attribute. Autoreleasing doesn't help either.