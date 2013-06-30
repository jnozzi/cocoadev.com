

**This provides some useful methods you can use if you want to make a PICT object in Cocoa.**

My app draws a nice image, incorporating General/NSBezierPaths and General/NSAttributedStrings. I'd now like to copy it via the Pasteboard into
Canvas 9 (a commercial graphics app). It's easy to put the data in TIFF, PDF and EPS format onto the general pasteboard. The problem 
with this is that Canvas seems to interpret these as bitmapped images, not as vector graphics objects. Going the other way, I note that 
Canvas copies vector graphics objects onto the Pasteboard as General/NSPICTPboardType; I therefore conclude that I need to make a representation
of my image as type PICT. I've read quite a few discussions about this, and I understand that there's no way of doing a simple conversion
from PDF to PICT in Cocoa (why not? - the information should all be there in PDF format - if Apple won't provide it, has anyone else written a 
converter?).

So I would like to recreate my image as a PICT file, but I can't seem to do it. I'm happy to use the simple General/QuickDraw commands if I must 
(General/MoveTo, General/LineTo etc), but my only real experience of Mac programming is in Cocoa (I love Objective C) and in comparison Carbon looks
horrendously baroque, and so I'd like to do it as much as possible in Cocoa. I've looked at two approaches:

1. Use General/QuickDraw commands inside an General/NSQuickDrawView. But how do I get the PICT data out again? I can get it out as PDF or EPS 
(dataWithEPSInsideRect and dataWithPDFInsideRect), but I can't see an option for just getting the PICT data.

2. Draw into a General/NSPICTImageRep. But here I'm getting really unstuck. It seems to me that General/NSPICTImageRep is designed for accessing pre-existing 
PICT images. The initialiser wants data; all I can do is give it nil. So I tried the following:
    General/NSPICTImageRep* theImageRep = General/[[NSPICTImageRep alloc] initWithData:nil];
[theImageRep setPixelsHigh:100];
[theImageRep setPixelsWide:100];
General/NSImage* theImage=General/[[NSImage alloc] initWithSize:(General/NSSize){100,100}];
[theImage addRepresentation:theImageRep];
[theImage lockFocus];
// do some General/QuickDraw drawing
[theImage unlockFocus];

However, when I try to lockFocus, I get the error message: "Can't cache image". 

Am I doing something silly, or is it really the case that Cocoa won't let me generate PICT data?

Any help gratefully received,

General/JulianBlow

----

I'm sorry that my post cannot be of help, but I would like to congratulate you on a beautiful post. Too many people post and just ask for code with out really explaining what they are trying to do, or what they have tried up until that point. You on the other hand have come to the table with a good amount of information about your problem, and what you have tried. Good Job.

----
Have you tried instead to initWithData:General/[NSData data]] (empty data). Maybe it does not like nil very much...

----
General/[NSData data] gives the same error as nil, I'm afraid. I've also tried using General/NSPICTImageRep's setSize: method to force it to contain something, and still no joy. It seems the General/NSPICTImageRep is being established properly - it's being set to a non-NULL value, and records the size I set it. But I can't fool General/NSImage that it isn't just an empty container....

----
Since I got no replies, I presumed it wasn't possible, and delved into the baroque badness that is Carbon. It's not so hard to do, but in case anyone else encounters this problem, I show here my Objective-C class that does it all for you. It simply wraps a few Carbon calls into a tolerably Cocoa-like class;

    #import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface General/JBPICTCreator : General/NSObject {
    General/NSSize theSize;
    General/PicHandle thePictHandle;
}
+ (General/JBPICTCreator*) General/JBPICTCreatorWithSize:(General/NSSize)General/PICTSSize;
- (id) initWithSize:(General/NSSize)General/PICTSSize;
- (void) lockFocus;
- (void) unlockFocus;
- (General/NSData *) General/PICTRepresentation;
@end

@implementation General/JBPICTCreator

+ (General/JBPICTCreator*)General/JBPICTCreatorWithSize:(General/NSSize)General/PICTSSize
{
    General/JBPICTCreator* theJBPC = [self alloc];
    if(!theJBPC) return NULL;
    theJBPC = [theJBPC initWithSize:General/PICTSSize];
    return [theJBPC autorelease];
    }

