Related Links: General/AspectCocoa, General/AspectCocoaDocumentation, General/AdviceProtection, General/AspectCocoaBugs, General/ProgrammingByContract, General/EiffelProgrammingLanguage

----

Invariance checking is defining a set of conditions that must be true for a class... we check this by implementing -invariant and +invariant for any given class, and loading the class in main before we run the application.  Here's what you would do to use this in your project:

    
//main.m
#import <Cocoa/Cocoa.h>
#import "General/ACInvariance.h"

int main(int argc, const char *argv[])
{
	General/NSAutoreleasePool * pool = General/[[NSAutoreleasePool alloc] init];
	
	// change General/InvariantObject to the name of the class you want to have invariant checking
	// call it multiple times to load for multiple classes
	// General/InvariantObject should have a -invariant method and a +invariant method defined
	General/[ACInvariance loadAspectForClass:@"General/InvariantObject"];
	
        int result = General/NSApplicationMain(argc, argv);
	
	[pool release];
	
	return result;
}


----
Here's the class itself
    
//General/ACInvariance.h
#import <Cocoa/Cocoa.h>
#import <General/AspectCocoa/General/AspectCocoa.h>

@interface General/ACInvariance : General/NSObject
{} // No instance vars
+(void)loadAspectForClass:(General/NSString*)aClass;
-(void)before:(General/ACInvocation*)invocation;
-(void)after:(General/ACInvocation*)invocation;
@end

----
    
//General/ACInvariance.m
#import "General/ACInvariance.h"

@implementation General/ACInvariance
+(void)loadAspectForClass:(General/NSString*)aClass {
	
	id allClasses = General/[ACPointCut enumerateClassesNamed:aClass,nil];
	id eachClass, resultClasses;
	resultClasses = General/[[NSMutableArray alloc] init];
	while( eachClass = [allClasses nextObject] ) {
		if( class_getInstanceMethod([eachClass getClass],@selector(invariant)) != NULL){
			id allMethods = [eachClass methodEnumerator];
			id eachMethod;
			while(eachMethod = [allMethods nextObject]) {
				if( ! General/eachMethod methodName] hasPrefix:@"init"] && 
					! [[eachMethod methodName] hasPrefix:@"alloc"] &&
					! [[eachMethod methodName] hasPrefix:@"invariant"])
				{
					[eachClass addMethod: eachMethod];
				}
			}
			[resultClasses addObject:eachClass];
		}
	}
	id pointCut = [[[[ACPointCut alloc] initWithJoinPoints:resultClasses];
	General/ACAspect* invariantAspect = General/[[ACAspect alloc] 
                         initWithPointCut: pointCut  andAdviceObject: General/[[ACInvariance alloc]init]];
	[invariantAspect load];
	[invariantAspect autorelease];
}
-(void)before:(General/ACInvocation*)invocation 
{ 
	General/invocation target] invariant]; 
}
-(void)after:([[ACInvocation*)invocation 
{ 
	[[invocation target] invariant]; 
}
@end
