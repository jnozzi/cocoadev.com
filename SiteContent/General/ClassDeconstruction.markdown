

**Note: The title of this page is a bit misleading. The actual topic has to do with a small part of introspection. Not class deallocation/destruction and dealloc method semantics.**

The General/ObjC runtime stores a lot of information about a class - namely, all its methods, instance variables, and super-classes. This information is freely available to programmers, and is often more comprehensive than Apple's documentation about its classes, for instance. Did you know that General/NSArray has a method called indexOf:::? I didn't, nor do I know what it does...

Anyway, here's the code that does it all:

    
#import </usr/include/objc/objc-class.h>
#import </usr/include/objc/Protocol.h>
#import <Foundation/Foundation.h>

void General/DeconstructClass(Class aClass)
{
    struct objc_class *class = aClass;
    const char *name = class->name;
    int k;
    void *iterator = 0;
    struct objc_method_list *mlist;

    General/NSLog(@"Deconstructing class %s, version %d",
          name, class->version);
    General/NSLog(@"%s size: %d", name,
          class->instance_size);
    if (class->ivars == nil)
        General/NSLog(@"%s has no instance variables", name);
    else
        {
        General/NSLog(@"%s has %d ivar%c", name,
              class->ivars->ivar_count,
              ((class->ivars->ivar_count == 1)?' ':'s'));
        for (k = 0;
             k < class->ivars->ivar_count;
             k++)
            General/NSLog(@"%s ivar #%d: %s", name, k,
                  class->ivars->ivar_list[k].ivar_name);
        }
    mlist = class_nextMethodList(aClass, &iterator);
    if (mlist == nil)
        General/NSLog(@"%s has no methods", name);
    else do
        {
            for (k = 0; k < mlist->method_count; k++)
                {
                General/NSLog(@"%s implements %@", name,
                      General/NSStringFromSelector(mlist->method_list[k].method_name));
                }
        }
        while ( mlist = class_nextMethodList(aClass, &iterator) );

    if (class->super_class == nil)
        General/NSLog(@"%s has no superclass", name);
    else
        {
        General/NSLog(@"%s superclass: %s", name, class->super_class->name);
        General/DeconstructClass(class->super_class);
        }
}


----

Here is a sample of its talents (on Mac OS X 10.1.3):

    General/DeconstructClass(General/[NSObject class]);
produces:
    
