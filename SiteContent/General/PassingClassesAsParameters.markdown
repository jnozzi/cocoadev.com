I'm working on a drug wars game for my first Cocoa project, and the following code returns an error:

    
- (void) buyDrug(int)amt ofKind:(Drug)theDrug
{
  [theDrug setAmountOwned:[theDrug amountOwned] + amt];
  myCash = myCash - amt * [theDrug price];
  General/[DrugLord update];
}

It says "parse error before 'Drug'". Drug is a class defined within the project; this method is in the "General/DrugOverlord" class.  It also says "'theDrug' not defined here." Anyone know what I'm doing wrong?

1. Make sure that you have #import "Drug.h" at the top of your General/DrugOverload.m file (assuming those filenames are correct).

2. Change (Drug) to (Drug *) because General/ObjectiveCee classes are accessed using pointers to the actual memory in which the object is contained.

3. You forgot to put a colon in between buyDrug and (int) in the method declaration. (Don't worry, I do it all the time)

-- General/KevinPerry