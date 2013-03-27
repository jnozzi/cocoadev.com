**Class Description**

General/NSNumber is a subclass of General/NSValue that offers a value as any C scalar (numeric) type. It defines a set of methods specifically for setting and accessing the value as a signed or unsigned char, short int, int, long int, long long int, float, or double or as a BOOL. It also defines a     compare: method to determine the ordering of two General/NSNumber objects.

----

**Apple Documentation**

https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Classes/NSNumber_Class/Reference/Reference.html

----
**See Also**

*General/NSDecimalNumber
*General/FakeNSNumbers (just for fun)


----

**Discussion**

A natural question is 'What kind of scalar value did a particular instance of General/NSNumber come from'?  General/NSNumber is a General/ClassCluster of more specific classes, and the identity of the subclass can be used to make this determination.  For example, an General/NSNumber that comes from a BOOL will be of the class General/NSCFBoolean whereas an integer will be an General/NSCFNumber.  The following snippet distinguishes the two:

    
 // suppose myNum is an instantiated NSNumber coming from an int or a BOOL
 if (General/myNum className] isEqualToString:@"NSCFNumber"]) {
      // process NSNumber as integer
 } else if  ([[myNum className] isEqualToString:@"NSCFBoolean"]) {
      // process NSNumber as boolean
 }


Alternatively:

    
 // suppose myNum is an instantiated NSNumber coming from an int or a BOOL
 if ([myNum isMemberOfClass:[NSCFNumber class) {
      // process NSNumber as integer
 } else if  ([myNum isMemberOfClass:[NSCFBoolean class]]) {
      // process NSNumber as boolean
 }


*You can also send     [NSNumber objCType] to get the type. Using className seems kind of fragile. See the docs for General/NSValue.* 

Using objCType is difficult and limited. The objCType returned for an General/NSNumber created with +numberWithBool is just char, which isn't helpful.  Also, the docs warn that the types are implementation dependent.

Also note that General/NSNumber is toll free bridged with General/CFNumber.  See General/TollFreeBridging.

*
I believe that this is not true.  Apple has a list of bridged classes here: http://developer.apple.com/documentation/Cocoa/Conceptual/CarbonCocoaDoc/cci_chap2/chapter_2_section_5.html
*

The article is now at http://developer.apple.com/documentation/Cocoa/Conceptual/CarbonCocoaDoc/Articles/DataTypes.html#//apple_ref/doc/uid/20002401 and does not mention General/NSNumber.  However, http://developer.apple.com/documentation/CoreFoundation/Reference/CFNumberRef/Reference/reference.html indicates that the Number classes are bridged, and General/NSNumber -className returns @"NSCFNumber".

Example Usage

    
 int i = 22;
 float f = 28.5;
 NSNumber *myInt;
 NSNumber *myFloat;
 myInt = [NSNumber numberWithInt:i];
 myFloat = [NSNumber numberWithFloat:f];
 NSLog(@"My float is %@ and my int is %@", myInt, myFloat);


--General/CharlieMiller