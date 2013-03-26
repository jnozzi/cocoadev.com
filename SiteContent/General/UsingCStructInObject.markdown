I have an object called Crossword.  Inside this object I have typdef'ed a struct like this

<code>
typedef struct{
BOOL isSquareInCrossword;
[[NSString]] ''letter;
BOOL isFirstLetterInWord;
}square;
</code>

I have declared an array of these squares
<code>
square crosswordBoard[50][50];
</code>

In regular C, inside the object, I can refer to (and assign values to) elements like this
<code>
crosswordBoard[30][15].isSquareInCrossword = 0;
</code>

I have a accessor method for crosswordBoard in the object Crossword.
<code>
-(square '')crosswordBoard
{
     return crosswordBoard;
}
</code>

How do I refer to the elements within crosswordBoard when I am in a different object?  In a different object, I declare
<code>
#include "Crossword.h"
...
[[IBOutlet]]   Crossword   crossword;
</code>

I tried
<code>
[crossword crosswordBoard][3][7].isSquareInCrossword=1;
</code>

This does not work for two reasons.  (1) something is wrong with the accessor method.  If you could tell me what I am doing wrong, that would be great. (2) the way I refer to the elements in crosswordBoard is not right.  Any suggestions on how to do this? --[[AlexanderD]]

----

In your accessor, you're returning a square '', not a square. Either of the following solutions should solve both the problems you specify above.

Either:
1. Change the return type of the accessor to square (not square ''), which means you'd have to either dereference in the accessor or change the type in your class to square also.
2. OR (don't do both!) dereference whenever you use -crosswordBoard. (Like this:<code>(''[crossword crosswordBoard])[3][7].isSquareInCrossword = 1;</code>

----

The first solution is not exactly what I need, because I want to pass an array of squares, not just one square.  I like the second idea, but the accessor method still does not work.  How do I change the accessor method so that what I return is really a (square '').  I am not so good at pointer stuff as you can see. --[[AlexanderD]]

----

If you are actually wanting to alter the state of the Crossword object then you really ought to write a method on Crossword that does it, it's bad karma to do what you seem to want to do! If you are trying to set a flag true / false to say if a square is 'in the crossword' then add something like this to the Crossword object.

<code>
- (void)setSquareAtRow:(int)aRow column:(int)aColumn isIncluded:(BOOL)aFlag
{
    crosswordBoard[aRow][aColumn].isSquareInCrossword = aFlag;
}

- (BOOL)isIncludedAtRow:(int)aRow column:(int)aColumn
{
    return crosswordBoard[aRow][aColumn].isSquareInCrossword;
}
</code>

Generally, you should not expose the innards of objects to the outside world as you don't know who could change it with disastrous consequences and all that. Excuse any typos /etc, I'm tired! I am sure you will understand what I mean.

----

You need to return a <code>(square[50][50])</code> from <code>crosswordBoard</code>, not a pointer, since the latter doesn't work for 2D arrays.

----

This might seem silly, but why don't you use this?

<code>
typedef struct{
BOOL isSquareInCrossword;
char letter;
BOOL isFirstLetterInWord;
}square;
</code>

If letter is never going to be more then one character, why not avoid the extra overhead?  --[[DerekCramer]]

----

''Or use a <code>unichar</code> instead of <code>char</code>...it's basically the same, but it supports Unicode characters. --[[JediKnil]]''

----

If you want to initialize a structure in the following way, you have to use [[ObjectiveCPlusPlus]] (give your source implementation a .mm extension):

<code>
struct astruct
{
     int x;
     int y;
       
     astruct()
      {
         x=10;
         y=20;
       }
};
</code>

Or you can do it the C way if you're in plain Objective C:

<code>
typedef struct astruct {
    int x;
    int y;
} astruct;
...
astruct blah = { 10, 20 };
</code>

----

I want to use some C code in a standard Cocoa Objective-C app. I want to call the C stuff and get a returned array from it - I've tried just sticking the C code into my Obj-C file, but the compiler seems to choke on the "struct data{...}" and on pretty much everything else.

Edit: After some fiddling, I've it's only choking on this:

struct
{
     char x;
     char y;
     char z;
     char pad[57];
}data;

...

struct data inputStructure;

...

structureInputSize = sizeof(struct data);

The struct declaration works fine, whether or not I have a "typedef" before it; the second thing gives an "error: storage size of 'inputStructure' isn't known" and the third gives "error: invalid application of 'sizeof' to incomplete type 'struct blehData'".

----

[[ObjectiveC]] is C code. It's a superset, so you should be fine. 

Where exactly in the code did you add the "data" struct defintion? Hint: You need to add it before your code needs to use it.

----

It's before my method declaration, like so:

@implementation Tilter

[[NSString]] ''bookModel;
struct
{
...
}data;

- ([[NSArray]] '')getTilt
{
...
struct data inputStructure;
...
structureInputSize = sizeof(struct data);
...
}

Edit: Aaand got it. struct data{ ... }; worked. Thanks.

----

Ah, my bad, I didn't notice you changed the "struct data" declaration.  Yeah, that will have stuffed it up.