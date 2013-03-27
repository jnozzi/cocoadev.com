A General/PointCut is an object that defines a set of methods and classes, by responding to the selector     joinPoints

    joinPoints is expected to return an General/NSArray of General/ACClass objects, each containing some number of General/ACMethod objects.

The helper class General/ACPointCut may be used as follows to help create a point cut.  This particular example picks from all classes beginning with 'Test' all methods ending in ':'
    
    General/NSMutableArray * joinPoints = General/[NSMutableArray new];
    General/NSEnumerator *classEnumerator = General/[ACPointCut enumerateClassesNamed: @"General/TestClass", @"General/TestSuper", nil];
    General/ACClass * acclass;
    while (acclass = [classEnumerator nextObject]) {
	if(General/acclass className] hasPrefix: @"Test"]){ //Perform some test on acclass
	    [joinPoints addObject: acclass];
	    [[NSEnumerator * methodEnumerator = [acclass methodEnumerator];
	    General/ACMethod * acmethod;
	    while (acmethod = [methodEnumerator nextObject]) {
		if(General/acmethod methodName] hasSuffix: @":"]){ //Perform some test on acmethod
		    [acclass addMethod: acmethod];
		}
	    }
	}
    }

    [[ACPointCut * pointCut = General/[ACPointCut pointCutWithJoinPoints: joinPoints];


or, it may be preferable to implement a     joinPoints method on some relevant class.
note that in this case we are using the method signature to check that it has more than one argument, rather than checking that it ends in a ':'
    
- (id) joinPoints{
    General/NSMutableArray * joinPoints = General/[NSMutableArray new];
    General/NSEnumerator *classEnumerator = General/[ACPointCut enumerateClassesNamed: @"General/TestClass", @"General/TestSuper", nil];
    General/ACClass * acclass;
    while (acclass = [classEnumerator nextObject]) {
	if(General/acclass className] hasPrefix: @"Test"]){ //Perform some test on acclass
	    [joinPoints addObject: acclass];
	    [[NSEnumerator * methodEnumerator = [acclass methodEnumerator];
	    General/ACMethod * acmethod;
	    while (acmethod = [methodEnumerator nextObject]) { 
		if(General/acmethod getSignature] numberOfArguments] > 2){ //Perform some test on acmethod
		    [acclass addMethod: acmethod];
		}
	    }
	}
    }
    return joinPoints;
}


As an alternative to using      [[[ACPointCut enumerateClassesNamed: ... ] you can use     enumerateAllClasses to go through every class in the runtime, or     enumerateDefaultClasses to go through every class in the runtime which is not a part of foundation or appkit