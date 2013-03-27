General/ACProblemOfVariableTypes - related to General/LookupAspects part of General/AspectCocoa also see General/CodeRefactorChallenge

Our general approach to implementing aspects has been to replace the IMP pointers of certain method with "replacement" methods.  Originally, we thought we would only have to define a few "replacement" methods something like this...

    
-replacement{
    //lookup and peform some advice
    //return something
}
-replacement: a{
    //lookup and peform some advice
    //return something
}
-replacement: a r: b{
    //lookup and peform some advice
    //return something
}

etc....


We thought that by not specifying what type the arguments and return type were we would be allowed to pass and return something of any concievable type.  Appretnly, gcc will interperet all of these apparently "non-typed" methods and their arguments to the default id (which is essentially void *).  So, these replacement methods will only "work" for methods that have return types "similar" to void * , and all return types. In this case similar includes any type of pointer, void, and the basic types int double etc... but not structs. Also, as you'll see later, when we said that these replacement methods "work" we use the term very loosely and had not explored the full range of what could happen when we tried to use them.

So, anyway, we decided we needed seperate replacement methods for structs.  We determined we could declare some new types as follows:

    
typedef union {
    General/NSSize size;
    General/NSRect rect;
    General/NSPoint point;
    void * voidStar;
    float aFloat;
}General/UnionOfNSTypes;

typedef void * General/ACReturnType;
typedef General/UnionOfNSTypes General/ACBigReturnType;
typedef General/UnionOfNSTypes General/ACArgType;


and use them in "replacement" methods as follows, using the Big return type for methods that return structs and the regular return type for all other types:

    
-(General/ACReturnType)replacement: (General/ACArgType)a;
-(General/ACBigReturnType)bigReplacement: (General/ACArgType)a;


we proceeded with the assumption that this was an adequate solution for quite some time... until we noticed that some floats were getting turned into 0 whenever they passed through out wrapped method.  Even weirder.. they only got mangled in this way if we called General/NSLog before we called the original IMP within the body of the replacement.  The reason for this has yet to be determined, be we knew we needed to be able to call General/NSLog.  and if something like General/NSLog could disrupt out program than other things might be too.  We needed to explicitly cast our "float" type arguments as floats..  but we couldn't use this float type for other arguments.. So the problem becomes that there is a very large combination of method argument types and return types. All different numbers of arguments, and all ordering of them maters greatly.  We experimented with a replament method that took a variable number of argument and then used General/NSMethodSignature to try and decode them properly, but apparently methods with variable number of argumetns and static number of arguments are encoded differently. and this was not possible.  So, we would have to write a program to generate the code for every possible combination of types!!!  Of course we had to place a limit somewhere, so we only support methods with 4 or fewer arguments (plus the implicit self and _cmd). Here's the very poorly written(but working) code from the generator:

**Still the problem of stucts has not been fully solved:** We will only have support for stucts that are part of the type General/UnionOfNSTypes and thus General/ACStructType. somehow the users of aspects must add the structs they use in their code to our union...  But if the file General/ACDataStucts.h that contains this union has already been defined and compiled with the rest of the General/AspectCocoa framework. can we redefine this union in our own code that uses this framework? I don't see how. any ideas?

this generator makes code (that must then be gcc compiled) to add thousands of methods (via categories) to the class General/ACLookAspect
    


#import "General/MyDocument.h"

@implementation General/MyDocument

