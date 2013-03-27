

In Mac OS X 10.3 and later, use General/NSGradient. ~~ Alex Akers

----

How would I go about creating a gradient fill between a foreground and background color in a custom General/NSView?

----

Here is a very good example from the Omni Frameworks, annoted by Will Shipley:
http://wilshipley.com/blog/2005/07/pimp-my-code-part-3-gradient.html

----

I don't think there is any API for this in Cocoa, so you'll need to use General/CoreGraphics directly, here is an example of using the gradient fill support in an General/NSView subclass:
    
void Interpolate (void* info, float const* inData, float* outData)
{
   outData[0] = inData[0];
   outData[1] = sin(M_PI * inData[0]);
   outData[2] = 1.0;
   outData[3] = 1.0;
}

@implementation General/MyView

- (id)initWithFrame:(General/NSRect)frameRect
{
   [super initWithFrame:frameRect];
   return self;
}

- (void)drawRect:(General/NSRect)rect
{
   General/NSEraseRect(rect);

   struct General/CGFunctionCallbacks callbacks = { 0, Interpolate, NULL };

   General/CGFunctionRef function = General/CGFunctionCreate(
      NULL,       // void* info,
      1,          // size_t domainDimension,
      NULL,       // float const* domain,
      4,          // size_t rangeDimension,
      NULL,       // float const* range,
      &callbacks  // General/CGFunctionCallbacks const* callbacks
   );

   General/CGColorSpaceRef cspace = General/CGColorSpaceCreateDeviceRGB();

   General/NSRect bounds = [self bounds];
   float srcX = General/NSMinX(bounds), srcY = General/NSMinY(bounds);
   float dstX = General/NSMaxX(bounds), dstY = General/NSMaxY(bounds);
   General/CGShadingRef shading = General/CGShadingCreateAxial(
      cspace,                    // General/CGColorSpaceRef colorspace,
      General/CGPointMake(srcX, srcY),   // General/CGPoint start,
      General/CGPointMake(dstX, dstY),   // General/CGPoint end,
      function,                  // General/CGFunctionRef function,
      false,                     // bool extendStart,
      false                      // bool extendEnd
   );

   General/CGContextRef context = (General/CGContextRef)General/[[NSGraphicsContext currentContext] graphicsPort];
   General/CGContextDrawShading(
      context,
      shading
   );

   General/CGShadingRelease(shading);
   General/CGColorSpaceRelease(cspace);
   General/CGFunctionRelease(function);
}

@end


----

How would I use this with two specific colors though?

*The Interpolate-function receive a float in the range of [0..1] and should store the corresponding RGBA colour in the out array. So to go from red to yellow, use something like:*
    
void Interpolate (void* info, float const* inData, float *outData)
{
   static float red[4] = { 1.0f, 0.0f, 0.0f, 1.0f };
   static float yellow[4] = { 1.0f, 1.0f, 0.0f, 1.0f };

   float a = inData[0];
   for(int i = 0; i < 4; i++)
      outData[i] = (1.0f-a)*red[i] + a*yellow[i];
}

----

Here is a category on General/NSBezierPath to do a linear gradient fill of an area using two specified colors.

    


//### globals
General/CGColorSpaceRef colorspace = nil;

float	start_red,
		start_green,
		start_blue,
		start_alpha;
float	end_red,
		end_green,
		end_blue,
		end_alpha;
float	d_red,
		d_green,
		d_blue,
		d_alpha;

@implementation General/NSBezierPath(General/MRGradientFill) 

static void
evaluate(void *info, const float *in, float *out)
{
	// red
	*out++ = start_red + *in * d_red;

	// green
	*out++ = start_green + *in * d_green;

	// blue
	*out++ = start_blue + *in * d_blue;

	//alpha
    *out++ = start_alpha + *in * d_alpha;
}


