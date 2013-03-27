General/CodeRefactorChallenge - the solving of this problem is specicifically related to improving the size of General/AspectCocoa.

I challenge any developer to succesfully refactor the following code into shorter methods (and thus, a presumably smaller compiled size)
It all looks very repetetive, so there should be some way to condense it...  right?

it seems the solution may be to completely rework General/AspectCocoa, like this: General/ForwardInvocationAspect
    

typedef union {
    General/NSSize size;
    General/NSRect rect;
    General/NSPoint point;
    General/NSRange range;
}General/UnionOfNSTypes;

typedef double General/ACDoubleType;
typedef char General/ACCharType;
typedef void * General/ACPointerType;
typedef General/UnionOfNSTypes General/ACStructType;
typedef char * General/ACCharStarType;
//typedef BOOL General/ACBOOLType; //same as char

typedef General/ACDoubleType (*General/ACDoubleIMP)(id, SEL, ...);
typedef General/ACCharType (*General/ACCharIMP)(id, SEL, ...);
typedef General/ACPointerType (*General/ACPointerIMP)(id, SEL, ...);
typedef General/ACStructType (*General/ACStructIMP)(id, SEL, ...);
typedef General/ACCharStarType (*General/ACCharStarIMP)(id, SEL, ...);
//typedef General/ACBOOLType (*ACBOOLIMP)(id, SEL, ...); //same as char



and..

    


-(General/ACCharStarType)replacCharStarPoint: (General/ACPointerType)a Point: (General/ACPointerType)b Char: (General/ACCharType)c {
    General/ACCharStarType toReturn;
    General/ACAdviceList * advice = General/[[ACAspectManager sharedManager] adviceListForSelector: _cmd onObject: self];
    if(advice == nil){ General/NSLog(@"!! error this should never happen! advice list was nil"); }
    [advice invokeBefores:_cmd onObject: self arg1: &a arg2: &b arg3: &c arg4: nil];
    General/ACCharStarIMP toInvoke = (General/ACCharStarIMP)[advice getIMP];
    if([advice hasArounds])
        toReturn = toInvoke(self, _cmd, a, b, c, [advice aroundIMPs]);
    else
        toReturn = toInvoke(self, _cmd, a, b, c);
    [advice invokeAfters:_cmd onObject: self returned: &toReturn arg1: &a arg2: &b arg3: &c arg4: nil];
    return toReturn;
}


-(General/ACCharStarType)replacCharStarPoint: (General/ACPointerType)a Point: (General/ACPointerType)b General/CharStar: (General/ACCharStarType)c {
    General/ACCharStarType toReturn;
    General/ACAdviceList * advice = General/[[ACAspectManager sharedManager] adviceListForSelector: _cmd onObject: self];
    if(advice == nil){ General/NSLog(@"!! error this should never happen! advice list was nil"); }
    [advice invokeBefores:_cmd onObject: self arg1: &a arg2: &b arg3: &c arg4: nil];
    General/ACCharStarIMP toInvoke = (General/ACCharStarIMP)[advice getIMP];
    if([advice hasArounds])
        toReturn = toInvoke(self, _cmd, a, b, c, [advice aroundIMPs]);
    else
        toReturn = toInvoke(self, _cmd, a, b, c);
    [advice invokeAfters:_cmd onObject: self returned: &toReturn arg1: &a arg2: &b arg3: &c arg4: nil];
    return toReturn;
}


-(General/ACCharStarType)replacCharStarPoint: (General/ACPointerType)a Point: (General/ACPointerType)b Struct: (General/ACStructType)c {
    General/ACCharStarType toReturn;
    General/ACAdviceList * advice = General/[[ACAspectManager sharedManager] adviceListForSelector: _cmd onObject: self];
    if(advice == nil){ General/NSLog(@"!! error this should never happen! advice list was nil"); }
    [advice invokeBefores:_cmd onObject: self arg1: &a arg2: &b arg3: &c arg4: nil];
    General/ACCharStarIMP toInvoke = (General/ACCharStarIMP)[advice getIMP];
    if([advice hasArounds])
        toReturn = toInvoke(self, _cmd, a, b, c, [advice aroundIMPs]);
    else
        toReturn = toInvoke(self, _cmd, a, b, c);
    [advice invokeAfters:_cmd onObject: self returned: &toReturn arg1: &a arg2: &b arg3: &c arg4: nil];
    return toReturn;
}


