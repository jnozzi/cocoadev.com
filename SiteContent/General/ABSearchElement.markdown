[[ABSearchElement]] inherits from [[NSObject]]
----

Use %%BEGINCODESTYLE%% -[[[ABPerson]] searchElementForProperty:...]%%ENDCODESTYLE%% and %%BEGINCODESTYLE%%-[[[ABGroup]] searchElementForProperty:...]%%ENDCODESTYLE%% to create search element on [[ABPerson]] and [[ABGroup]].

----

<code>+ ([[ABSearchElement]] '')searchElementForConjunction:([[ABSearchConjunction]])conjuction children:([[NSArray]] '')children;</code>
    
*Creates a search element combining several sub search element.
*conjunction can be kABSearchAnd or kABSearchOr.
*Raises of children is nil or empty


<code>- (BOOL)matchesRecord:([[ABRecord]] '')record;</code>

    * Given a record returns YES is this record matches the search element
    * Raises if record is nil


----

An example how to get firstname and lastname based on an E-Mail address:

<code>
    [[NSString]] ''email = @"contact@example.com";

    [[ABSearchElement]] ''search = [[[ABPerson]] searchElementForProperty:kABEmailProperty label:nil key:nil value:email comparison:kABEqualCaseInsensitive];
    [[NSArray]] ''results = [[[[ABAddressBook]] sharedAddressBook] recordsMatchingSearchElement:search];

    if( [results count] > 0 )
    {
        // found someone
        [[NSLog]]([[[NSString]] stringWithFormat:@"%@ %@ has the e-mail %@"], [[results objectAtIndex:0] firstName], [[results objectAtIndex:0] lastName], email]);
    }
</code>

----

The available properties (e.g. kABEmailProperty) are defined in <[[AddressBook]]/[[ABGlobals]].h>