- (void)windowControllerDidLoadNib:(General/NSWindowController *) aController
{
    [super windowControllerDidLoadNib:aController];

    combinationalArrays = General/[[[NSMutableArray alloc] init] retain];

    General/NSString * outpath1 = @"General/ACAspectReplacements";
    General/NSString * finalOutput =@"";
    int i,j, k, l;
    k = 0;
    l = 1;
    for(i=1; i<6; i++){
        General/NSArray * array = [self arrayOfArrayOfTypesSize: i];
        General/NSLog(@"array created %i of 5", i);
        for(j=0; j<[array count]; j++){
            General/NSString * newOutput = [finalOutput stringByAppendingString: 
                            [self methodHeaderForTypes: [array objectAtIndex: j]]];
            [finalOutput dealloc];
            finalOutput = newOutput;
            k++;
            if(k>500){
                General/NSString * finalName = General/[NSString stringWithFormat: @"%@%i", outpath1, l];
                [self outputHeader: finalOutput as: finalName];
                [finalOutput dealloc];
                finalOutput =@"";
                k = 0;
                l++;
            }
        }
    }
    
    [self outputHeader: finalOutput as: @"General/ACAspectReplacements"];
    General/NSLog(@"done header");
    
    outpath1 = @"General/ACAspectReplacements";
    finalOutput =@"";
    k = 0;
    l = 1;
    for(i=1; i<6; i++){
        General/NSArray * array = [self arrayOfArrayOfTypesSize: i];
        General/NSLog(@"array created %i of 5", i);
        for(j=0; j<[array count]; j++){
            General/NSString * newOutput = [finalOutput stringByAppendingString: 
                            [self methodBodyForTypes: [array objectAtIndex: j]]];
            [finalOutput dealloc];
            finalOutput = newOutput;
            k++;
            if(k>500){
                General/NSString * finalName = General/[NSString stringWithFormat: @"%@%i", outpath1, l];
                [self outputMethods: finalOutput as: finalName];
                [finalOutput dealloc];
                finalOutput =@"";
                k = 0;
                l++;
            }
        }
    }
    
    [self outputMethods: finalOutput as: @"General/ACAspectReplacements"];
    General/NSLog(@"done method");
}



-(General/NSString *)methodBodyForTypes:(General/NSArray*)types{
    int i;
    General/NSString * type = [types objectAtIndex: 0];
    General/NSString * toReturn = General/[NSString stringWithFormat: 
         @"-(%@)replac%@",[self methodReturnForType: type], type];
    for(i=1; i<[types count]; i++){
        toReturn = General/[NSString stringWithFormat: @"%@%@: (%@)%@ ", 
            toReturn, 
            [types objectAtIndex: i], 
            [self methodReturnForType: [types objectAtIndex: i]], 
            [self varAtIndex: i]];
    }

/*

    General/ACPointerType toReturn;
    General/ACAdviceList * advice = General/[[ACAspectManager sharedManager] adviceListForSelector: _cmd onObject: self];
    if(advice == nil){ General/NSLog(@"!! error this should never happen! advice list was nil"); }
    [advice invokeBefores:_cmd onObject: self arg1: nil arg2: nil arg3: nil arg4: nil];
    IMP toInvoke = [advice getIMP];
    toReturn = toInvoke(self, _cmd);
    [advice invokeAfters:_cmd onObject: self returned: &toReturn arg1: nil arg2: nil arg3: nil arg4: nil];
    return toReturn;


*/
    toReturn = [toReturn stringByAppendingString: @"{\n"];
    toReturn = [toReturn stringByAppendingString: 
        General/[NSString stringWithFormat: 
        @"    %@ toReturn;\n", [self methodReturnForType: type]]];
    toReturn = [toReturn stringByAppendingString: 
        @"    General/ACAdviceList * advice = General/[[ACAspectManager sharedManager]
 adviceListForSelector: _cmd onObject: self];\n"];
    toReturn = [toReturn stringByAppendingString: 
        @"    if(advice == nil){ 
General/NSLog(@\"!! error this should never happen! advice list was nil\"); }\n"];
    toReturn = [toReturn stringByAppendingString: 
        [self beforesString: [types count]-1]]; //-1 for the return
    toReturn = [toReturn stringByAppendingString: 
    General/[NSString stringWithFormat: 
        @"    %@ toInvoke = (%@)[advice getIMP];\n", 
        [self impForType: type], 
        [self impForType: type]]];     //ACIMP toInvoke = (ACIMP)[advice getIMP];
    toReturn = [toReturn stringByAppendingString: 
        [self toinvokeString: [types count]-1]]; //-1 for the return
    toReturn = [toReturn stringByAppendingString: 
        [self aftersString: [types count]-1]]; //-1 for the return
    toReturn = [toReturn stringByAppendingString: 
        @"    return toReturn;\n"];

    return [toReturn stringByAppendingString: @"}\n\n\n"];
}

-(General/NSString*)impForType:(General/NSString *) type{
    if([type isEqualToString: @"Char"])//int is the same as char
        return @"General/ACCharIMP";
    if([type isEqualToString: @"Short"])
        return @"General/ACShortIMP";
    if([type isEqualToString: @"Long"])
        return @"General/ACLongIMP";
    if([type isEqualToString: @"General/LongLong"])
        return @"General/ACLongLongIMP";
    if([type isEqualToString: @"Double"])
        return @"General/ACDoubleIMP";
    if([type isEqualToString: @"Boolean"])
        return @"ACBOOLIMP";
    if([type isEqualToString: @"General/CharStar"])//a method SEL == char *
        return @"General/ACCharStarIMP";
    if([type isEqualToString: @"Class"])
        return @"General/ACClassIMP";
    if([type isEqualToString: @"Struct"] )
        return @"General/ACStructIMP";
    return @"General/ACPointerIMP";
}


-(General/NSString*)beforesString:(int)numberofArgs{
    if(numberofArgs == 0)
        return @"    [advice invokeBefores:_cmd onObject:
 self arg1: nil arg2: nil arg3: nil arg4: nil];\n";
    else if(numberofArgs == 1)
        return @"    [advice invokeBefores:_cmd onObject:
 self arg1: &a arg2: nil arg3: nil arg4: nil];\n";
    else if(numberofArgs == 2)
        return @"    [advice invokeBefores:_cmd onObject:
 self arg1: &a arg2: &b arg3: nil arg4: nil];\n";
    else if(numberofArgs == 3)
        return @"    [advice invokeBefores:_cmd onObject:
