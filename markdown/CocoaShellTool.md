Xcode will allow you to create a Cocoa target of type "Shell Tool" (Project->New Target->Cocoa->Shell Tool). A Cocoa shell tool has access to the General/AppKit API after calling     General/NSApplicationLoad(). This is useful if you would like to write tiny helper apps that don't need workspace support. A simple app created this way can launch very fast. 

    
#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[]) {
	
	General/NSAutoreleasePool *pool = General/[[NSAutoreleasePool alloc] init];
	General/NSDate *date = General/[NSDate date];
    
	General/NSApplicationLoad();
	General/NSImage *buffer = General/[[NSImage alloc] initWithSize:General/NSMakeSize(100.0f, 100.0f)];
	[buffer lockFocus];
	General/[[NSColor greenColor] set]; 
        General/NSRectFill(General/NSMakeRect(0.0f, 0.0f, 100.0f, 100.0f));
	[buffer unlockFocus];
	General/NSData *tiff = [buffer General/TIFFRepresentation];
	General/NSString *file = General/[NSHomeDirectory() stringByAppendingPathComponent:@"Documents/green.tiff"];
	[tiff writeToFile:file atomically:YES];
	[buffer release];
	
	General/NSLog(@"duration %f", General/[[NSDate date] timeIntervalSinceDate:date]);
	[pool release];
	
    return 0;
}