Deconstructing class General/NSObject, version 0
General/NSObject size: 4
General/NSObject has 1 ivar 
General/NSObject ivar #0: isa
General/NSObject implements _conformsToProtocolNamed:
General/NSObject implements replacementObjectForPortCoder:
General/NSObject implements classForPortCoder
General/NSObject implements _cfTypeID
General/NSObject implements methodFor:
General/NSObject implements conformsTo:
General/NSObject implements respondsTo:
General/NSObject implements isKindOf:
General/NSObject implements forward::
General/NSObject implements isNSIDispatchProxy
General/NSObject implements replacementObjectForArchiver:
General/NSObject implements classForArchiver
General/NSObject implements performSelector:withObject:afterDelay:inModes:
General/NSObject implements performSelector:object:afterDelay:
General/NSObject implements performSelector:withObject:afterDelay:
General/NSObject implements coerceValue:forKey:
General/NSObject implements removeValueAtIndex:fromPropertyWithKey:
General/NSObject implements insertValue:atIndex:inPropertyWithKey:
General/NSObject implements replaceValueAtIndex:inPropertyWithKey:withValue:
General/NSObject implements valueWithUniqueID:inPropertyWithKey:
General/NSObject implements valueWithName:inPropertyWithKey:
General/NSObject implements valueAtIndex:inPropertyWithKey:
General/NSObject implements classCode
General/NSObject implements className
General/NSObject implements objectSpecifier
General/NSObject implements isCaseInsensitiveLike:
General/NSObject implements isLike:
General/NSObject implements doesContain:
General/NSObject implements isGreaterThan:
General/NSObject implements isGreaterThanOrEqualTo:
General/NSObject implements isLessThan:
General/NSObject implements isLessThanOrEqualTo:
General/NSObject implements isNotEqualTo:
General/NSObject implements isEqualTo:
General/NSObject implements removeObject:fromBothSidesOfRelationshipWithKey:
General/NSObject implements addObject:toBothSidesOfRelationshipWithKey:
General/NSObject implements _setObject:forBothSidesOfRelationshipWithKey:
General/NSObject implements removeObject:fromPropertyWithKey:
General/NSObject implements addObject:toPropertyWithKey:
General/NSObject implements clearProperties
General/NSObject implements allPropertyKeys
General/NSObject implements isToManyKey:
General/NSObject implements validateTakeValue:forKeyPath:
General/NSObject implements validateValue:forKey:
General/NSObject implements classDescriptionForDestinationKey:
General/NSObject implements ownsDestinationObjectsForRelationshipKey:
General/NSObject implements inverseForRelationshipKey:
General/NSObject implements toManyRelationshipKeys
General/NSObject implements toOneRelationshipKeys
General/NSObject implements attributeKeys
General/NSObject implements entityName
General/NSObject implements classDescription
General/NSObject implements createKeyValueBindingForKey:typeMask:
General/NSObject implements _createKeyValueBindingForKey:name:bindingType:
General/NSObject implements flushKeyBindings
General/NSObject implements keyValueBindingForKey:typeMask:
General/NSObject implements takeStoredValue:forKey:
General/NSObject implements takeValue:forKey:
General/NSObject implements storedValueForKey:
General/NSObject implements valueForKey:
General/NSObject implements unableToSetNilForKey:
General/NSObject implements handleTakeValue:forUnboundKey:
General/NSObject implements handleQueryWithUnboundKey:
General/NSObject implements takeStoredValuesFromDictionary:
General/NSObject implements takeValuesFromDictionary:
General/NSObject implements valuesForKeys:
General/NSObject implements takeValue:forKeyPath:
General/NSObject implements valueForKeyPath:
General/NSObject implements perform:withEachObjectInArray:
General/NSObject implements implementsSelector:
General/NSObject implements methodForSelector:
General/NSObject implements doesNotRecognizeSelector:
General/NSObject implements replacementObjectForCoder:
General/NSObject implements classForCoder
General/NSObject implements awakeAfterUsingCoder:
General/NSObject implements performv::
General/NSObject implements forwardInvocation:
General/NSObject implements methodSignatureForSelector:
General/NSObject implements forward::
General/NSObject implements methodDescriptionForSelector:
General/NSObject implements mutableCopy
General/NSObject implements init
General/NSObject implements dealloc
General/NSObject implements copy
General/NSObject implements zone
General/NSObject implements superclass
General/NSObject implements self
General/NSObject implements retainCount
General/NSObject implements retain
General/NSObject implements respondsToSelector:
General/NSObject implements release
General/NSObject implements performSelector:withObject:withObject:
General/NSObject implements performSelector:withObject:
General/NSObject implements performSelector:
General/NSObject implements isProxy
General/NSObject implements isFault
General/NSObject implements isMemberOfClass:
General/NSObject implements isKindOfClass:
General/NSObject implements isEqual:
General/NSObject implements hash
General/NSObject implements _copyDescription
General/NSObject implements debugDescription
General/NSObject implements description
General/NSObject implements conformsToProtocol:
General/NSObject implements class
General/NSObject implements autorelease
General/NSObject has no superclass


----

Anybody have any luck making this work in 10.3? It just General/SIGBUSs on me at class_nextMethodList.

OSX 10.3.4 with General/XCode 1.5 works like a charm.

----

Thats as very cool function! With a couple of trivial modifications it becomes a Category that you makes all objects able to deconstruct themselves:

**
General/ClassDeconstruction.h
**
    
#import <Cocoa/Cocoa.h>

@interface General/NSObject (General/ClassDeconstruction)

- (void)deconstruct;
- (void)deconstruct: (Class)aClass;

@end


**
General/ClassDeconstruction.m
**
    
#import "General/ClassDeconstruction.h"
#import </usr/include/objc/objc-class.h>
#import </usr/include/objc/Protocol.h>
#import <Foundation/Foundation.h>

@implementation General/NSObject (General/ClassDeconstruction)

- (void)deconstruct;
{
    [self deconstruct: [self class]];
}

