I need to take a picture of the screen and load it into an General/NSImage or some derivation of that. Right now I am using General/NSTask and the "screencapture" command line utility. Is there another way because this way sucks. Thanks. http://goo.gl/Cx9sQ

----

This works fairly well for me and takes a surprisingly little amount of code - and best of all, it's 100% Cocoa. The downside is that it's slow if you are trying to capture the entire screen.

    
+ (General/NSImage *)captureImageForRect:(General/NSRect)rect
{
    General/NSWindow *window;
    General/NSBitmapImageRep *rep;
    General/NSImage *image;
	
    window = General/[[NSWindow alloc] initWithContentRect:rect styleMask:General/NSBorderlessWindowMask
					backing:General/NSBackingStoreNonretained defer:NO];
    [window setBackgroundColor:General/[NSColor clearColor]];
    [window setLevel:General/NSScreenSaverWindowLevel + 1];
    [window setHasShadow:NO];
    [window setAlphaValue:0.0];
    [window orderFront:self];
    [window setContentView:General/[[[NSView alloc] initWithFrame:rect] autorelease]];
    General/window contentView] lockFocus];
    rep = [[[[NSBitmapImageRep alloc] initWithFocusedViewRect:General/window contentView] bounds;
    General/window contentView] unlockFocus];
    [window orderOut:self];
    [window close];
    
    image = [[[[[NSImage alloc] initWithSize:[rep size]] autorelease];
    [image addRepresentation:rep];
    
    return image;
}


You might need to use some Carbon if you want to get the best results. I believe Apple had some sample code on how to do this, but I can't find it at the moment.

-- General/RyanBates

----

Thank you Ryan. I tried your code and it is very cool but a little too slow for my needs (the whole screen). But that is a very helpful snippet. With your permission I would like to post it to http://osnippets.org/.
I ended up just using General/NSTask and screencapture. I made sure that the task was finished before proceeding with my screensaver. I wanted to basically freeze the screen by displaying a screenshot of the computer right before the screensaver activated but I kept getting part of the fade in the screenshot. Now it just takes a second to activate. As soon as I post it for download I will post a link in here or something.
Hm, I just noticed that link you (or someone else) gave me. I am at school on a General/PeeCee so I can't try it, but I will try it when I get home. Thanks! -Zac

----

Credit for the code given above goes to Ben Haller from Stick Software. So, it would be most appropriate to ask him for permission to post it on osnippets.org. See his post at: http://cocoa.mamasam.com/MACOSXDEV/2002/02/1/24720.php

-- General/RyanBates

----

Man, the code in the above link in the original post is great. It is lightning fast for the entire screen. I haven't put it into my program yet, but I will later. I still can't get over how fast it is. Less than a second for the entire screen!! -Zac

----

Apple's sample code has been deprecated. Exactly why it was deprecated is unclear, but it's now in their archive section at http://developer.apple.com/samplecode/Sample_Code/Archive/Graphics/glGrab.htm. "This sample shows how to use General/OpenGL to grab the contents of the screen via a DMA transfer
to reduce the load on the CPU."

----

glGrab is by far the fastest grabbing routine I've come across. With a bit of hacking around I've managed to take a 1024*768 screendump and map it onto a gl quad in 0.11 seconds (with the addition of Apple's GL extensions ofcourse). -ascii

----

*There's also the Snapshot ( http://developer.apple.com/samplecode/Sample_Code/Archive/Graphics/Snapshot.htm ) and Super Snapshot ( http://developer.apple.com/samplecode/Sample_Code/Archive/Graphics/General/SuperSnapshot.htm ) archived examples.*

----

Does anybody have a saved copy of the General/GLGrab example?

----

I've been fiddling with various carbon screen shot examples trying to find an alternative to the method posted above. I finally came up with this method:

    
+ (General/NSImage *)imageWithScreenShotInRect:(General/NSRect)cocoaRect
{
	General/PicHandle picHandle;
	General/GDHandle mainDevice;
	Rect rect;
	General/NSImage *image;
	General/NSImageRep *imageRep;
	
	// Convert General/NSRect to Rect
	General/SetRect(&rect, General/NSMinX(cocoaRect), General/NSMinY(cocoaRect), General/NSMaxX(cocoaRect), General/NSMaxY(cocoaRect));
	
	// Get the main screen. I may want to add support for multiple screens later
	mainDevice = General/GetMainDevice();
	
	// Capture the screen into the General/PicHandle.
	picHandle = General/OpenPicture(&rect);
	General/CopyBits((General/BitMap *)*(**mainDevice).gdPMap, (General/BitMap *)*(**mainDevice).gdPMap,
				&rect, &rect, srcCopy, 0l);
	General/ClosePicture();
	
	// Convert the General/PicHandle into an General/NSImage
	// First lock the General/PicHandle so it doesn't move in memory while we copy
	General/HLock((Handle)picHandle);
	imageRep = General/[NSPICTImageRep imageRepWithData:General/[NSData dataWithBytes:(*picHandle)
					length:General/GetHandleSize((Handle)picHandle)]];
	General/HUnlock((Handle)picHandle);
	
	// We can release the General/PicHandle now that we're done with it
	General/KillPicture(picHandle);
	
	// Create an image with the representation
	image = General/[[[NSImage alloc] initWithSize:[imageRep size]] autorelease];
	[image addRepresentation:imageRep];
	
	return image;
}


This basically does the same thing as the above code, but it uses General/QuickDraw functions to capture the screen which are much faster. However, because it's General/QuickDraw, **the point of origin (0,0) is at the top left of the screen instead of the bottom left.** I didn't have to add the Carbon framework to my target, but you may need to if you get compilation errors. -- General/RyanBates

*How fast? I would like to make a program that can capture "screen movies" (like General/SnapzPro -- the reviews on that page are not really accurate) at 10 fps or better...but I can't find a way to take frames that fast. The only alternative seems to be moving the mouse reeeeaaaaallllllyyyy ssssllllloooowwwllllllyyyyyy --General/JediKnil*

It depends on the resolution and the speed of the computer. Testing it on a 733 Mhz G4 (yes, I know it's old), it takes about 0.3 seconds to capture at 1024 x 768. That glGrab example was probably faster, if only someone had a copy of it. I remember trying it out a while ago, but can't find it anywhere now. -- General/RyanBates

*No time to check right now, but is **this** glGrab? --General/JediKnil*

http://developer.apple.com/samplecode/Carbon_GLSnapshot/Carbon_GLSnapshot.html

No, it appears that just captures an General/OpenGL view and not the screen. -- General/RyanBates

----

I dug around the web a while ago and found the glGrab in some obscure ftp repository.
I copy below the essential part of the glGrab routine.
I hope this helps everyone ! at least glGrab is very fast, but not as fast as General/SnapzPro...
I'm not sure why Apple engineer decided to remove this from their sample code list.
It may be in conflict with Quartz (2D) extreme, but this is only my naive guess.
One sure thing is that this won't run properly on Intel Macs, due to endian issues :-)

    
/*
 *  glGrabController.m

 *
 *  Created by MP on July 7 2003.
 *  Copyright (c) 2003 Apple Computer Inc. All rights reserved.

 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Computer, Inc.
 ("Apple") in consideration of your agreement to the following terms, and your
 use, installation, modification or redistribution of this Apple software
 constitutes acceptance of these terms.  If you do not agree with these terms,
 please do not use, install, modify or redistribute this Apple software.

 In consideration of your agreement to abide by the following terms, and subject
 to these terms, Apple grants you a personal, non-exclusive license, under Apple's
 copyrights in this original Apple software (the "Apple Software"), to use,
 reproduce, modify and redistribute the Apple Software, with or without
 modifications, in source and/or binary forms; provided that if you redistribute
 the Apple Software in its entirety and without modifications, you must retain
 this notice and the following text and disclaimers in all such redistributions of
 the Apple Software.  Neither the name, trademarks, service marks or logos of
 Apple Computer, Inc. may be used to endorse or promote products derived from the
 Apple Software without specific prior written permission from Apple.  Except as
 expressly stated in this notice, no other rights or licenses, express or implied,
 are granted by Apple herein, including but not limited to any patent rights that
 may be infringed by your derivative works or by other works in which the Apple
 Software may be incorporated.

 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
 WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
 WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
 COMBINATION WITH YOUR PRODUCTS.

 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
                        GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR DISTRIBUTION
 OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF CONTRACT, TORT
 (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF APPLE HAS BEEN
 ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 *
 */


#import "glGrabController.h"
#import <General/ApplicationServices/General/ApplicationServices.h>
#import <stdint.h>

@implementation glGrabController

- (id)init
{
    General/CGLPixelFormatObj pixelFormatObj ;
    long numPixelFormats ;
    General/CGOpenGLDisplayMask displayMask =
        General/CGDisplayIDToOpenGLDisplayMask( General/CGMainDisplayID() ) ;
    General/CGLPixelFormatAttribute attribs[] =
    {
        kCGLPFAFullScreen,
        kCGLPFADisplayMask,
        displayMask,
        NULL
    } ;
    [super init];
    
    /* Build a full-screen GL context */

    General/CGLChoosePixelFormat( attribs, &pixelFormatObj, &numPixelFormats );
    General/CGLCreateContext( pixelFormatObj, NULL, &glContextObj ) ;

    General/CGLDestroyPixelFormat( pixelFormatObj ) ;

    General/CGLSetCurrentContext( glContextObj ) ;
    General/CGLSetFullScreen( glContextObj ) ;

    return self;
}

- (void)dealloc
{
    if ( saveFile )
        [saveFile release];
    if ( bitmap )
        [bitmap release];

    General/CGLSetCurrentContext( NULL ) ;
    General/CGLClearDrawable( glContextObj ) ;
    General/CGLDestroyContext( glContextObj ) ;

    [super dealloc];
}

static inline void swapcopy32(void * src, void * dst, int bytecount )
{
    uint32_t *srcP;
    uint32_t *dstP;
    uint32_t p0, p1, p2, p3;
    uint32_t u0, u1, u2, u3;
    
    srcP = src;
    dstP = dst;
#define SWAB_PIXEL(p) (((p) << 8) | ((p) >> 24)) /* ppc rlwinm opcode results */
    while ( bytecount >= 16 )
    {
        /*
         * Blatent hint to compiler that we want
         * strength reduction, pipelined fetches, and
         * some instruction scheduling, please.
         */
        p3 = srcP[3];
        p2 = srcP[2];
        p1 = srcP[1];
        p0 = srcP[0];
        
        u3 = SWAB_PIXEL(p3);
        u2 = SWAB_PIXEL(p2);
        u1 = SWAB_PIXEL(p1);
        u0 = SWAB_PIXEL(p0);
        srcP += 4;

        dstP[3] = u3;
        dstP[2] = u2;
        dstP[1] = u1;
        dstP[0] = u0;
        bytecount -= 16;
        dstP += 4;
    }
    while ( bytecount >= 4 )
    {
        p0 = *srcP++;
        bytecount -= 4;
        *dstP++ = SWAB_PIXEL(p0);
    }
}

static void swizzleBitmap(General/NSBitmapImageRep * bitmap)
{
    int top, bottom;
    void * buffer;
    void * topP;
    void * bottomP;
    void * base;
    int rowBytes;

    rowBytes = [bitmap bytesPerRow];
    top = 0;
    bottom = [bitmap pixelsHigh] - 1;
    base = [bitmap bitmapData];
    buffer = malloc(rowBytes);
    
    while ( top < bottom )
    {
        topP = (top * rowBytes) + base;
        bottomP = (bottom * rowBytes) + base;
        
        /* Save and swap scanlines */
        swapcopy32( topP, buffer, rowBytes );
        swapcopy32( bottomP, topP, rowBytes );
        bcopy( buffer, bottomP, rowBytes );
        
        ++top;
        --bottom;
    }
    free( buffer );
}

- (General/IBAction)grab:(id)sender
{
    General/GLint		viewport[4];		/* Current viewport */
    long		bytewidth;
    General/GLint		width, height;
    long		bytes;

    /* Get General/OpenGL aimed at FB */
    General/CGLSetCurrentContext( glContextObj ) ;
    glReadBuffer(GL_FRONT);
    glGetIntegerv(GL_VIEWPORT, viewport);
    
    width = viewport[2];
    height = viewport[3];
        
    bytewidth = width * 4;	// Assume 4 bytes/pixel for now
    bytewidth = (bytewidth + 3) & ~3;	// Align to 4 bytes
    bytes = bytewidth * height;	// width * height
    
    /* Build General/NSBitmapImageRep */
    if ( bitmap )
        [bitmap release];
    bitmap = General/[[NSBitmapImageRep alloc] initWithBitmapDataPlanes:NULL
                pixelsWide:width
                pixelsHigh:height
                bitsPerSample:8
                samplesPerPixel:3
                hasAlpha:NO
                isPlanar:NO
                colorSpaceName:General/NSDeviceRGBColorSpace
                bytesPerRow:bytewidth
                bitsPerPixel:8 * 4];
                
    /* Read FB into General/NSBitmapImageRep */
    glFinish();				/* Finish all General/OpenGL commands */
    glPixelStorei(GL_PACK_ALIGNMENT, 4);	/* Force 4-byte alignment */
    glPixelStorei(GL_PACK_ROW_LENGTH, 0);
    glPixelStorei(GL_PACK_SKIP_ROWS, 0);
    glPixelStorei(GL_PACK_SKIP_PIXELS, 0);

    /*
     * By matching the framebuffer format, we can get the
     * data transferred to our buffer using DMA.
     */
    glReadPixels(0, 0, width, height,
                GL_BGRA,
                GL_UNSIGNED_INT_8_8_8_8_REV,
               [bitmap bitmapData]);
    /*
     * glReadPixels generates a quadrant I raster, with origin in the lower left
     * This isn't a problem for signal processing routines such as compressors,
     * as they can simply use a negative 'adavnce' to move between scanlines.
     * General/NSBitmapImageRep assumes a quadrant III raster, though, so we need to
     * invert it.  Pixel swizzling can also be done here.
     */
    swizzleBitmap(bitmap);
}

- (void)saveToFile:(General/NSString *)file
{
    if ( bitmap == NULL )
        return;
    if ( saveFile )
        [saveFile release];
    saveFile = file;
    [saveFile retain];
    
    [self save:self];
}


- (General/IBAction)save:(id)sender
{
    General/NSData * tiff;
    
    if ( bitmap == NULL )
        return;
    if ( saveFile == NULL )
    {
        [self saveAs:sender];
        return;
    }
    tiff = [bitmap General/TIFFRepresentation];
    [tiff writeToFile:saveFile atomically:YES];
}

- (General/IBAction)saveAs:(id)sender
{
    General/NSSavePanel * savePanel = General/[NSSavePanel savePanel];
    General/NSData * tiff;
    
    [savePanel setRequiredFileType: @"tiff"];
    [savePanel runModal];
    if ( saveFile )
        [saveFile release];
    saveFile = [savePanel filename];
    if ( saveFile == NULL )
        return;
    [saveFile retain];

    tiff = [bitmap General/TIFFRepresentation];
    [tiff writeToFile:saveFile atomically:YES];
}

@end



If you like, I can post the entire sample code package on my web site. (The license at the top of the file explicitly says we can redistribute at will.) E-mail me at mike@mikeash.com if you're interested. -- General/MikeAsh

----
I replaced '(General/NSString *)CFSTR("tiff")' with '@"tiff"' -- there's no need to use General/CFStrings in Cocoa code like that. :) - General/JonathanGrynspan

----

I am curious whether there is a way to capture screen as fast as  General/SnapzPro , or which technology did  General/SnapzPro adopt to achieve such speed? Is there anybody want to discuss?
----
How does remote descktop work ?  If remote descktop can work at near real time then all that is needed is a way to redirect remote desktop to a movie.

----

It looks like Apple recently posted an updated General/OpenGL screen shot example to http://developer.apple.com/samplecode/General/OpenGLScreenSnapshot/index.html

However, there is a note in the READ ME for that example that says that glReadPixels() (which the example uses) is simple, but not very efficient. There's more information about an alternative approach using asynchronous texture fetching at http://developer.apple.com/technotes/tn2004/tn2093.html#TNTAG9 and http://developer.apple.com/documentation/General/GraphicsImaging/Conceptual/General/OpenGL-General/MacProgGuide/opengl_texturedata/chapter_10_section_6.html#//apple_ref/doc/uid/TP40001987-CH407-SW13

----

As for how remote desktop works... I'd expect that instead of capturing the entire display, it uses something comparable to General/CGRegisterScreenRefreshCallback() to only be notified about discrete screen updates and pass those along. Although remote desktop is not open source, Chicken of the VNC is... so you could always check http://sourceforge.net/projects/cotvnc/ for ideas (but note the GPL license). [Update: scratch that... Chicken is only a VNC client, not a server.]

----

Sample code that uses the more efficient asynchronous texture fetching to grab the screen can be found in the General/FrameReader class of the Composer QCTV example at http://developer.apple.com/samplecode/QuartzComposer_WWDC_QCTV/index.html

----

Probably want to include a release of rep after adding it to the General/NSImage in the code at the top to avoid a leak.
-tm

----

The latest sample code shows how to use General/FrameReader to capture General/OpenGL to a quicktime movie.
http://developer.apple.com/samplecode/General/OpenGLScreenCapture/index.html

--- General/KelvinNishikawa--
----

Check out General/CGWindow.h for some cool new ways to capture individual windows and the screen.  There's also some new sample code up called "Son of Grab" at http://developer.apple.com/samplecode/General/SonOfGrab/index.html

Quick example I just typed up:

    
// add in an General/NSImage category
+ (General/NSImage*)imageWithWindow:(int)wid {
    
    // snag the image
	General/CGImageRef windowImage = General/CGWindowListCreateImage(General/CGRectNull, kCGWindowListOptionIncludingWindow, wid, kCGWindowImageBoundsIgnoreFraming);
    
    // little bit of error checking
    if(General/CGImageGetWidth(windowImage) <= 1) {
        General/CGImageRelease(windowImage);
        return nil;
    }
    
    // Create a bitmap rep from the window and convert to General/NSImage...
    General/NSBitmapImageRep *bitmapRep = General/[[NSBitmapImageRep alloc] initWithCGImage: windowImage];
    General/NSImage *image = General/[[NSImage alloc] init];
    [image addRepresentation: bitmapRep];
    [bitmapRep release];
    General/CGImageRelease(windowImage);
    
    return [image autorelease];   
}


----

Here is a quick (i.e. untested) example of how to capture the screen beneath a window, which is useful if you want to have a faux transparent window that does something with the image underneath (like General/FlySketch), or a window that applies a filter to achieve an interesting visual effect (like the semi-transparent blur applied by menus in Leopard).

    
- (General/NSImage *) imageBelowWindow: (General/NSWindow *) window
{
    // Get the General/CGWindowID of supplied window
    General/CGWindowID windowID = [window windowNumber];
    
    // Get window's rect in flipped screen coordinates
    General/CGRect windowRect = General/NSRectToCGRect( [window frame] );
    windowRect.origin.y = General/NSMaxY(General/window screen] frame]) - [[NSMaxY([window frame]);
    
    // Get a composite image of all the windows beneath your window
    General/CGImageRef capturedImage = General/CGWindowListCreateImage( windowRect, kCGWindowListOptionOnScreenBelowWindow, windowID, kCGWindowImageDefault );
    
    // The rest is as in the previous example...
    if(General/CGImageGetWidth(capturedImage) <= 1) {
        General/CGImageRelease(capturedImage);
        return nil;
    }
    
    // Create a bitmap rep from the window and convert to General/NSImage...
    General/NSBitmapImageRep *bitmapRep = General/[[[NSBitmapImageRep alloc] initWithCGImage: capturedImage] autorelease];
    General/NSImage *image = General/[[[NSImage alloc] init] autorelease];
    [image addRepresentation: bitmapRep];
    General/CGImageRelease(capturedImage);
    
    return image;
}
