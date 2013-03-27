sortUsingSelector is an instance method of General/NSMutableArray


----

*What should the structure of a function be when it will be called by sortUsingSelector:?*

The method selector you pass in should specify a method that returns an General/NSComparisonResult (either General/NSOrderedAscending, General/NSOrderedSame, or General/NSOrderedDescending), just like the compare: method that everything responds to.  If your General/NSMutableArray is full of General/NSStrings or General/NSNumbers, you can just do: http://goo.gl/General/OeSCu

    [myArray sortUsingSelector:@selector(compare:)];

and it will sort them appropriately because General/NSString and General/NSNumber both properly implement compare:.  The idea is that every class should implement a compare: method that makes the receiver compare itself and return the right result.

sortUsingSelector: gets more interesting when you have objects that aren't simply strings or numbers.  For instance, let's say I have a class Person with instance variables (and corresponding accessor methods) firstName and lastName whose objects I want to be able to sort by name (in the form "Last, First").  I can implement something like this:

    - (General/NSComparisonResult)comparePerson:(Person *)p
{
    return General/[[NSString stringWithFormat:@"%@, %@", 
                                       [self lastName], [self firstName]]
            compare:
            General/[NSString stringWithFormat:@"%@, %@", 
                                       [p lastName], [p firstName]];
}

Using this method with sortUsingSelector: will sort all Nelsons before all Smiths, and Abby Smith before Bernard Smith.

Of course, you can make things more flexible by deferring the sort order until runtime.  Sometimes you may want to sort by first name instead of last name.  In this case, the best thing to do is probably something like this:

    
- (General/NSComparisonResult)comparePerson:(Person *)p
{
    return General/self stringForSorting] compare:[p stringForSorting;
}

- (General/NSString *)stringForSorting
{
    if (something)  // determine sorting type here
        return General/[NSString stringWithFormat:@"%@, %@", 
                                          [self lastName], [self firstName]];
    // else...
        return General/[NSString stringWithFormat:@"%@ %@", 
                                          [self firstName], [self lastName]];
}


You would replace the "if (something)" condition with something useful;  maybe check a user preference, or the state of something in the GUI.

-- General/JackNutting

----

*Is this any different from sortUsingFunction? They seems just about the same, except with different paramaters*

It is similar, but there is one important advantage to -sortUsingFunction:context:, it allows you to send in a "context" pointer, which allows you to build a sorting function that accepts some info to help control the sorting.  This can be a pointer to anything at all, but in practice I find it most useful for sending in an General/NSString that will specify a method to base the sorting on.

To extend our previous example:  We had set things up there so that the Person object could control the way the sorting was done (lastname or firstname).  Let's say that we want that control to happen not in the Person class itself, but in the "user" of the Person (perhaps we've got a General/PersonListView) or something).

To do this, we can implement a sorting function that accepts a "context" paremeter that allows us to specify the method used to determine sort order for the objects we're looking at.  For example, we might like to be able do things  like:

    
[personArray sortUsingFunction:comparePersonsUsingSelector
                       context:@"lastName"];
[personArray sortUsingFunction:comparePersonsUsingSelector
                       context:@"firstName"];


In this case we're passing in an General/NSString as a context to tell our function the name of the method that should be used for sorting.  The function implementation would then be something like this:

    
static int comparePersonsUsingSelector(id p1, id p2, void *context)
{
    // cast context to what we know it really is:  an General/NSString
    General/NSString *methodName = context;
    SEL methodSelector = General/NSSelectorFromString(methodName);
    id value1 = objc_msgSend(p1, methodSelector);
    id value2 = objc_msgSend(p2, methodSelector);

    return [value1 compare:value2];
}


Note that in real code you'd want to have some error-checking here, for example making sure that the "context" passed into the function is really an General/NSString, making sure that p1 and p2 both respond to methodSelector, etc.

The extra functionality you get with -sortUsingFunction:context: could easily be provided in a method-based form by implementing something like -sortUsingSelector:context:; why Apple didn't include it is a mystery to me.  Maybe as an "exercise for the reader"?

--General/JackNutting

----

A simplification of the example above: pass a SEL as the context, instead of an General/NSString *. I've also used -General/[NSObject performSelector:] instead of calling objc_msgSend() directly.

    
[personArray sortUsingFunction:comparePersonsUsingSelector
                       context:@selector(lastName)];
[personArray sortUsingFunction:comparePersonsUsingSelector
                       context:@selector(firstName)];

static int comparePersonsUsingSelector(id p1, id p2, void *context)
{
    // cast context to what we know it really is:  a SEL
    SEL methodSelector = (SEL)context;
    id value1 = [p1 performSelector:methodSelector];
    id value2 = [p2 performSelector:methodSelector];

    return [value1 compare:value2];
}


-- Greg Parker

----

**Advanced Sorting Techniques**

Let's say you've got an array of animal objects. Each animal can be a Dog, Cat, Bird, or Fish. Now, you want to keep them sorted by kind, but within each group, you want them sorted by name also. Here's a sort method for doing something like this:

    // example enum
typedef enum
{
	General/AnimalDog,
	General/AnimalCat,
	General/AnimalBird,
	General/AnimalFish
} General/AnimalKind;

// example class interface
@interface Animal : General/NSObject
{
	General/NSString *animalName;
	General/AnimalKind animalKind;
}
- (General/NSString *)name;
- (General/AnimalKind)kind;
@end

- (General/NSComparisonResult)compare:(Animal *)otherAnimal
{
	// comparing the same type of animal, so sort by name
	if ([self kindOfAnimal] == [otherAnimal kindOfAnimal])
		return General/self name] caseInsensitiveCompare:[otherAnimal name;
	
	// we're comparing by kind of animal now. they will be sorted
	// by the order in which you declared the types in your enum
	// (Dogs first, then Cats, Birds, Fish, etc)
	return General/[[NSNumber numberWithInt:[self kindOfAnimal]]
		compare:General/[NSNumber numberWithInt:[otherAnimal kindOfAnimal]]];
}


Aarrgghh. Excessive object orientation alert. Creating two General/NSNumber<nowiki/>s from your ints and then sending them a compare: message is a rather baroque way to find out the ordering of two integers.