- (id)initWithSize:(General/NSSize)General/PICTSSize
{
    theSize=General/PICTSSize;
    return self;
    }

- (void)lockFocus
{
    Rect myRect={0,0,theSize.height,theSize.width};
    General/OpenCPicParams thePicParams={myRect,0x00480000,0x00480000,-2,0,0};
    thePictHandle=General/OpenCPicture (&thePicParams);
    }
    
- (void)unlockFocus
{
    General/ClosePicture();
    }
    
- (General/NSData *)General/PICTRepresentation
{
    Size thePictSize=General/GetHandleSize((Handle)thePictHandle);
    General/PicPtr myPicPtr=*thePictHandle;
    return General/[NSData dataWithBytes:myPicPtr length:thePictSize];
    }
    
- (void)dealloc
{
    General/KillPicture(thePictHandle);
    [super dealloc];
    }
    
@end


You have to do your drawing with General/QuickDraw calls though, like this:
    General/JBPICTCreator* thePICT=General/[JBPICTCreator General/JBPICTCreatorWithSize:(General/NSSize){200,200}];
[thePICT lockFocus];
// do some General/QuickDraw drawing here
[thePICT unlockFocus];
General/NSData* thePICTData = [thePICT General/PICTRepresentation];


General/JulianBlow

----

I seem to be performing a monologue, but on the offchance that someone else is listening, here's the latest development in my attempts to make Cocoa more friendly for creating PICT data. Having got a Cocoa object that allows you to record General/QuickDraw drawing (General/JBPICTCreator), I wanted a way of doing the drawing without having to re-write all my existing Cocoa routines. So I created a category of General/NSBezierPath, (called the General/QuickDrawAddition category). This declares a fillUsingQuickDraw... method and a strokeUsingQuickDraw... method, to fill and stroke the General/NSBezierPath using General/QuickDraw commands.

    #import <Cocoa/Cocoa.h>
#import <Carbon/Carbon.h>

@interface General/NSBezierPath (General/QuickDrawAddition)
-(void) fillUsingQuickDrawWithViewHeight:(int)theViewHeight;
-(void) strokeUsingQuickDrawWithViewHeight:(int)theViewHeight 
                       asSeparatePICTObjects:(BOOL)separateObjects;
-(void) quickDrawWithViewHeight:(int)theViewHeight stroke:(BOOL)withStroke 
                       fill:(BOOL)withFill asSeparatePICTObjects:(BOOL)separateObjects;
@end

@implementation General/NSBezierPath (General/QuickDrawAddition)

// ===========================================================
//	fillUsingQuickDrawWithViewHeight:
// ===========================================================
// Fills the contents of the General/NSBezierPath using General/QuickDraw commands.
// This is a convenience method that calls 
// quickDrawWithViewHeight:stroke:fill:asSeparatePICTObjects: with stroke NO, 
// fill YES, and asSeparatePICTObjects as NO.
-(void) fillUsingQuickDrawWithViewHeight:(int)theViewHeight
{
   [self quickDrawWithViewHeight:theViewHeight stroke:NO fill:YES asSeparatePICTObjects:NO];
   }

// ============================================================
//	strokeUsingQuickDrawWithViewHeight:asSeparatePICTObjects:
// ============================================================
// Strokes the contents of the General/NSBezierPath using General/QuickDraw commands.
// asSeparatePICTObjects determines whether line segments are grouped into polygons,
// each terminated by a closePath element.
// This is a convenience method that calls 
// quickDrawWithViewHeight:stroke:fill:asSeparatePICTObjects: with stroke NO,
// and fill NO.
-(void) strokeUsingQuickDrawWithViewHeight:(int)theViewHeight 
                              asSeparatePICTObjects:(BOOL)separateObjects
{
    [self quickDrawWithViewHeight:theViewHeight stroke:YES fill:NO 
                               asSeparatePICTObjects:separateObjects];
    }
    
