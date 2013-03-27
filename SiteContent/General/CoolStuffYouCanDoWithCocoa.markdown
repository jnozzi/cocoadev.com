To give an overall sense of the power of Cocoa, add in some of the cool stuff you can do with Cocoa that would be rather more difficult with more common systems. Please provide some clear examples with your comments.

----

Thanks to some of the handy functions in Apple's Objective-C runtime headers (<objc/objc-class.h> and <objc/objc-runtime.h>), you can easily create arrays of all the loaded classes at runtime and all the method names for a particular class.  This is runtime introspection.

The following two methods could be placed into a category on General/NSArray:

    
+(General/NSArray *)arrayWithStringsForClassList
{
	int i = 0;
	int numClasses = 0, newNumClasses = objc_getClassList(NULL, 0);
    Class *classes = NULL;
	General/NSMutableArray *classesArray = General/[[NSMutableArray alloc] init];
	
    while (numClasses < newNumClasses)
	{
        numClasses = newNumClasses;
        classes = realloc(classes, sizeof(Class) * numClasses);
        newNumClasses = objc_getClassList(classes, numClasses);
    }
	
	for(i = 0; i < numClasses; i++)
		[classesArray addObject:General/NSStringFromClass(classes[i])];
	
    free(classes);
	
	return [classesArray autorelease];
}

+(General/NSArray *)arrayWithStringsForMethodsOfClass:(Class)theClass
{
	void *iterator = 0;
	struct objc_method_list *mlist;
	int i;
	General/NSMutableArray *selectorArray = General/[[NSMutableArray alloc] init];
	
	while(mlist = class_nextMethodList([theClass class], &iterator))
		for(i=0; i<mlist->method_count; ++i)
			[selectorArray addObject:General/NSStringFromSelector(mlist->method_list[i].method_name)];
	
	free(iterator);
	free(mlist);
	return [selectorArray autorelease];
}



This is advanced stuff, but it really gives you a sense of the power that Objective-C and Cocoa give you.

-- General/RobRix

AWESOME!

Actually, the above example is not correct - each methodList has an array of methods. The example above only prints the first one. here is the corrected example:

    
	void *iterator;
	struct objc_method_list *mlist; 
	int i;

 	// must start with this initialed   
	iterator = nil;
	
	mlist = (struct objc_method_list *)class_nextMethodList( General/[NSLayoutManager class], &iterator );
	
	while(mlist != nil) {
		General/NSLog(@"Methods in this chunk %d", mlist->method_count);
		for(i=0; i<mlist->method_count; ++i) {
			General/NSLog(@"--Method Name:%@ types %s", General/NSStringFromSelector(mlist->method_list[i].method_name), mlist->method_list[i].method_types);
		}
		mlist = (struct objc_method_list *)class_nextMethodList( General/[NSLayoutManager class], &iterator );
	}


David

*Fixed the code inline. Incidentally, why are you "correcting" it by replacing working code with General/NSLog<nowiki/>s?*

----

This is not Cocoa specific, but thanks to the GCC provided by apple you can mix and match 2 of the most popular programming languages (C and C++) and one of the best programming languages (Objective-C) in ONE SOURCE FILE! There are no lack of libraries that are compatible with Cocoa! I guess .NET and CLR try to provide something almost like this, but it does not leverage 20 + years of programming libraries.

    
// Source.h
struct General/STKFilterCore;
@interface General/STKFilter : General/NSObject
{
    struct General/STKFilterCore * core;
}
- (void) processSoundFile:(General/NSString*)path;
@end

// Source.mm
#import "Source.h"

#include <boost/shared_ptr.hpp>
#include <boost/shared_array.hpp>
using namespace boost;

#include <Filter.h> // From STK, a C++ library.
#include <sndfile.h> // A great soundfile loading C library.

struct General/STKFilterCore
{
    shared_ptr<Filter> filter;
    // Constructor, destructor, copy, ie. a full C++ class!
};

@implementation General/STKFilter
- (id) init
{
    if(self= [super init]) {
        try { core = new General/STKFilterCore; } catch(...) { 
            General/NSLog(@"Failed to create core, aborting.");
            [self release];
            return nil;
        }
    }
    return self;
}
- (void) dealloc
{
    delete core;
    [super dealloc];
}
- (void) processSoundFile:(General/NSString*)path
{
    // Error checking left out for compactness...
    SF_INFO sndFileInfo_IN, sndFileInfo_OUT;
    memset(&sndFileInfo_IN, 0, sizeof(SF_INFO));
    SNDFILE * sndFileIn  = sf_open([path fileSystemRepresentation], SFM_READ, &sndFileInfo_IN);

    sndFileInfo_OUT = sndFileInfo_IN;
    SNDFILE * sndFileOut = sf_open(General/path stringByAppendingString:@"_OUT"] fileSystemRepresentation], 
        SFM_WRITE, &sndFileInfo_OUT);	

    unsigned amtLeft = sndFileInfo_IN.frames*sndFileInfo_IN.channels;
    const unsigned chunkSize = 512;
    shared_array<float> data(new float[chunkSize]);
    while(amtLeft) {
        const unsigned thisSize = MIN(chunkSize, amtLeft);
        sf_read_float(sndFileIn, data.get(), thisSize);
       
        core->filter->tick(([[StkFloat*)data.get(), thisSize);

        sf_write_float(sndFileOut, data.get(), thisSize);
        amtLeft -= thisSize;
    }
	
    sf_close(sndFileIn);
    sf_close(sndFileOut);
}
@end


This is slightly simplified and incomplete, but the full file only needs about 100 more lines of code. Hundreds of programming hours designing Filters, figuring out file formats, all leveraged in minutes, put into a transparent Cocoa object that can be used by any Cocoa newbie!

Jeremy Jurksztowicz

----

The     -cString was getting pretty off-topic for this page. Moved to General/StringWithCString.

----

One cool thing you can do with Cocoa is this:
    General/[[NSArray array] objectAtIndex:100];

----
General/FadeAViewAndItsContents is kind of neat, even if it could use some refinement. And there's General/CCDImageCategory, which you can use to make cells draw into an General/NSImage instead of an General/NSView like they expect to.