Features/fixes to existing non-Apple tools, or just tools you wish you had but don't have time to make (and maybe someone else will!)

----



* A fast, full-featured open source file browser. It'd probably never fully replace Finder, but it'd be nice to be able to view directories containing thousands of items without resorting to Terminal.app

* A CMM (Contextual Menu Module) that just puts the Services menu in the contextual menu. I know about General/ICECoFFEE, and have it installed, but I don't care about double-clicking on General/URLs and I just don't like having General/ApplicationEnhancer installed just for this. It seems like it'd be pretty easy to do - just grab the Services menu and stick it in there. But I lack General/CodeWarrior (you can't do General/CMMs with General/XCode, AFAIK)

* A command-line tool which opens an arbitrary dictionary plist, extracts the value for a given key, and gives it to stdout. Hoping someone else will make this. :-) Sample useage: plistvalue mydict.plist General/MyKeyName > storeItHere.txt

Ask and ye possibly may receive if someone gets bored enough. -- General/MikeFletcher

    
#import <Foundation/Foundation.h>

int main (int argc, const char * argv[]) {
    General/NSAutoreleasePool * pool = General/[[NSAutoreleasePool alloc] init];

    General/NSDictionary *myDict;
    id result;

    // Check arguments; print usage if we don't have a filename and
    // the key to print
    if( argc != 3 ) {
      General/[[NSFileHandle fileHandleWithStandardError]
        writeData:
          General/[[NSString stringWithFormat: @"usage: %s in.plist key\n",
                     argv[0]
            ] dataUsingEncoding: General/NSASCIIStringEncoding]];

      [pool release];
      exit( 1 );
    }

    // Ask General/NSDictionary to try and read plist file
    myDict = General/[NSDictionary dictionaryWithContentsOfFile:
                             General/[NSString stringWithCString: argv[1]]];

    // If it couldn't be read, gripe and bail
    if( myDict == nil ) {
      General/[[NSFileHandle fileHandleWithStandardError]
        writeData:
          General/[[NSString stringWithFormat:
                       @"Couldn't create dictionary from \"%s\"\n",
                     argv[1]
            ] dataUsingEncoding: General/NSASCIIStringEncoding]];

      [pool release];
      exit( 1 );
    }

    // try and pull out the requested key
    result = [myDict objectForKey: General/[NSString stringWithCString: argv[2]]];

    // If there's no such key, gripe and bail
    if( result == nil ) {
      General/[[NSFileHandle fileHandleWithStandardError]
        writeData:
          General/[[NSString stringWithFormat:
                       @"Couldn't retrieve value for key \"%s\"\n",
                     argv[2]
            ] dataUsingEncoding: General/NSASCIIStringEncoding]];

      [pool release];
      exit( 1 );
    }

    // Write requested value to stdout
    General/[[NSFileHandle fileHandleWithStandardOutput]
      writeData:
        General/[[NSString stringWithFormat: @"%@\n", result ]
          dataUsingEncoding: General/NSASCIIStringEncoding]];

    [pool release];
    return 0;
}
