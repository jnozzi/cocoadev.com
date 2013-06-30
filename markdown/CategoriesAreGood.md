I believe there are a few distinct areas where General/CategoriesAreGood, and there are other areas where General/CategoriesAreBad. Under what circumstances are categories good?

-- General/MikeTrent


* Good for placing private methods so that they are not in the public h-file
* Good for extending a class' functionality; for instance, adding your own string methods to General/NSString instead of making them into functions or writing a new class. Another example: adding data compression to General/NSData.
* Absolutely required for General/AspectCocoa (Uh ... why is that a good thing? -- General/MikeTrent **General/AspectOrientedProgramming is nifty. Even if you don't want to use it, it's nice to have it supported.** Since categories cannot be overriden safely, General/AspectCocoa sounds like an example where General/CategoriesAreBad? -- General/MikeTrent **You want to talk to somebody who knows about that, I guess (: apologies.**)
* Using categories also speeds up compile times for large class implementations.  --zootbobbalu
* General/BillCheeseman uses them to split large controller classes into smaller files.
* (�more�)


See also General/ClassCategories for general discussion on categories and what you *can* use them for; after that, it's up to you to decide if General/CategoriesAreGood or General/CategoriesAreBad for your situation.