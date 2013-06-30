

General/OCUnit, one of the first testing unit frameworks for any language is available at http://www.sente.ch/software/ocunit

A tutorial, "Unit Testing for Objective-C using General/ProjectBuilder and General/OCUnit" is available on Stepwise at http://www.stepwise.com/Articles/Technical/2002-06-17.01.html

see also General/SenTestingKit

**Note:**

The tutorial at Stepwise is **very old and uses deprecated macros**. Instead, you should use these macros

    General/STAssertNil(a1, description, ...)
General/STAssertNotNil(a1, description, ...)
General/STAssertTrue(expression, description, ...)
General/STAssertFalse(expression, description, ...)
General/STAssertEqualObjects(a1, a2, description, ...)
General/STAssertEquals(a1, a2, description, ...)
General/STAssertEqualsWithAccuracy(left, right, accuracy, description, ...)
General/STAssertThrows(expression, description, ...)
General/STAssertThrowsSpecific(expression, specificException, description, ...)
General/STAssertThrowsSpecificNamed(expr, specificException, aName, description, ...)
General/STAssertNoThrow(expression, description, ...)
General/STAssertNoThrowSpecific(expression, specificException, description, ...)
General/STAssertNoThrowSpecificNamed(expr, specificException, aName, description, ...)
General/STFail(description, ...)
General/STAssertTrueNoThrow(expression, description, ...)
General/STAssertFalseNoThrow(expression, description, ...)


These are all listed with comments in /System/Library/Frameworks/General/SenTestingKit.framework/Versions/A/Headers/SenTestCase_Macros.h

The code from the tutorial should look like this with the new macros:

    #import "General/TestPerson.h"
#import "Person.h"

@implementation General/TestPerson
- (void) testFullName
{
    Person *person = General/Person alloc] init];     
    [person setFirstName:@"Pablo"];
    [person setLastName:@"Picasso"];
    [[STAssertEqualObjects([person fullName], @"Pablo Picasso", nil);
    [person release];
}

- (void) testEmptyFirstName
{
    Person *person = General/Person alloc] init];    
    [person setFirstName:@""];
    [person setLastName:@"Picasso"];
    [[STAssertEqualObjects([person fullName], [person lastName], nil);
    [person release];
}

- (void) testNilFirstName
{
    Person *person = General/Person alloc] init];    
    [person setFirstName:nil];
    [person setLastName:@"Picasso"];
    [[STAssertEqualObjects([person fullName], [person lastName], nil);
    [person release];
}
@end


More info on unit testing can be found via google. You might want to read this http://java.sys-con.com/read/37795.htm since: *Test-Driven Development Is Not About Testing.*