- (void)deconstruct: (Class)aClass;
{
    struct objc_class *class = aClass;
    const char *name = class->name;
    int k;
    void *iterator = 0;
    struct objc_method_list *mlist;
    
    General/NSLog(@"Deconstructing class %s, version %d",
          name, class->version);
    General/NSLog(@"%s size: %d", name,
          class->instance_size);
    if (class->ivars == nil)
        General/NSLog(@"%s has no instance variables", name);
    else
    {
        General/NSLog(@"%s has %d ivar%c", name,
              class->ivars->ivar_count,
              ((class->ivars->ivar_count == 1)?' ':'s'));
        for (k = 0;
             k < class->ivars->ivar_count;
             k++)
            General/NSLog(@"%s ivar #%d: %s", name, k,
                  class->ivars->ivar_list[k].ivar_name);
    }
    mlist = class_nextMethodList(aClass, &iterator);
    if (mlist == nil)
        General/NSLog(@"%s has no methods", name);
    else do
    {
        for (k = 0; k < mlist->method_count; k++)
        {
            General/NSLog(@"%s implements %@", name,
                  General/NSStringFromSelector(mlist->method_list[k].method_name));
        }
    }
        while ( mlist = class_nextMethodList(aClass, &iterator) );
    
    if (class->super_class == nil)
        General/NSLog(@"%s has no superclass", name);
    else
    {
        General/NSLog(@"%s superclass: %s", name, class->super_class->name);
        [self deconstruct: class->super_class];
    }
}

@end


Then use the category method like this: <code>[self deconstruct];</code>


----

I used the code below at some point. Not as clean as above, but can be useful too (there is more done with ivars, and some info about the method signatures). Sorry I am too lazy to make it a category right now (and I don't want to break what works...). --General/CharlesParnot

    

**General/TFUtilities.h**

#import <Foundation/Foundation.h>
@interface General/TFUtilities : General/NSObject {}
+ (General/NSArray *)methodsOfObject:(id)anObject classObject:(BOOL)flag;
+ (General/NSArray *)ivarsOfObject:(id)anObject classObject:(BOOL)flag;
+ (General/NSString *)describeObject:(id)anObject classObject:(BOOL)flag;
@end


**General/TFUtilities.m**
#import "General/TFUtilities.h"
#import <objc/objc.h>
#import <objc/objc-class.h>
#import <objc/objc-runtime.h>

static General/NSString* General/TFMethodNameKey=@"method_name";
static General/NSString* General/TFMethodTypesKey=@"method_types";
static General/NSString* General/TFIvarNameKey=@"ivar_name";
static General/NSString* General/TFIvarTypeKey=@"ivar_type";
static General/NSString* General/TFIvarOffsetKey=@"ivar_offset";
static General/NSString* General/TFIvarObjectKey=@"ivar_object";

@implementation General/TFUtilities


//returns an General/NSArray of General/NSDictionary
//each item in the array = 1 ivar
//dictionary = description of the ivar
+ (General/NSArray *)ivarsOfObject:(id)anObject classObject:(BOOL)flag
{	
	General/NSMutableArray *ivars;
	General/NSDictionary *info;
	General/NSString *name,*type;
	int i,n;
	struct objc_class *class;
	struct objc_ivar_list* ivar_list_struct;
	struct objc_ivar *ivar_list;
	struct objc_ivar ivar;
	id ivarObject;
	
	if (anObject==nil)
		return General/[NSArray array];
	
	//get the objc_ivar_list
	if (flag)
		class=anObject;
	else
		class=[anObject class];
	ivar_list_struct=(*class).ivars;
	if (ivar_list_struct==NULL)
		return General/[NSArray array];
	n=ivar_list_struct->ivar_count;
	ivar_list=ivar_list_struct->ivar_list;
	ivars=General/[NSMutableArray arrayWithCapacity:n];
	
	//get the ivars info
	for (i=0;i<n;i++) {
		ivar=ivar_list[i];
		name=General/[NSString stringWithCString:ivar.ivar_name];
		type=General/[NSString stringWithCString:ivar.ivar_type];

		if(!flag && General/type substringToIndex:1] isEqualToString:@"@"])
			object_getInstanceVariable(anObject,ivar.ivar_name,(void **)&ivarObject);
		else
			ivarObject=[[[NSNull null];
		info=General/[NSDictionary dictionaryWithObjectsAndKeys:
			name,General/TFIvarNameKey,
			type,General/TFIvarTypeKey,
			General/[NSNumber numberWithInt:ivar.ivar_offset],General/TFIvarOffsetKey,
			ivarObject,General/TFIvarObjectKey,
			nil];
		[ivars addObject:info];
	}
	
	return General/ivars copy] autorelease];
}