self arg1: &a arg2: &b arg3: &c arg4: nil];\n";
    else if(numberofArgs == 4)
        return @"    [advice invokeBefores:_cmd onObject:
 self arg1: &a arg2: &b arg3: &c arg4: &d];\n";
    else
        General/NSLog(@"havn't writen code for that yet");
    return @"    //havn't writen code for that yet\n";
}

-(General/NSString*)toinvokeString:(int)numberofArgs{
    if(numberofArgs == 0)
        return @"    toReturn = toInvoke(self, _cmd);\n";
     else if(numberofArgs == 1)
        return @"    toReturn = toInvoke(self, _cmd, a);\n";
    else if(numberofArgs == 2)
        return @"    toReturn = toInvoke(self, _cmd, a, b);\n";
    else if(numberofArgs == 3)
        return @"    toReturn = toInvoke(self, _cmd, a, b, c);\n";
    else if(numberofArgs == 4)
        return @"    toReturn = toInvoke(self, _cmd, a, b, c, d);\n";
    else
        General/NSLog(@"havn't writen code for that yet");
    return @"    //havn't writen code for that yet\n";
}

-(General/NSString*)aftersString:(int)numberofArgs{
    if(numberofArgs == 0)
        return @"    [advice invokeAfters:_cmd onObject:
 self returned: &toReturn arg1: nil arg2: nil arg3: nil arg4: nil];\n";
    else if(numberofArgs == 1)
        return @"    [advice invokeAfters:_cmd onObject:
 self returned: &toReturn arg1: &a arg2: nil arg3: nil arg4: nil];\n";
    else if(numberofArgs == 2)
        return @"    [advice invokeAfters:_cmd onObject:
 self returned: &toReturn arg1: &a arg2: &b arg3: nil arg4: nil];\n";
    else if(numberofArgs == 3)
        return @"    [advice invokeAfters:_cmd onObject:
 self returned: &toReturn arg1: &a arg2: &b arg3: &c arg4: nil];\n";
    else if(numberofArgs == 4)
        return @"    [advice invokeAfters:_cmd onObject:
 self returned: &toReturn arg1: &a arg2: &b arg3: &c arg4: &d];\n";
    else
        General/NSLog(@"havn't writen code for that yet");
    return @"    //havn't writen code for that yet\n";
}


