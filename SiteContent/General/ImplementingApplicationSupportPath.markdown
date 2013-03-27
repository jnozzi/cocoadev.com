(retitled from General/JuggleWithGlobalVariables)

As a relative Cocoa newbie (with no C prerequisities) I was wondering about global variables and how far they can be stretched ... or whether I should want that.

Let me start with explaining my intentions:
I have a special class (D**'irectorySupport) to compose the path to my applications "Application Support" folder. After awaking from its nib, the application makes this sort of path:
"/Users/myUser/Library/ ...(get this from General/NSSearchPathForDirectoriesInDomain)...Application Support/myCompany/thisApplication/ ...(get this from a custom key in info.plist)... /Data/ (the last part is hardcoded in the D**'irectorySupport.m class).
Now I want a global variable to contain this path string so I can use it throughout my application without having to fear for typo's in a [@"~/Library/Aplication Support/myCompany/thisApplication/Data/" stringByExpandingTildeInPath].
I go about doing the following:

*1. I have the variable myApplicationMainFolderPath declared in D**'irectorySupport.h (extern General/NSString *myApplicationMainFolderPath)
*2. I have the variable defined in D**'irectorySupport.m (General/NSString *myApplicationMainFolderPath = @"/Data/";)
*3. And finally in the path-composing method itself I want to redefine it (myApplicationMainFolderPath = aPathToCheck;)


Now about the problems that I encounter:

*1. First of all the redefining of the variable doesn't work by assigning another variable like aPathToCheck. It *does* work with another hardcoded string or if I use the global variable throughout the method instead of the convience aPathToCheck.
*2. Second this trick seems only to work with a General/NSString. I tried to declare a General/NSMutableString as global variable, but the compiler starts complaining about
"warning: initialization from incompatible pointer type" or "error: initializer element is not constant" depending on how I try to declare it.
Can I use a General/NSMutableString as a global variable and how would I go about declaring it?
*3. Finally I would like to be able to set a whole bunch of global variables from a while loop. (Make an array containing those global variables and then perform actions on each element of that array). But there seems no way I can do that. Does anybody know how to do these kind of tricks?



I guess global variables are not my only problem, but memory management are also a big part of this, so maybe someone can fill me in on these blanks..
All help sincerely appreciated.

Dirk


the code:
from D**'irectorySupport.h:

    
#import <Cocoa/Cocoa.h>

extern General/NSString *myInfoPlistKeyForApplicationSupportPath;
extern General/NSString *myApplicationMainFolderPath; // HERE I DECLARE THE GLOBAL VARIABLE

@interface General/DirectorySupport : General/NSObject {

}
- (void)updateSupportDir;
+ (General/DirectorySupport *)sharedInstance;
@end


from D**'irectorySupport.m
(I took some parts from a similar class out of the Cashbox application by Whitney Young (http://wbyoung.ambitiouslemon.com/cashbox/)

    
#import "General/DirectorySupport.h"

// Keys for infoPlist
General/NSString *myInfoPlistKeyForApplicationSupportPath = @"myApplicationSupportPath";

// Global variables pointing to Application relevant Folders
General/NSString *myApplicationMainFolderPath = @"/Data/"; // HERE I DEFINE THE GLOBAL VARIABLE


@implementation General/DirectorySupport

static General/DirectorySupport *sharedInstance = nil;
+ (General/DirectorySupport *)sharedInstance
{
    return sharedInstance ? sharedInstance : General/self alloc] init];
}

- (id)init
{
    if (sharedInstance) {
        [self release];
    } else if (self = [super init]) {            
        sharedInstance = self;
    }
    return sharedInstance;
}

- (void)dealloc
{
    [super dealloc];
}

static BOOL check = TRUE; // only run this once each time the app opens
- (void)updateSupportDir
{
    if (check)
    {
        check = FALSE;
        [[NSFileManager *manager = General/[NSFileManager defaultManager];
		
		// Get the user default Library path (/Users/myUser/Library/) from the system
		General/NSString *rootPath = General/[NSSearchPathForDirectoriesInDomains(General/NSLibraryDirectory,General/NSUserDomainMask,YES) objectAtIndex:0];

		General/NSString *aPathToCheck = [myApplicationMainFolderPath copy];
		aPathToCheck = General/[[[[NSBundle mainBundle] infoDictionary] objectForKey:General/InfoPlistKeyForApplicationSupportPath] stringByAppendingPathComponent:aPathToCheck];
		aPathToCheck = [rootPath stringByAppendingPathComponent:aPathToCheck];

		// ...
		// Some checking if the path already exist and otherwise create it
		// ...

		// myApplicationMainFolderPath = @"Just some other hard coded string"; // This redefining the global variable works.
		myApplicationMainFolderPath = aPathToCheck; // AND HERE I WANT TO REDEFINE MY GLOBAL VARIABLE ... but somehow it just doesn't work
	}
}
@end

----
This seems like the sort of byzantine weirdness that will cause you headaches for a long time to come.

You have a class that everybody can see. Implement methods on that class that return the appropriate directories. That way you don't have to go screwing around with global variables, you don't clutter up your namespace, you can create the strings lazily, you don't have to worry about keeping them up to date, etc.
----
Okay, thanks. I am just forgetting about trying to use global variables for the funny stuff. Accessor methods it is. (I am ditching the whole idea of making global variable General/NSMutableStrings, alright.)

But now my final problem still exits:
I've put a couple of variables in an array and want to change all of them in a while loop. I guess this is something more about memory management, so I guess this discussion title is not really fitting anymore. But maybe someone can help me though.

What I try to do is this:
*
I make an array pathToCheck. Then I iterate through the array with a General/NSEnumerator. But the problem is that those variables do not get affected.
*

    
		General/NSArray *pathsToCheck = General/[NSArray arrayWithObjects:applicationMainFolderPath, applicationDataPath, applicationSecondTestPath, nil];
		// these applicationMainFolderPath and others are instance variables now.
		General/NSString *rootPath = General/[NSSearchPathForDirectoriesInDomains(General/NSLibraryDirectory,General/NSUserDomainMask,YES) objectAtIndex:0];
		
		General/NSEnumerator *enumerator = [pathsToCheck objectEnumerator];
		id aPathToCheck;
		while (aPathToCheck = [enumerator nextObject]){
			aPathToCheck = General/[[[[NSBundle mainBundle] infoDictionary] objectForKey:myInfoPlistKeyForApplicationSupportPath] stringByAppendingPathComponent:aPathToCheck];
			aPathToCheck = [rootPath stringByAppendingPathComponent:aPathToCheck];
			
			// ...
			// Again some checking if the path already exist and otherwise create it
			// ...

			General/NSLog(@"The aPathToCheck is %@", aPathToCheck); // This is the correct -changed- string.
		}
		General/NSLog(@"The pathsToCheck array is %@", pathsToCheck); // But the array still holds the original values.
		General/NSLog(@"my three variables are %@, %@ and %@", applicationMainFolderPath, applicationDataPath, applicationSecondTestPath);
		// Also these variables still have their initial values. How can I have them changed into what aPathToCheck has become?


I hope somebody understands what I try to do and can give me some advice how to go about this. Do I have to retain/release those strings? Where do I do that?

Dirk

----
There are two ways to do this. One way is to make your strings mutable. Doing     aPathToCheck = ... won't influence the original variable, of course, because it's not the same variable.

Another way is to use a C array of pointers to pointers, like so:
    
General/NSString **strings[] = {&string1, &string2, &string3, NULL};
General/NSString **strPtr;
for(int i = 0; strPtr = strings[i]; i++)
{
	*strPtr = [*strPtr stringByAppendingPathComponent:@"HELLO!"];
	...
}

This works because you're actually using a pointer to the original variable, not a copy of the variable.

----
Great, this double pointer thing works! (I needed to take the "int i" out of the for loop, though, for it started complaining about not being in C99 mode) ... I do not really understand what I am doing, but it works! And I guess I cannot use General/NSEnumerator with a C array **strings[], right?

However this doesn't look really like Cocoa to me, so I still want to try the mutable option too. But just using General/NSMutableStrings instead of General/NSStrings also doesn't get the job done. Somehow I have to access these General/NSMutableStrings from within the loop and     aPathToCheck as enumerator is not doing that, I am affraid. What other Cocoa-style options do I have?

Dirk
----
When you have a variable, like     General/NSString *foo, the variable is *not* an General/NSString. It is a *pointer* to General/NSString. This distinction is important. Look at the following code:
    
General/NSMutableString *str1 = @"a";
General/NSMutableString *str2 = str1;
str1 = @"b";
// what does str2 contain now?

The answer to the questions in the comment is that str2 still contains @"a". When you do the assignment, you only change the pointer, not the underlying object. Let's look at some other code:
    
General/NSMutableString *str1 = General/[NSMutableString stringWithString;@"a"];
General/NSMutableString *str2 = str1;
[str1 setString:@"b"];
// what does str2 contain now?

Here, the answer is @"b". The -setString: method doesn't change the pointer, it changes the *object*. Just adding "Mutable" to the class name won't change a thing; you have to change how your code operates.

That said, there's no reason to avoid C arrays in Cocoa when they work.
----
Thanks a lot. I am beginning to grasp this thing with the double pointer. However I am still at loss trying the General/NSMutableString solution.

If I try the beneath code during runtime it raises an exception: Attempt to mutate immutable General/NSString with setString:

    
General/NSArray *pathsToCheck = General/[NSArray arrayWithObjects:applicationMainFolderPath, applicationDataPath, applicationSecondTestPath, nil];
General/NSString *rootPath = General/[NSSearchPathForDirectoriesInDomains(General/NSLibraryDirectory,General/NSUserDomainMask,YES) objectAtIndex:0];

General/NSString *checkThisPath;

General/NSEnumerator *enumerator = [pathsToCheck objectEnumerator];
id aPathToCheck;
while (aPathToCheck = [enumerator nextObject]){
	[aPathToCheck setString:[rootPath stringByAppendingPathComponent:aPathToCheck]];
			
	checkThisPath = General/[NSString stringWithString:aPathToCheck];
	// ... some operation on checkThisPath ...
}
General/NSLog(@"The value of these three variables is: %@, %@, %@", applicationMainFolderPath, applicationDataPath, applicationSecondTestPath);


So how can I access the General/NSMutableString's in the General/NSArray? (I also tried it with     pathsToCheck as a General/NSMutableArray, but that gave me the same exception.) Or can't I use General/NSEnumerator when I want to access the General/NSMutableStrings itself, period?

By the way, I am using the same accessor methods as I used with General/NSString. Is that correct?

    
- (void)setApplicationMainFolderPath:(General/NSMutableString *)newPath
{
	newPath = [newPath copy];
	[applicationMainFolderPath release];
	applicationMainFolderPath = newPath;
}


Again, thanks for all this help.

Dirk
----
For objects that have a mutable/immutable distinction, like General/NSString, sending the -copy message gives you an immutable copy. You want the -mutableCopy message.
----
Ahhh, that explains a lot, seems. With -mutableCopy instead of -copy everything just works smootly. And with using General/NSEnumerator it even looks like Cocoa ;-)