//returns an [[NSArray of General/NSDictionary
//each item in the array = 1 method
//dictionary = description of the method
+ (General/NSArray *)methodsOfObject:(id)anObject classObject:(BOOL)flag
{	
	General/NSMutableArray *methods;
	General/NSDictionary *info;
	int i,n;
	struct objc_class *class;
	struct objc_method *method;
	void *iterator = 0;
	struct objc_method_list *methodList;
	
	if (anObject==nil)
		return General/[NSArray array];
	if (flag)
		class=anObject;
	else
		class=[anObject class];
	
	//count methods
	n=0;
	while( methodList = class_nextMethodList(class, &iterator ) )
		n+=(*methodList).method_count;
	methods=General/[NSMutableArray arrayWithCapacity:n];
	
	//retrieve method info
	while( methodList = class_nextMethodList([anObject class], &iterator ) ) {
		n=(*methodList).method_count;
		for (i=0;i<n;i++) {
			method=(*methodList).method_list + i;
			info=General/[NSDictionary dictionaryWithObjectsAndKeys:
				General/NSStringFromSelector(method->method_name),General/TFMethodNameKey,
				General/[NSString stringWithCString:method->method_types],General/TFMethodTypesKey,
				nil];
			[methods addObject:info];
		}
	}
	return General/methods copy] autorelease];
}

+ ([[NSString *)describeObject:(id)anObject classObject:(BOOL)flag
{
	General/NSEnumerator *e;
	General/NSDictionary *dico;
	id class,sup;
	General/NSArray *classMethods,*methods,*ivars;
	General/NSMutableString *description=General/[NSMutableString string];
	
	
	//initializations
	if (flag)
		class=anObject;
	else
		class=[anObject class];
	id metaclass=objc_getMetaClass(General/[NSStringFromClass(class) UTF8String]);
	classMethods=[self methodsOfObject:metaclass classObject:YES];
	methods=[self methodsOfObject:anObject classObject:flag];
	ivars=[self ivarsOfObject:anObject classObject:flag];
	
	//class and superclasses
	[description appendString:General/[NSString stringWithFormat:@"\n%@object <%@:%p>\n",
		(flag?@"class ":@""),class,anObject]];
	[description appendString:@"\n"];
	[description appendString:General/[NSString stringWithFormat:@"description:\n%@\n",anObject]];
	[description appendString:@"\n"];
	[description appendString:General/[NSString stringWithFormat:@"class: %@\n",class]];
	sup=[class superclass];
	[description appendString:General/[NSString stringWithFormat:@"super1: %@\n",sup]];
	sup=[sup superclass];
	[description appendString:General/[NSString stringWithFormat:@"super2: %@\n",sup]];
	sup=[sup superclass];
	[description appendString:General/[NSString stringWithFormat:@"super3: %@\n",sup]];
	sup=[sup superclass];
	[description appendString:General/[NSString stringWithFormat:@"super4: %@\n",sup]];
	sup=[sup superclass];
	[description appendString:General/[NSString stringWithFormat:@"super5: %@\n",sup]];
	
	//methods
	[description appendString:@"\n"];
	[description appendString:@"class methods:\n"];
	e=[classMethods objectEnumerator];
	while (dico=[e nextObject])
		[description appendFormat:@"   %@ (%@)\n",
			[dico objectForKey:General/TFMethodNameKey],[dico objectForKey:General/TFMethodTypesKey]];
	[description appendString:@"\n"];
	[description appendString:@"instance methods:\n"];
	e=[methods objectEnumerator];
	while (dico=[e nextObject])
		[description appendFormat:@"   %@ (%@)\n",
			[dico objectForKey:General/TFMethodNameKey],[dico objectForKey:General/TFMethodTypesKey]];
	
	//ivars
	[description appendString:@"\n"];
	[description appendString:@"ivars:\n"];
	e=[ivars objectEnumerator];
	while (dico=[e nextObject]) {
		[description appendFormat:@"   %@   = %@ at offset %@\n",
			[dico objectForKey:General/TFIvarNameKey],
			[dico objectForKey:General/TFIvarTypeKey],
			[dico objectForKey:General/TFIvarOffsetKey]];
		/*
		id ivarObject=[dico objectForKey:General/TFIvarObjectKey];
		if (ivarObject!=General/[NSNull null])
			[description appendFormat:@"      object=<%@:%p>\n",[ivarObject class],ivarObject];
		 */
	}
	
	[description appendString:@"\n\n"];
	return General/[NSString stringWithString:description];
}
@end