-(void)linearGradientFill:(General/NSRect)thisRect 
	startColor:(General/NSColor *)startColor 
	endColor:(General/NSColor *)endColor
{
	General/CGShadingRef shading;
	static General/CGPoint startPoint = { 0, 0 };
	static General/CGPoint endPoint = { 0, 0 };
	int k;
	General/CGFunctionRef function;
	General/CGFunctionRef (*getFunction)(General/CGColorSpaceRef);
	General/CGShadingRef (*getShading)(General/CGColorSpaceRef, General/CGFunctionRef);

	// get my context
	General/CGContextRef currentContext = 
		(General/CGContextRef)General/[[NSGraphicsContext currentContext] graphicsPort];

	
	General/NSColor *s = [startColor colorUsingColorSpaceName:General/NSDeviceRGBColorSpace];
	General/NSColor *e = [endColor colorUsingColorSpaceName:General/NSDeviceRGBColorSpace];

	// set up colors for gradient
	start_red		= [s redComponent];
	start_green		= [s greenComponent];
	start_blue		= [s blueComponent];
	start_alpha		= [s alphaComponent];

	end_red			= [e redComponent];
	end_green		= [e greenComponent];
	end_blue		= [e blueComponent];
	end_alpha		= [e alphaComponent];

	d_red		= absDiff(end_red, start_red);
	d_green		= absDiff(end_green, start_green);
	d_blue		= absDiff(end_blue, start_blue);
	d_alpha		= absDiff(end_alpha ,start_alpha);
			

	// draw gradient
	colorspace = General/CGColorSpaceCreateDeviceRGB();

    size_t components;
    static const float domain[2] = { 0.0, 1.0 };
    static const float range[10] = { 0, 1, 0, 1, 0, 1, 0, 1, 0, 1 };
    static const General/CGFunctionCallbacks callbacks = { 0, &evaluate, NULL };

    components = 1 + General/CGColorSpaceGetNumberOfComponents(colorspace);
    function =  General/CGFunctionCreate((void *)components, 1, domain, components,
                            range, &callbacks);

	// function = getFunction(colorspace);	
	startPoint.x=0;
	startPoint.y=thisRect.origin.y;
	endPoint.x=0;
	endPoint.y=General/NSMaxY(thisRect);
	
	
	shading = General/CGShadingCreateAxial(colorspace, 
		startPoint, endPoint,
        function, 
		NO, NO);
	
	General/CGContextDrawShading(currentContext, shading);

};

@end



You can use it like this:

    
- (void)drawRect:(General/NSRect)rect 
{
	
	// get inset rect
	General/NSRect thisRect = General/NSInsetRect(rect, 15.5, 15.5);
	
	// get bezier path and draw rounded rect
	General/NSBezierPath *rr = General/[NSBezierPath bezierPath];	
	[rr appendRoundedRect:thisRect cornerRadius:8.0];
	
	[rr addClip];
	[rr linearGradientFill:thisRect 
				startColor:General/[NSColor whiteColor] 
				  endColor:General/[NSColor selectedControlColor]];
	
	General/[[NSColor blackColor] set];
	
	[rr stroke];
	
}


The code above doesn't free resources lit it should, so be careful about copy-and-paste. You might want to add something like this somewhere:

    
	General/CGFunctionRelease(function);
	General/CGShadingRelease(shading);
	General/CGColorSpaceRelease(colorspace);


-Michael Rothwell (michael@rothwell.us)


----

I'm getting a General/ZeroLink 'unknown symbol' error relating to where() (and if I comment that out, absDiff()) ... I assume I need to be including a library or several somewhere ... Which ones? Jul 09 '05

**Update** - I feel like a moron. ;-) absDiff() isn't some standard function in some library somewhere; it's a relatively simple function like so:

    
float absDiff(float a, float b) 
{ 
	return (a < b) ? b-a : a-b; 
} 


(sigh) As to     where() - I have no idea what it is. Removing it (and adding the absDiff() function) made it run, but it's still not really drawing anything. It compiled just fine, though. :-/ So ... at least on Tiger, this example doesn't seem to work.

**Another Update**: There's definitely something wrong. Here's what I've done so far. 1- I've removed the "where();" statement (I have no idea what this represents but that may be the problem). 2- Added the absDiff function above (also the only other difference). The problem is, I get a solid white rectangle surrounded by the stroked path. After some experimentation, I find that changing     startColor (but not     endColor) has mixed results. Some colors (such as redColor and greenColor) create the original color fading upwards into a different *hue* (corrected from 'shade') of the color. Other     endColors make the rectangle remain a solid fill of     startColor. I'm thinking that the alpha and / or the other color components on     endColor might be zeroed out (but I'm having trouble visualizing what this would mean graphically). 

