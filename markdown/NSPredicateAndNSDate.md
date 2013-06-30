I've been looking for examples and/or documentation on how to filter an General/NSArray through General/NSPredicate by using General/NSDate.  I have the data in a General/CoreData database with a "created" date parameter and would like to be able to filter by the date it was created.  Where can I find more information about this?

*Yeah, I have been having this same problem and would like to know the way to do it.* --General/LoganCollins

----

Easy (I think, I'm not looking at actual code but I think the stuff below works):

    
General/NSPredicate *p = General/[NSPredicate predicateWithFormat:@"created_key > %@", someDateAsNSDate]; // Grab anything after date created


----

Yeah, that's what I though when I was writing the code. It seems like the General/NSDate sends its description to be compared, which doesn't cope well with what General/CoreData sends for the key. They either should both send General/NSDate object or General/NSString descriptions, but I keep getting exceptions about can't compare dateWithTimeIntervalSinceReferenceDate and such, no matter which methods I try to compare it by.

When I try the code above, (which is what I had been using before), I get the following exception: "Exception raised during posting of notification.  Ignored.  exception: *** -General/[NSCFString timeIntervalSinceReferenceDate]: selector not recognized [self = 0x32f950]". It seems that the predicate is trying to compare an General/NSDate with and General/NSString, just as I said above. --Logan Collins

It does try to compare an General/NSDate with an General/NSString and thus fails. You need to build your General/NSPredicate programmatically rather than using a format. This works for me: 
    
General/NSPredicate *p = General/[NSComparisonPredicate predicateWithLeftExpression:General/[NSExpression expressionForKeyPath:@"created_key"] 
                                                    rightExpression:General/[NSExpression expressionForConstantValue:yourNSDateValue] 
                                                           modifier:General/NSDirectPredicateModifier 
                                                               type:General/NSGreaterThanPredicateOperatorType
                                                            options:0];

-- General/LeifSinger

----

Just in case you are using some string-based magic to create a larger query, this works as well:

    
General/NSString      *dateExpression = General/[[NSExpression expressionForConstantValue:yourNSDateValue]description];
General/NSPredicate *p = General/[NSPredicate predicateWithFormat:@"created_key > %@", dateExpression ]; // Grab anything after date created

-- Gerd Knops

Gerd, Leif,
neither of those solutions work, for me.
I am creating a spotlight query, and setting the predicate in code.
I am successful in every conceivable aspect of the implementation except for getting spotlight to compare General/NSDates and return values.

Currently, I create a predicate by doing this:

    
        General/NSString* theString = General/[[NSExpression expressionForConstantValue:theDate] description];
        
        General/NSMutableString* fro = General/[[NSMutableString alloc] init];
        General/NSPredicate* datePred;
       [fro appendString:@"kMDItemDueDate > "];
        [fro appendString:theString];

         datePred = General/[NSPredicate predicateWithFormat:fro];


but I'd tried it Leif's way as well. I don't get crashes, I just Never get any results.
this should not be this baffling, its a freaking date Object!