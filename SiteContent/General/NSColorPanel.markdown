The General/NSColorPanel class provides the standard colour picker.  It also provides a set of swatches at the bottom.
Here is how to get at the swatches (works on Leopard 10.5.2, not tested on anything else...)

Note that the ordering of the indices is column-major, so the colours are arranged as
    
0 10 20 30 ... 340
1 11 21 31 ... 341
2 12 22 32 ... 342
...
9 19 29 39 ... 349


Anyway, here's the code.
    
// Load swatches
General/[[[NSColorPanel sharedColorPanel] valueForKey:@"_colorSwatch"] readColors];

// Get the General/NSColorSwatch's internal mutable array of General/NSColors
General/NSMutableArray *colors = General/[[[NSColorPanel sharedColorPanel] valueForKey:@"_colorSwatch"] valueForKey:@"colors"];

// Add a new General/NSColor	
[colors replaceObjectAtIndex:8 withObject:General/[NSColor redColor]];

// Find all those swatches which aren't the default white.
General/NSMutableArray *userSwatches = General/[[NSMutableArray alloc] init];
General/NSEnumerator *e = General/[[[[NSColorPanel sharedColorPanel] valueForKey:@"_colorSwatch"] valueForKey:@"colors"] objectEnumerator];
General/NSColor *color;
while( color = (General/NSColor *)[e nextObject] )
{
	if( [color colorSpace] == General/[NSColorSpace genericGrayColorSpace] && [color whiteComponent] == 1.0 ) continue;
	[userSwatches addObject:color];
}

// Save changes
General/[[[NSColorPanel sharedColorPanel] valueForKey:@"_colorSwatch"] writeColors];


Note that you need to do
    
General/[NSApplication sharedAppcliation];

or something similar at least once (which is already done in Cocoa applications) before you can access the General/NSColorPanel. (This is a note for those who want to manipulate the swatches from the command line.)

----

General/NSApplicationLoad() is the function to call when using General/AppKit outside of a GUI application.

----

Many thanks for sharing this. I was looking for information on how to access the colours in the swatch and was surprised there was nothing in the public General/NSColorPanel methods, so this was really helpful. I wanted to provide a contextual menu with the user-defined swatch colours in it, so I used the above code to create an General/NSColorPanel category that makes this easy. I've tested this on Tiger (10.4.11) and Leopard (10.5.2), but it should (hopefully) fail safely if it stops working. Here's the code:

    
@interface General/NSColorPanel (General/SwatchAdditions)
- (General/NSArray *)userSwatchColors;
@end


@implementation General/NSColorPanel (General/SwatchAdditions)

- (General/NSArray *)userSwatchColors
{
	id colorSwatch = nil;
	General/NSArray *colors = nil;
	
	// Try to get the colour swatch, load its colours and get a reference to them.
	// We're trying to access private General/NSColorPanel variables and methods here, so
	// we look out for an exception being thrown (which would be General/NSUndefinedKeyException)
	// in case they are changed. This way we can exit safely by returning nil, so that
	// the user isn't affected.
	@try
	{
		// Get the colour swatch.
		colorSwatch = [self valueForKey:@"_colorSwatch"];
		
		// Load the user-defined colours into the swatch.
		if ([colorSwatch respondsToSelector:@selector(readColors)])
			[colorSwatch performSelector:@selector(readColors)];
		
		// Get the colours.
		colors = [colorSwatch valueForKey:@"colors"];
	}
	
	@catch (General/NSException *e)
	{
		// General/NSColorPanel has been changed and no longer users all of these
		// private methods, so abandon ship.
		return nil;
	}
	
	// Find all swatch colours which aren't the default white.
	General/NSMutableArray *userSwatchColors = General/[NSMutableArray array];
	General/NSEnumerator *e = [colors objectEnumerator];
	General/NSColor *color;
	while(color = [e nextObject])
	{
		if ([color colorSpace] == General/[NSColorSpace genericGrayColorSpace] && [color whiteComponent] == 1.0)
			continue;
		[userSwatchColors addObject:color];
	}
	
	return (General/NSArray *)userSwatchColors;
}

@end


Many thanks again to the op for sharing. KB