// ===========================================================
//	quickDrawWithViewHeight:stroke:fill:asSeparatePICTObjects:
// ===========================================================
// Draws the contents of the General/NSBezierPath using General/QuickDraw commands. If withStroke,
// the resultant path is stroked; if withFill the resultant path is filled.
// If asSeparatePICTObjects is true, each segment of the path is drawn as a separate PICT
// object, so polygons are not built up. Otherwise, the closePath method of General/NSBezierPath
// is used to determine where one polygon ends and another begins.
// Because General/QuickDraw views are vertically flipped, it is necessary to know the
// vertical height of the view the General/NSBezierPath is being drawn into.
// The pen width is set in the current General/NSBezierPath.
// All other drawing attributes have to be set outside this method.
-(void) quickDrawWithViewHeight:(int)theViewHeight stroke:(BOOL)withStroke 
                          fill:(BOOL)withFill asSeparatePICTObjects:(BOOL)separateObjects
{
    General/NSPoint associatedPts[3];
    General/NSPoint startPolyPt;
    General/NSPoint currentPt=General/NSMakePoint(0.0,0.0);  // in case no initial moveToPoint
    int j;
    BOOL drawingAPoly=NO;
    General/PolyHandle aPoly;
    General/PenSize([self lineWidth],[self lineWidth]);
    General/NSBezierPath* newBP = [self bezierPathByFlatteningPath]; // QD can't do Bezier curves
    int elementCount=[newBP elementCount];
    
    for(j=0;j<elementCount;j++) {
	switch ([newBP elementAtIndex:j associatedPoints:associatedPts]) {
	    case General/NSMoveToBezierPathElement:
		General/MoveTo(associatedPts[0].x,theViewHeight-associatedPts[0].y);
		currentPt=associatedPts[0];
		break;
	    case General/NSLineToBezierPathElement:
		if(!drawingAPoly) {                      // here's the start of a new poly
		    drawingAPoly=YES;
		    startPolyPt=currentPt;
		    if(!separateObjects) aPoly=General/OpenPoly();
		    }
		General/LineTo(associatedPts[0].x,theViewHeight-associatedPts[0].y);
		currentPt=associatedPts[0];
		break;
	    case General/NSCurveToBezierPathElement: // flat path - these shouldn't exist
		break;
	    case General/NSClosePathBezierPathElement:
		if(drawingAPoly) {
		    General/LineTo(startPolyPt.x,theViewHeight-startPolyPt.y);
		    drawingAPoly=NO;
		    if(!separateObjects) {
			General/ClosePoly();
			if(withStroke) General/FramePoly(aPoly);
			if(withFill) General/PaintPoly(aPoly);
			General/KillPoly(aPoly);
			}
		    }
		currentPt=startPolyPt;
		break;
	    }
	}

    if(drawingAPoly&&!separateObjects) {    // if polygon left open
	General/ClosePoly();
	if(withStroke) General/FramePoly(aPoly);
	if(withFill) General/PaintPoly(aPoly);
	General/KillPoly(aPoly);
	}
    }
@end


General/JulianBlow, 28th October 2004

----
Yes, this is a monologue (well, not anymore), but no, you are not alone. Thanks for that page!! In case I ever need some General/QuickDraw stuff, I know where to start :-) --General/CharlesParnot

----

In Tiger you can use this command to convert an image to PICT:
    
sips --setProperty format pict <input_file> --out output.pict


----

    
// from http://www.cocoabuilder.com/archive/message/cocoa/2003/7/23/82391
#import <General/QuickTime/General/QuickTime.h>

[...]

- (General/NSData *)pictDataForImage:(General/NSImage *)img
{
	General/MovieImportComponent importer;
	
	if (General/OpenADefaultComponent(General/GraphicsImporterComponentType, kQTFileTypeTIFF, &importer) != noErr)
	{
		General/CloseComponent(importer);
		return nil;
	}
	
	Handle imageHandle;
	General/NSData *imageData = [img General/TIFFRepresentation];
	long int dataSize = [imageData length];
	(void)General/PtrToHand([imageData bytes], &imageHandle, dataSize);
	
	General/OSErr err = General/GraphicsImportSetDataHandle(importer, imageHandle);
	if (err != noErr)
		return nil;
	
	General/PicHandle resultPicHandle = (General/PicHandle)General/NewHandleClear(20);
	err = General/GraphicsImportGetAsPicture(importer, &resultPicHandle);
	
	General/NSData *returnValue = General/[NSData dataWithBytes:*resultPicHandle length:(int)General/GetHandleSize((Handle)resultPicHandle)];
	General/DisposeHandle((Handle)resultPicHandle);
	
	return returnValue;
}

