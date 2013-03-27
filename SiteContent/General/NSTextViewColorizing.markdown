

I've subclassed General/NSTextView to make commented lines green, I use this code

    
- (void) didChangeText
{
	General/NSLayoutManager *layoutManager = [self layoutManager];
	General/NSRange lineGlyphRange, lineCharRange;
	General/NSString *prefix;
	General/NSColor *color;
	General/NSRange range = [self rangeForUserTextChange];
	
	(void)[layoutManager lineFragmentRectForGlyphAtIndex:range.location
                            effectiveRange:&lineGlyphRange];  
	lineCharRange = [layoutManager characterRangeForGlyphRange:lineGlyphRange
                           actualGlyphRange:NULL];
	
	prefix = General/[self string] substringWithRange:lineCharRange]
                  tringByTrimmingCharactersInSet:[[[NSCharacterSet whitespaceCharacterSet]];
	if([prefix hasPrefix:@"#"])
		color = General/[NSColor colorWithCalibratedRed:(float)42/255
                           green:(float)126/255 blue:(float)49/255 alpha:1.0f];
	else
		color = General/[NSColor blackColor];
		
  [layoutManager addTemporaryAttributes:
    General/[NSDictionary dictionaryWithObjectsAndKeys:color, General/NSForegroundColorAttributeName, nil]
              forCharacterRange:lineCharRange];
}


the problem lies in *(void)[layoutManager lineFragmentRectForGlyphAtIndex:range.location effectiveRange:&lineGlyphRange];*

ex: when i type *#colorize*

it shows up like this *##c#co#col#colo#color#colori#coloriz#colorize*

see the problem?

tnx

----

Iv'e solved it
when *(void)[layoutManager lineFragmentRectForGlyphAtIndex:range.location effectiveRange:&lineGlyphRange]; * is called it *performs glyph generation and layout if needed.*

so i used
    
General/NSRange range = [self rangeForUserTextChange];
lineCharRange = [[self string]lineRangeForRange:range];
