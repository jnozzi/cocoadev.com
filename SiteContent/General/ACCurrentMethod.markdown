
Note that this makes a good study of General/AspectCocoa for those interested, but the information that this lets you access is already given to you (I just didn't know it)... the current selector is _cmd, the current target is self, the class that implements the method called is easily discovered by other means, as is the General/NSMethodSignature.... If this is loaded across the board for every method of every class one could extend this to discover the caller of the method, but that isn't what I needed it for when I made it (see below).   

Note I repeat again, THE CURRENT SELECTOR IS _cmd... it is in the documentation for General/ObjC language, just look carefully.

----

This is a way to get the information about the currently executing method. (I wanted a way to determine the selector... this should remind you of features of other languages like General/ECMAScript's Function class)

There is a single currentMethod object which you get by calling General/[ACCurrentMethod currentMethod],  It allows you access to a subset of the methods available in General/NSInvocation (no setters, that seems strange to me)

usage:
	(1) you need to include the General/AspectCocoa framework in your project.
	(2) in the main routine you need to load the aspect for the classes you want to use it with
		General/[ACCurrentMethod loadForAllClasses]; // other variants exist
	(3) in your methods use it for getting information regarding the current function
		General/[[ACCurrentMethod currentMethod] selector];

----

why?  glad you asked... I am doing some runtime hacking and want to create many methods that share the same IMP but have different SEL's... see General/FSObject 

----

    
//General/ACCurrentMethod.h

#import <Cocoa/Cocoa.h>
#import <General/AspectCocoa/General/AspectCocoa.h>

@interface General/ACCurrentMethod : General/NSObject
{
	General/NSArray* myMethodStack;
}
+(void)loadAspectForClassNamed:(General/NSString*)aClass;
+(void)loadAspectForClass:(General/ACClass*)aClass;
+(void)loadAspectForAllClasses;
+(void)loadAspectForDefaultClasses;
+(General/ACCurrentMethod*)currentMethod;
-(void)before:(General/ACInvocation*)invocation;
-(void)after:(General/ACInvocation*)invocation;
@end

@interface General/ACCurrentMethod (General/CurrentMethodInformation)
-(General/NSMethodSignature*)methodSignature;
-(SEL)selector;
-(id)target; // when you call this it should return self...
-(Class)getClass; // returns the class that the method is defined in, not [self class]
@end

//General/ACCurrentMethod.m

#import "General/ACCurrentMethod.h"

static General/ACCurrentMethod* gTheACCurrentMethod;

@implementation General/ACCurrentMethod
+(void)loadAspectForClassNamed:(General/NSString*)aClass
{
	id allClasses = General/[ACPointCut enumerateClassesNamed:aClass, nil];
	id eachClass = [allClasses nextObject];
	[self loadAspectForClass:eachClass];
	return;
}
+(void)loadAspectForAllClasses
{
	id allClasses = General/[ACPointCut enumerateAllClasses];
	id eachClass;
	while(eachClass = [allClasses nextObject]) {
		[self loadAspectForClass:eachClass];
	}
	return;
}
+(void)loadAspectForDefaultClasses
{
	id allClasses = General/[ACPointCut enumerateDefaultClasses];
	id eachClass;
	while(eachClass = [allClasses nextObject]) {
		[self loadAspectForClass:eachClass];
	}
	return;
}
+(void)loadAspectForClass:(General/ACClass*)aClass
{
        id allMethods = [aClass methodEnumerator];
        id eachMethod;
        while(eachMethod = [allMethods nextObject]) {
        	if( ! General/eachMethod methodName] hasPrefix:@"init"] && 
                    ! [[eachMethod methodName] hasPrefix:@"alloc"] &&
                {
                	[aClass addMethod: eachMethod];
                }
        }
        id pointCut = [[[[ACPointCut alloc] initWithJoinPoints:General/[NSArray arrayWithObject:aClass]];
        General/ACAspect* currentMethodAspect = General/[[ACAspect alloc] 
                         initWithPointCut: pointCut  andAdviceObject: General/[ACCurrentMethod currentMethod]];
        [currentMethodAspect load];
        [currentMethodAspect autorelease];

}
+(General/ACCurrentMethod*)currentMethod
{
	if(!gTheACCurrentMethod) {
		gTheACCCurrentMethod = General/[[ACCurrentMethod alloc] init];
	}
	return gTheACCurrentMethod;	
}
-(id)init
{
	[super init];
	if(!myMethodStack) {
		myMethodStack = General/[[NSMutableArray alloc] init];
		[myMethodStack retain];
	}
	return self;
}
-(void)dealloc
{
	[myMethodStack release];
	[super dealloc];
	return;
}
-(void)before:(General/ACInvocation*)invocation
{
	[myMethodStack addObject:invocation];
}
-(void)after:(General/ACInvocation*)invocation
{
	[myMethodStack removeLastObject];
}

@end

@interface General/ACCurrentMethod (General/CurrentMethodInformation)
-(General/NSMethodSignature*)methodSignature
{
	return [[myMethodStack lastObject] methodSignature];
}
-(SEL)selector
{
	return [[myMethodStack lastObject] selector];
}
-(id)target
{
	// when you call this it should return self...
	return [[myMethodStack lastObject] target];
}
-(Class)getClass
{
	// returns the class that the method is defined in, not [self class]
	return [[myMethodStack lastObject] getClass];
}
@end