Michel Vaillant, June 2006
----
This doesn't work for me using 10.4.10. The function General/GraphicsImportGetAsPicture() is unrelible, working some times and other times it returns error -8969 codecBadDataErr - Billy Bob 10/8/07
----

Very interesting page, after spending many hours on cocoa's docs, this pages lerned me much more on the question, and resolved me the issue.
Thanks,
Michel Vaillant

----

Yes I have had a similar problem but how do you get a PICT with alpha into an General/NSImage, retaining the alpha, carryout some modification then return the General/NSImage as a PICT but still containing the alpha.

Any one got any ideas it has been bugging me for days without a solution in sight.

----
Where are you getting PICT data with alpha? AFAICR, PICT nor General/QuickDraw support the concept of alpha, let alone implement it. I believe General/CopyBits will preserve anything in the unused bits of a direct pixel, which is where the alpha shows up, but it doesn't use this data when rendering to give transparency effects. You might be able to split out that "channel" as a separate bitMap/pixMap which you could use as the mask parameter to General/CopyDeepMask, which would get you a little way, but since General/CopyDeepMask isn't saved in General/PICTs, it may not help. It may also be that when recording General/CopyBits in a PICT, the "alpha" channel is simply discarded to save space - this would be reasonable for General/QuickDraw since for it, these are just unused bits. The only other way to support alpha in a PICT would be to roll your own in General/PicComments, but since it would be non-standard it's probably not a useful route except in your own apps. Unless some alpha magic has been added to General/QuickDraw in the last few years that I don't know about, I think you'll find that it's simply not possible. Use TIFF or PDF instead. --General/GrahamCox
----
Graham
I am writing an external for General/SuperCard. When I obtain the PICT data from SC and pass it into General/NSImage then manipulate the image the alpha is lost when I pass it back to SC.

However if I use a call to SIPS and either make a PICT with the data from SC or a TIFF the alpha is retained.

If I export the PICT data from SC as a PICT file then open that file with Preview it has alpha. Preview in it's info box says it has alpha.

I have read in other places that PICT does not support alpha.

Terry Heaford

----

I googled around and it looks as if there is a way for PICT to support alpha, when it's embedding a General/QuickTime compressed image. In this case, the PICT file format is really just acting as a container for the QT image data - sort of a 'black box' inside a black box. Provided you use the QT routines to read and write this PICT, alpha is supported. So I would guess that the answer to your question may lie in the General/QTKit - I haven't looked but it might include methods for importing and exporting between a QT PICT and General/NSImage. --General/GrahamCox

----

It is also possible to specify a clipping mask or clipping region in a PICT. Many old DTP packages used this technique for EPS files with PICT screen previews. (I used to have lots of code which worked with these General/PICTs but I'm afraid it is all horribly obsolete at this point in time.) 


----
Here's yet another way to get PICT data from an General/NSImage (from my General/NSImage category, which you can get here: www.eternalstorms.at/developers/):
    
General/NSImage *myImage = General/[NSImage imageNamed:@"someImage.png"];
General/NSPasteboard *pb = General/[NSPasteboard pasteboardWithName:@"essimagecategory"];
[pb types];
[pb declareTypes:General/[NSArray arrayWithObject:General/NSTIFFPboardType] owner:nil];
[pb setData:[myImage General/TIFFRepresentation] forType:General/NSTIFFPboardType];
General/NSData *pictData = General/pb dataForType:[[NSPICTPboardType] retain];
[pboard releaseGlobally];
/*
do something with the data here
*/
[pictData release];


Hope this helps.
Take care,

--General/MatthiasGansrigler