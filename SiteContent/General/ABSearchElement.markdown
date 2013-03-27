General/ABSearchElement inherits from General/NSObject
----

Use <code> -General/[ABPerson searchElementForProperty:...]</code> and <code>-General/[ABGroup searchElementForProperty:...]</code> to create search element on General/ABPerson and General/ABGroup.

----

    + (General/ABSearchElement *)searchElementForConjunction:(General/ABSearchConjunction)conjuction children:(General/NSArray *)children;
    
*Creates a search element combining several sub search element.
*conjunction can be kABSearchAnd or kABSearchOr.
*Raises of children is nil or empty


    - (BOOL)matchesRecord:(General/ABRecord *)record;

    * Given a record returns YES is this record matches the search element
    * Raises if record is nil


----

An example how to get firstname and lastname based on an E-Mail address:

    
    General/NSString *email = @"contact@example.com";

    General/ABSearchElement *search = General/[ABPerson searchElementForProperty:kABEmailProperty label:nil key:nil value:email comparison:kABEqualCaseInsensitive];
    General/NSArray *results = General/[[ABAddressBook sharedAddressBook] recordsMatchingSearchElement:search];

    if( [results count] > 0 )
    {
        // found someone
        General/NSLog(General/[NSString stringWithFormat:@"%@ %@ has the e-mail %@"], General/results objectAtIndex:0] firstName], [[results objectAtIndex:0] lastName], email]);
    }


----

The available properties (e.g. kABEmailProperty) are defined in <[[AddressBook/General/ABGlobals.h>