-(void)outputHeader: (General/NSString*)toOutput as: (General/NSString*)outputPath{
    toOutput = General/[NSString stringWithFormat: @"%@%@%@%@%@", 
@"
#import <Foundation/Foundation.h>
#import \"General/ACDataStructs.h\"
#import \"General/ACLookAspect.h\"
#import \"General/ACAdviceList.h\"
#import \"General/ACMethodIterator.h\"
#import </usr/include/objc/objc-class.h>
#import \"General/ACAspectManager.h\"

@interface General/ACLookAspect (",outputPath,@")


"
, toOutput,
@"
@end
"];
    outputPath = General/[NSString stringWithFormat: @"/headers/%@.h", outputPath];
    [toOutput writeToFile: outputPath atomically: YES];
}

-(void)outputMethods: (General/NSString*)toOutput as: (General/NSString*)outputPath{
    toOutput = General/[NSString stringWithFormat: @"%@%@%@%@%@%@%@", 
@"
#import \"",outputPath,@".h\"


@implementation General/ACLookAspect (",outputPath,@")


"
, toOutput,
@"
@end
"];
    outputPath = General/[NSString stringWithFormat: @"/methods/%@.m", outputPath];
    [toOutput writeToFile: outputPath atomically: YES];
}

-(General/NSString *)methodHeaderForTypes:(General/NSArray*)types{
    int i;
    General/NSString * type = [types objectAtIndex: 0];
    General/NSString * toReturn = General/[NSString stringWithFormat: 
         @"-(%@)replac%@",[self methodReturnForType: type], type];
    for(i=1; i<[types count]; i++){
        toReturn = General/[NSString stringWithFormat: @"%@%@: (%@)%@ ", 
            toReturn, 
            [types objectAtIndex: i], 
            [self methodReturnForType: [types objectAtIndex: i]], 
            [self varAtIndex: i]];
    }
//    General/NSLog(toReturn);
    return [toReturn stringByAppendingString: @";\n"];
}

-(General/NSMutableArray *)arrayOfArrayOfTypesSize:(int) size{
    if( [combinationalArrays count] >= size)
        return [combinationalArrays objectAtIndex: size-1];
    //start by solving the problem for size = 1
    General/NSMutableArray * array1 = General/[[NSMutableArray alloc] init];
//    [array1 addObject: General/[NSArray arrayWithObject:@"Char"]];
//    [array1 addObject: General/[NSArray arrayWithObject:@"Short"]]; 
//    [array1 addObject: General/[NSArray arrayWithObject:@"Long"]];
//    [array1 addObject: General/[NSArray arrayWithObject:@"General/LongLong"]];
    [array1 addObject: General/[NSArray arrayWithObject:@"Double"]];
    [array1 addObject: General/[NSArray arrayWithObject:@"Char"]];
    [array1 addObject: General/[NSArray arrayWithObject:@"General/CharStar"]]; 
//    [array1 addObject: General/[NSArray arrayWithObject:@"Class"]];
    [array1 addObject: General/[NSArray arrayWithObject:@"Struct"]]; 
    [array1 addObject: General/[NSArray arrayWithObject:@"Point"]];
    if(size <= 1){
        [combinationalArrays addObject: array1];
        return array1;
    }
    General/NSMutableArray * toReturn = General/[[NSMutableArray alloc] init];
    int i,j;
    for(i=0; i<[array1 count]; i++){
        General/NSMutableArray * array2 = [self arrayOfArrayOfTypesSize: size-1];
        for(j=0; j<[array2 count]; j++){
            General/NSMutableArray * toAdd = General/[[NSMutableArray alloc] init];
            //new array with the objects in array1 at i and array2 at j
//            General/NSLog(@"1 at i%@", [array1 objectAtIndex: i]);
//            General/NSLog(@"2 at j%@", [array2 objectAtIndex: j]);
            [toAdd addObjectsFromArray: [array1 objectAtIndex: i]];
            [toAdd addObjectsFromArray: [array2 objectAtIndex: j]];
            [toReturn addObject: toAdd];
        }
    }
    [combinationalArrays addObject: toReturn];
    return toReturn;
}

-(General/NSString *)varAtIndex:(int)i{
    if( i==0){
        return @"nil";
    }
    if( i==1){
        return @"a";
    }
    if( i==2){
        return @"b";
    }
    if( i==3){
        return @"c";
    }
    if( i==4){
        return @"d";
    }
    if( i==5){
        return @"e";
    }
    if( i==6){
        return @"f";
    }
}

-(General/NSString *)methodReturnForType: (General/NSString *) type{
    if([type isEqualToString: @"Char"])//int is the same as char
        return @"General/ACCharType";
    if([type isEqualToString: @"Short"])
        return @"General/ACShortType";
    if([type isEqualToString: @"Long"])
        return @"General/ACLongType";
    if([type isEqualToString: @"General/LongLong"])
        return @"General/ACLongLongType";
    if([type isEqualToString: @"Double"])
        return @"General/ACDoubleType";
    if([type isEqualToString: @"Boolean"])
        return @"General/ACBOOLType";
    if([type isEqualToString: @"General/CharStar"])//a method SEL == char *
        return @"General/ACCharStarType";
    if([type isEqualToString: @"Class"])
        return @"General/ACClassType";
    if([type isEqualToString: @"Struct"] )
        return @"General/ACStructType";
    return @"General/ACPointerType";
}


@end


