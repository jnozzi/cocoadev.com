This might also be called : Sorting Core Data-based Table by to-many relationships.

I was having problems sorting an General/NSTableView bound to an General/NSArrayController (also an General/NSOutlineView/General/NSTreeController issue).

Certain columns are bound to to-many relationships. An General/NSValueTransformer subclass translates the related set into displayable text, such as a count of the related entities, or the name of the first related entity (General/NSSet's dont have a "first", but I have an "order" attribute in the related entity for that).

One of the problems: The columns that use General/NSValueTransformer subclasses don't sort, with logged "*** -[_NSFaultingMutableSet compare:]: selector not recognized". 

----

Solution: add a special accessor-like method to the class being displayed in the table (an General/NSManagedObject subclass). The accessor, like "-employeeCount", returns a number or string using the same algorithm as the General/NSValueTransformer subclass uses to display the value (again, based on the to-many relationship--so the first thing it does is call [self valueForKey:@"employees"] returning an General/NSSet). Then, the General/NSTableColumn 's sort key is set to employeeCount in IB. Done.

The code implementing the algorithm could be shared instead of copied, by putting it in a class method (or even instance method) of the General/NSValueTransformer subclass. --General/PaulCollins