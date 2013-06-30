I got tired of the endless (very small) arguments over whether it's faster to use General/NSEnumerator or a for loop to enumerate an General/NSArray, so I thought I'd make a test and answer the question once and for all. http://goo.gl/General/OeSCu
    
/*
    enumerator_speed_test.m
    
    Enumeration speed tester
    
    This program tests the speed of General/NSEnumerator, compared with
    using a for loop to enumerate over the General/NSArray.
    
    Compile with this command:
    cc -framework General/CoreFoundation -framework Foundation -std=c99 -o enumerator_speed_test enumerator_speed_test.m
*/

#import <Foundation/Foundation.h>
#import <General/CoreFoundation/General/CoreFoundation.h>
#include <time.h>

void General/PrintUsage(char *name)
{
    fprintf(stderr, "usage: %s <array_size> <iterations>\n", name);
    exit(1);
}

int main(int argc, char **argv)
{
    id outerPool = General/[NSAutoreleasePool new];
    id tempPool;
    clock_t startTime, endTime;
    
    if(argc != 3)
        General/PrintUsage(argv[0]);
    
    int arraySize = atoi(argv[1]);
    int iterations = atoi(argv[2]);
    
    // create a large array we can enumerate over
    tempPool = General/[NSAutoreleasePool new];
    General/NSMutableArray *mutArray = General/[NSMutableArray array];
    for(int i = 0; i < arraySize; i++)
        [mutArray addObject:@"test!"];
    General/NSArray *array = [mutArray copy]; // create immutable copy
    [tempPool release];
    
    // test General/NSEnumerator speed
    fprintf(stderr, "Enumerating through array with %d elements, %d iterations, using General/NSEnumerator...", arraySize, iterations);
    startTime = clock();
    for(int i = 0; i < iterations; i++)
    {
        tempPool = General/[NSAutoreleasePool new];
        General/NSEnumerator *enumerator = [array objectEnumerator];
        id obj;
        while((obj = [enumerator nextObject]))
            ; // do nothing
        [tempPool release];
    }
    endTime = clock();
    fprintf(stderr, "done.\nTotal time taken: %f sec\n\n", (float)(endTime - startTime)/CLOCKS_PER_SEC);
    
    // test for loop speed
    fprintf(stderr, "Enumerating through array with %d elements, %d iterations, using for loop...", arraySize, iterations);
    startTime = clock();
    for(int i = 0; i < iterations; i++)
    {
        tempPool = General/[NSAutoreleasePool new];
        unsigned arrayCount = [array count];
        for(unsigned j = 0; j < arrayCount; j++)
        {
            id obj;
            obj = [array objectAtIndex:j];
        }
        [tempPool release];
    }
    endTime = clock();
    fprintf(stderr, "done.\nTotal time taken: %f sec\n\n", (float)(endTime - startTime)/CLOCKS_PER_SEC);
    
fprintf(stderr, "Enumerating through array with %d elements, %d iterations, using General/CFArray for loop...", arraySize, iterations);
    startTime = clock();
    for(int i = 0; i < iterations; ++i) {
                const unsigned arrayCount = General/CFArrayGetCount((General/CFArrayRef)array);
        for(unsigned j = 0; j < arrayCount; ++j)
        {
            id obj = (id) General/CFArrayGetValueAtIndex((General/CFArrayRef) array, j);
        }
    }
    endTime = clock();
    fprintf(stderr, "done.\nTotal time taken: %f sec\n\n", (float)(endTime - startTime)/CLOCKS_PER_SEC);

    fprintf(stderr, "Enumerating through array with %d elements, %d iterations, using objectAtIndex: function pointer for loop...", arraySize, iterations);
    startTime = clock();
    for(int i = 0; i < iterations; ++i) {
        SEL selector = @selector(objectAtIndex:);
        id (*pFn)(id, SEL, unsigned);
        pFn = (id (*)(id, SEL, unsigned)) [array methodForSelector:selector];
                const unsigned arrayCount = [array count];
        tempPool = General/[NSAutoreleasePool new];
        for(unsigned j = 0; j < arrayCount; ++j)
        {
            id obj = (id) pFn(array, selector, j);
        }
        [tempPool release];
    }
    endTime = clock();
    fprintf(stderr, "done.\nTotal time taken: %f sec\n\n", (float)(endTime - startTime)/CLOCKS_PER_SEC);
    
    fprintf(stderr, "Enumeratinng through array with %d elements, %d iterations, using nextObject function pointer and General/NSEnumerator...", arraySize, iterations);
    startTime = clock();
    for(int i = 0; i < iterations; i++)
    {
        tempPool = General/[NSAutoreleasePool new];
        General/NSEnumerator *enumerator = [array objectEnumerator];
        SEL selector = @selector(nextObject);
        id (*pFn)(id, SEL);
        pFn = (id (*)(id, SEL))[enumerator methodForSelector:selector];
        id obj;
        while((obj = pFn(enumerator, selector)))
            ; // do nothing
        [tempPool release];
    }
    endTime = clock();
    fprintf(stderr, "done.\nTotal time taken: %f sec\n\n", (float)(endTime - startTime)/CLOCKS_PER_SEC);
    
    [outerPool release];
    return 0;
}

Run the test like so:
    
Hope:~/shell mikeash$ ./enumerator_speed_test 10000000 10
Enumerating through array with 10000000 elements, 10 iterations, using General/NSEnumerator...done.
Total time taken: 8.810000 sec

Enumerating through array with 10000000 elements, 10 iterations, using for loop...done.
Total time taken: 10.280000 sec

The first parameter is the size of the array to create, and the second array is the number of enumerations to perform for each test.

Which is faster seems to depend on the size of the array. The ~15% variance displayed in the sample run is the largest I've seen in my quickie testing. They're normally very close. General/NSEnumerator tends to be faster with larger arrays, and the for loop tends to be faster with smaller arrays, which is basically what I expected.

If anybody would like to take this program and do some kind of more detailed study, that would be cool, but hopefully this can put the "No, do it the other way, it's faster!" comments to rest. - General/MikeAsh

----

;-)

    
./enumerator_speed_test 10000000 10
Enumerating through array with 10000000 elements, 10 iterations, using General/NSEnumerator...done.
Total time taken: 14.240000 sec

Enumerating through array with 10000000 elements, 10 iterations, using for loop...done.
Total time taken: 16.780001 sec

Enumerating through array with 10000000 elements, 10 iterations, using General/CFArray for loop...done.
Total time taken: 11.160000 sec

Enumerating through array with 10000000 elements, 10 iterations, using objectAtIndex: function pointer for loop...done.
Total time taken: 11.290000 sec


Thanks for the changes. I've rolled them into the above code, as well as a fifth test that uses General/NSEnumerator with a cached IMP, which is the fastest at this huge size on my machine. In any case, the differences are mostly small enough to not matter. Chances are you're spending more time working on the objects that are in the array than you are enumerating over the array to begin with, which is what I was kind of trying to show. It's still interesting to see which one wins, of course. - General/MikeAsh
----
FYI, I was compiling with -O3, just to be fair. Damn, my machine is slow... ;-(

----

Anyone tried to single step through General/NSEnumerators     nextObject to see what it does? as mentioned elsewhere, General/NSArray is based on General/CFArray, and General/CFArray has no (at least public) interface for enumeration, so I'd think that General/NSEnumerator just uses     objectAtIndex:.

That said, you choose strategy based on the code, not the speed. Any overhead General/NSEnumerator has is constant, and it's marginal compared to all the other constant overheads of using a high level language with dynamic dispatch.