-(General/ACCharStarType)replacCharStarPoint: (General/ACPointerType)a Point: (General/ACPointerType)b Point: (General/ACPointerType)c {
    General/ACCharStarType toReturn;
    General/ACAdviceList * advice = General/[[ACAspectManager sharedManager] adviceListForSelector: _cmd onObject: self];
    if(advice == nil){ General/NSLog(@"!! error this should never happen! advice list was nil"); }
    [advice invokeBefores:_cmd onObject: self arg1: &a arg2: &b arg3: &c arg4: nil];
    General/ACCharStarIMP toInvoke = (General/ACCharStarIMP)[advice getIMP];
    if([advice hasArounds])
        toReturn = toInvoke(self, _cmd, a, b, c, [advice aroundIMPs]);
    else
        toReturn = toInvoke(self, _cmd, a, b, c);
    [advice invokeAfters:_cmd onObject: self returned: &toReturn arg1: &a arg2: &b arg3: &c arg4: nil];
    return toReturn;
}


-(General/ACStructType)replacStructDouble: (General/ACDoubleType)a Double: (General/ACDoubleType)b Double: (General/ACDoubleType)c {
    General/ACStructType toReturn;
    General/ACAdviceList * advice = General/[[ACAspectManager sharedManager] adviceListForSelector: _cmd onObject: self];
    if(advice == nil){ General/NSLog(@"!! error this should never happen! advice list was nil"); }
    [advice invokeBefores:_cmd onObject: self arg1: &a arg2: &b arg3: &c arg4: nil];
    General/ACStructIMP toInvoke = (General/ACStructIMP)[advice getIMP];
    if([advice hasArounds])
        toReturn = toInvoke(self, _cmd, a, b, c, [advice aroundIMPs]);
    else
        toReturn = toInvoke(self, _cmd, a, b, c);
    [advice invokeAfters:_cmd onObject: self returned: &toReturn arg1: &a arg2: &b arg3: &c arg4: nil];
    return toReturn;
}


-(General/ACStructType)replacStructDouble: (General/ACDoubleType)a Double: (General/ACDoubleType)b Char: (General/ACCharType)c {
    General/ACStructType toReturn;
    General/ACAdviceList * advice = General/[[ACAspectManager sharedManager] adviceListForSelector: _cmd onObject: self];
    if(advice == nil){ General/NSLog(@"!! error this should never happen! advice list was nil"); }
    [advice invokeBefores:_cmd onObject: self arg1: &a arg2: &b arg3: &c arg4: nil];
    General/ACStructIMP toInvoke = (General/ACStructIMP)[advice getIMP];
    if([advice hasArounds])
        toReturn = toInvoke(self, _cmd, a, b, c, [advice aroundIMPs]);
    else
        toReturn = toInvoke(self, _cmd, a, b, c);
    [advice invokeAfters:_cmd onObject: self returned: &toReturn arg1: &a arg2: &b arg3: &c arg4: nil];
    return toReturn;
}


-(General/ACStructType)replacStructDouble: (General/ACDoubleType)a Double: (General/ACDoubleType)b General/CharStar: (General/ACCharStarType)c {
    General/ACStructType toReturn;
    General/ACAdviceList * advice = General/[[ACAspectManager sharedManager] adviceListForSelector: _cmd onObject: self];
    if(advice == nil){ General/NSLog(@"!! error this should never happen! advice list was nil"); }
    [advice invokeBefores:_cmd onObject: self arg1: &a arg2: &b arg3: &c arg4: nil];
    General/ACStructIMP toInvoke = (General/ACStructIMP)[advice getIMP];
    if([advice hasArounds])
        toReturn = toInvoke(self, _cmd, a, b, c, [advice aroundIMPs]);
    else
        toReturn = toInvoke(self, _cmd, a, b, c);
    [advice invokeAfters:_cmd onObject: self returned: &toReturn arg1: &a arg2: &b arg3: &c arg4: nil];
    return toReturn;
}



etc...
there needs to be code like this for all possible combinations of return types and arg types from 0 to 4 args...
so how can it be condensed? any ideas?  Right now all possible combinations compiled come out to more than 5 MB.  For a framework that I expect developers to add to their own apps, this is unreasonable.  And I would like to support more args.. 5, 6, 7 each addition of 1 arg will greatly increase the size.. (by at least a factor of 2)  General/ACProblemOfVariableTypes provides code that will generate the above code in full..

----

Have a look at forwardInvocation: and methodSignatureForSelector: � this should allow you to create a catch-all method which will sort out what actually needs to be done, based on the method signature.