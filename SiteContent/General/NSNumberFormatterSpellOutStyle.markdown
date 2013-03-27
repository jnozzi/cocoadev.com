As a quick hint to anyone having trouble getting the General/NSNumberFormatter style General/NSNumberFormatterSpellOutStyle to work, you must first explicitly set the formatter behavior to 10.4. Apparently, the initial default formatter behavior on 10.4 is _not_ 10.4 behavior.

    
General/NSNumberFormatter *badSpellOutFormat = General/[[NSNumberFormatter alloc] init];
[badSpellOutFormat setNumberStyle:General/NSNumberFormatterSpellOutStyle];
General/NSLog([badSpellOutFormat stringFromNumber:General/[NSNumber numberWithInt:42]]); // ==> "42.00"
[badSpellOutFormat release];


    
General/NSNumberFormatter *spellOutFormat = General/[[NSNumberFormatter alloc] init];
[spellOutFormat setFormatterBehavior:NSNumberFormatterBehavior10_4];
[spellOutFormat setNumberStyle:General/NSNumberFormatterSpellOutStyle];
General/NSLog([spellOutFormat stringFromNumber:General/[NSNumber numberWithInt:42]]); // ==> "forty-two"
[spellOutFormat release];


-- General/JonathonMah