So I guess the question is, what's wrong with     endColor?

**Solution:** Well for one thing I realized that the absDiff function should be handling floats to be more precise (to match the floats used in graphics functions). But the main problem appears to be things that are solid white or solid black. Using the following colors to get a pretty grey-white matte gradient:

    
	General/NSColor * sColor = General/[NSColor colorWithCalibratedWhite:0.7 alpha:1.0];
	General/NSColor * eColor = General/[NSColor colorWithCalibratedWhite:0.3 alpha:1.0]; 


What a night ...

----

Since the code throughout this page is referencing General/NSRects, will it work with additions like General/NSBezierPathCategory or General/RoundedRectangles?

*No, but you could make it work by sending the rounded path addClip before using the gradient. Just make sure to save and restore the graphics context beforehand. --General/AndyMatuschak*

----

I've been playing with some code tonight to do a linear gradient fill in a bezier path using General/CoreImage. It's not fully functional, but whatever, it kinda works (sorry, it's just late and I don't feel like playing with this code anymore). If anyone feels the need, please fix it up, it seems pretty fast. A few problems: if I apply an General/NSShadow before calling this fill method, it doesn't really get applied (it does, but because of the clipping, it just doesn't work as it should, not sure if there is a way around this).

Anyway, just post changes you make, this code seems somewhat simpler (and perhaps faster?) than the code above, and I think it could be made smarter to do caching (perhaps that's overkill)...

    

@interface General/NSBezierPath (Additions)
- (void)fillGradientFrom:(General/NSColor*)inStartColor to:(General/NSColor*)inEndColor angle:(float)inAngle;
@end

@implementation General/NSBezierPath (Additions)

- (void)fillGradientFrom:(General/NSColor*)inStartColor to:(General/NSColor*)inEndColor angle:(float)inAngle
{
	General/CIImage*	coreimage;
	
	inStartColor = [inStartColor colorUsingColorSpaceName:General/NSCalibratedRGBColorSpace];
	inEndColor = [inEndColor colorUsingColorSpaceName:General/NSCalibratedRGBColorSpace];
		
	General/CIColor* startColor = General/[CIColor colorWithRed:[inStartColor redComponent] green:[inStartColor greenComponent] blue:[inStartColor blueComponent] alpha:[inStartColor alphaComponent]];
	General/CIColor* endColor = General/[CIColor colorWithRed:[inEndColor redComponent] green:[inEndColor greenComponent] blue:[inEndColor blueComponent] alpha:[inEndColor alphaComponent]];
	
	General/CIFilter* filter;
	
	filter = General/[CIFilter filterWithName:@"General/CILinearGradient"];
	[filter setValue:startColor forKey:@"inputColor0"];
	[filter setValue:endColor forKey:@"inputColor1"];
	
	General/CIVector* startVector;
	General/CIVector* endVector;
	
	startVector = General/[CIVector vectorWithX:0.0 Y:0.0];
	endVector = General/[CIVector vectorWithX:0.0 Y:[self bounds].size.height];
	
	[filter setValue:startVector forKey:@"inputPoint0"];
	[filter setValue:endVector forKey:@"inputPoint1"];
	
	coreimage = [filter valueForKey:@"outputImage"];
	
	General/[[NSGraphicsContext currentContext] saveGraphicsState];
	
	General/CIContext* context;
	
	context = General/[[NSGraphicsContext currentContext] General/CIContext];
	
	[self setClip];
	
	[context drawImage:coreimage atPoint:General/CGPointZero fromRect:General/CGRectMake( 0.0, 0.0, [self bounds].size.width + 100.0, [self bounds].size.height + 100.0 )];
	
	General/[[NSGraphicsContext currentContext] restoreGraphicsState];
}

@end



----
I've created a small class that does *most* of what's done here. License is CC so feel free to use it.

http://blog.oofn.net/2006/01/15/gradients-in-cocoa/

----

see General/OAGradientTableView

You should also check out:

http://www.harmless.de/cocoa.html

Andreas Mayer's General/AMRollOverButton includes General/NSBezierCategories that do lovely gradient fills with rounded rectangles and everything. Very nice.

----

In 10.5 see General/NSGradient.