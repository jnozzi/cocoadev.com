**Object Design:** *Matrix collection class*

----

**Why a Matrix is not an Array or a Dictionary**----

An array (General/NSArray;General/DesignArray) is a one-dimensional structure: it takes a single coordinate to refer to a single object. For any sane computer program, http://goo.gl/Cx9sQ this is sufficient as there can only be a finite number of objects anyway. But it is convenient to use something a little more general.

Apple's answer is General/NSDictionary (General/DesignDictionary) - a class that stores objects and refers to them by arbitrary objects, not simple numbers. The very existence of this storage type is intrinsic to all of Cocoa, and weaved into every class you write: the <code>-(unsigned)hash</code> method of General/NSObject. This intermingling is both a benefit and a curse. Any object can be used as a key with little work. But this is far from efficient, because the number of *possible* keys vastly outweighs the relatively small number of indices we have available in an array. This means we need to store each key along with the object it references, which can be very memory-inefficient, especially when compared to the zero-key-overhead of the array it is supposed to replace.
This occurs both because any object can be a key in any array, and because only one hashing algorithm can be used for each type. So we need a new storage type to fill the void, one I have christened (for now) the **Matrix Design**. This:

* Severely restricts the potential keys for any given matrix
* Separates the hashing algorithm from the key object
* Relies entirely upon the uniqueness of the hash output, doing away with the need to store the key with the object http://goo.gl/General/OeSCu


Advantages:
* Memory usage has the potential to drop significantly
* Keys that look different can be hashed to be the same where desired
* Hashing objects can be passed parameters upon construction
* More optimization can occur than for General/DesignDictionary
* More general than General/DesignArray without loss of optimization


Disadvantages:
* The reliance upon the hash output sets an upper bound on the "potential size" of a matrix; this limits the use of a matrix for massively sparse arrays. These should probably use a dictionary.
* The hashing algorithm becomes much more of an issue in a matrix design; home-brewed hashes must be coded carefully to prevent reuse of hash values
* If a way of retrieving the key from its hashed value is not provided, many powerful methods cannot be used. Retrieving the key can potentially be costly, however.


*What do people think of my criterion for and assessment of the Matrix design? Feel free to add to the advantages/disadvantages lists and add any other comments -- General/KritTer*

----**The design in practice: General/KTMatrix**
[http://www.geocities.com/kritter_cocoadev/General/KTMatrix/] ----

I am designing a matrix class (as you may have guessed from General/ClassClusters), and would appreciate some input.

It implements the design above, using dictionaries for keys, and arbitrary hashing objects to turn them into integer hash values (which are then used as keys in a storage dictionary).

To simplify its use in the role it was intended (cuboid multi-dimensional arrays), it has in-built functionality for easier syntax in those areas, to the point where the equivalent of
    id matrix[5][3][2]; is
    General/KTMutableMatrix *matrix =
    General/[KTMutableMatrix matrixWithCuboidBounds:5,3,2,0];and the equivalent of
    matrix[2][3][1] = [anObject retain];is
    [matrix setObject:anObject atCoordinates:2,3,1];

Does anyone have any input on this matter? Compliments, comments, insults and directions to code that already does something similar all welcome. I really want to design this thing well if there is interest, so don't be shy.

-- General/KritTer

----**Issues discovered (and, hopefully, comments)**----


* Because the hashing is non-unique, and because the location is not stored with each object (remember, this is a feature... :), implementation hiding cannot be complete or else duplicating matrices is impossible.

I have minimized this by only having a couple of methods that deal with pre-hashed values, one explicit in the base class, one implicit in the iterator

* I'm using a hash array in one of the three implementations, but an impromptu test I did suggests it is worse at retrieval than the O(log(n)) of a red-black tree. It would be nice if a new version of General/KTMutableMatrixSparseImp could be made to use such a tree.


----**General comments so far...**----

I am very interested in this. As it happens, it popped up at basically the exact moment that it might be useful to me. Serendipity!

Anyhow, I suspect that others will be interested also.

As an aside, does anybody know when the General/MiscKit is going to release something for OS X? General/KritTer's matrix class sounds like it might fit nicely into the General/MiscKit, but they haven't released anything in quite a while. If all else fails, a General/CocoaDev framework might be an option...

-- General/RobRix

----

Although I don't think I have any time to devote to beta testing, I will eagerly await the outcome of this project. It seems like a Cool Thing. -- General/DavidRemahl

----

Ahh... I'd beta test if I could, but outside using it in a program I'm making, I'm probably not going to have enough time, sorry :\

23 -init... methods? That beats my record. -- General/RobRix

Even that would be great. With that many inits, I'd spend days checking it all :( -- General/KritTer

Okie dokie. I gotta learn to use F-Script and General/ObjCUnit and those sorts of things... -- General/RobRix

----
OK, I know I'm being naive or something. I've looked through General/KTMutableMatrixes documentation but I still don't get it. 
If you send one of the matrix: messages to get a matrix and store it in a 
    General/KTMutableMatrix *theMatrix 
it seems you have to declare cuboid bounds. If you do, then, and only declare, say 3,4,2, and access 3,4,3, will an error happen and if so, how do you "add" to it's bounds? I'm confused. General/KTMutableMatrix seems almost the same as General/KTMatrix. Help?

----
General/KritTer's updates: 
* 29 Apr 2002 - the General/KTMatrix homepage is at http://www.geocities.com/kritter_cocoadev/General/KTMatrix. I've uploaded the first version of the code. Mind checking it out, General/RobRix? And anyone else, for that matter.
* 5 May 2002 - Testing is going well on the second incarnation of General/KTMatrix, which is much more optimized than the current version. For instance, mostly-full matrices now use a C array for constant-time access, and immutable sparse matrices use a binary search for faster object access than General/NSDictionary.
* 8 May 2002 - I cannot believe the number of bugs I've squashed in the old version. Second alpha now posted.
* 16 May 2002 - Anyone used the General/KTMatrix class yet? I've been a bit busy with General/CocoaDevTopics (and work) to keep coding recently.
* 17 May 2002 - I managed to almost double the speed of my test script by optimizing the basic coordinate-using functions in common cases. Vile temporary dictionaries...
*21 May 2002 - Third beta posted; this one contains all my coordinate-based optimizations. Together, they have reduced the runtime of my test script to a sixth. The evil influences: 
    * Temporary arrays and dictionaries
    * Autorelease
    

*4 October 2002 - As noted elsewhere, I am on an extended break from programming while I get Part III Mathematics out of the way. I have passed the baton - and the unfinished fourth alpha - on to General/RobRix. He will be in charge of future developments. Kritter out.

----
I have a quick question:

wouldn't

    
id myObjCArray[0][0][0] = @"Test String";


Work?
Now that I think about it, you might not even need General/NSArray for static arrays. Wow.