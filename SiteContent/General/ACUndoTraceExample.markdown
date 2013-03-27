In order to produce General/SketchDotAppUndoTrace to solve General/SketchDotAppUndo, we changed Sketch_main.m as follows:

    
 #import <AppKit/AppKit.h>
 #import <AspectCocoa/ACPointCut.h>
 #import <AspectCocoa/ACAspect.h>
 #import <AspectCocoa/ACLoggingAdvice.h>
 #import <AspectCocoa/ACAspectManager.h>
 
 int main(int argc, const char *argv[]) {
 
     NSAutoreleasePool * pool = General/NSAutoreleasePool alloc] init];
 
     ACPointCut * pointCut = [[ACPointCut alloc] initDefault];
     [[pointCut getClassScope] addClassAndMeta: [NSUndoManager class;
     ACAspect * myAspect = General/ACAspect alloc] initWithPointCut: pointCut 
                                             andAdviceObject: [ACLoggingAdvice new;
     [myAspect load];    
 
     [pool release];
 
     return NSApplicationMain(argc, argv);
 }
