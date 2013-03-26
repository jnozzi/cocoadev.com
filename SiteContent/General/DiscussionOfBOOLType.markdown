see also [[TypeIDDoesNotCastToTypeBOOL]], a very important point made by [[MikeTrent]]

'''BOOL is a scalar type, not an object type'''

I have an object that implements a BOOL in the header file.  I assign it a value in the awakeFromNib method.  I have implemented accessor methods for the variable.  When I try to reference it, I get a SIGBUS error:

the variable is declared as:
<code>BOOL viewReduced;</code>

and the accessor methods are declared:
<code>-(void)setViewReduced:(BOOL)yesOrNo;</code>
<code>-(BOOL)isViewReduced;</code>

then, in my awakeFromNib: method I say:
<code>viewReduced = NO;</code>

Relevant implementation code:

#import "[[MyView]].h"

Now if I so much as say<code> "[[NSLog]](@"viewReduced = @", viewReduced);</code>
the result is (null).

----

BOOL is not an object type, so your log statement above is incorrect. It should be:''

<code>
[[NLog]]( @"viewReduced = %d", viewReduced);
</code>

----

Actually, I have abandoned the approach that involved that variable.  The problem could simply have  been my use of "@" in my [[NSLog]] while referring  to a BOOL.  I'm sure that's what it was.

----

%@ means an object, and BOOL is not an object. If you want to log a BOOL, you can use %d, or you can do something like this:
<code>
[[NSLog]](@"[[MyBool]] is %@", myBool ? @"YES" : @"NO");
</code>

[[NSLog]]() has caused crashes for me from stupid mistakes like that. BTW, what is a BOOL really? It appears to be some type of macro? Why use something other than the C/C++ <code>bool</code>?

----

Command-double-click "BOOL" in Xcode and find out!

The answer is, it's simply a typedef to a type of <code>char</code>. The reason they don't use <code>bool</code> is because <code>bool</code> only appears in C++, not in C, and [[ObjectiveC]] is a superset of C; C++ is something else. C99 has a _Bool type, but obviously this was not available when [[ObjectiveC]] or Cocoa were first being designed.

''Taken from <code><objc/objc.h></code>:''
<code>
typedef signed char		BOOL; 
// BOOL is explicitly signed so @encode(BOOL) == "c" rather than "C" 
// even if -funsigned-char is used.
</code>

----

'''More about BOOL versus bool and Boolean'''

I'm very confused as to the difference between BOOL and Boolean in Objective C.  I've been using BOOL, but then, suddenly, I needed to use an [[NSAppleEventDescriptor]] method: booleanValue.  And this returns a Boolean.  I can't figure out how to even save such a thing in a variable.

----

Boolean and BOOL are basically the same thing. In straight-C any (integer-type) value that is not zero is true, the type Boolean is just a typedef'ed int or short (not sure which). In [[ObjectiveC]] the type BOOL is also an type that can be cast to an int. There are also the values YES and NO, which are just #defines for the values 1 and 0, respectively. True and false exist for Booleans.

So if a method returns a Boolean, and you don't really know what to do with it, check if it's 0, false (NO); otherwise, it's true (nonzero) (YES).

If you don't want to treat Booleans and [[BOOLs]] as the same, you can always do this:

<code>
BOOL returnval = methodReturningBoolean() ? YES : NO;
</code>

Which 'converts' a Boolean to a BOOL.

Here is more info: http://cs1313.ou.edu/boolean_data_lesson_2up.pdf (google cache: http://66.102.11.104/search?q=cache:gpRNOUz_BPwJ:cs1313.ou.edu/boolean_data_lesson_2up.pdf)

Personaly, I don't care for the BOOL type, I think it clashes with otherwise nice syntax in [[ObjectiveC]]. SEL, BOOL and IMP are all-caps, which is very odd, did Cox think that is was so very hard to type selector, boolean or implementation, written out, and in lower case (to denote that these are primitives, not classes). CAPITALS are for constants, not for types.

-- [[TheoHultberg]]/Iconara

----

FYI, <code>Boolean</code> is a data-type left over from the dawn of the Macintosh. [[NSAppleEventDescriptor]] wraps Carbon's <code>[[AEDesc]]</code> type, and the boolean <code>[[AEDesc]]</code> is documented as containing <code>Boolean</code>.

There are at least three boolean types: BOOL, Boolean, and C's bool. '''Only the last is a true boolean type.'''

----

<code>Boolean</code> is typed to to <code>unsigned char</code>, while <code>BOOL</code> is typed to <code>char</code> which means that <code>sizeof(Boolean) == sizeof(BOOL) == 1</code>. The values of a <code>Boolean</code> are <code>TRUE</code> and <code>FALSE</code>, those of a <code>BOOL</code> are <code>YES</code> and <code>NO</code>,, and those of a <code>bool</code> (the ISO C type) are <code>true</code> and <code>false</code>. In each case they are defines for 1 and 0, respectively.

----

'''Is type BOOL safe for addition?'''

<code>YES</code> and <code>NO</code> are defined as <code>(BOOL)1</code> and <code>(BOOL)0</code>. Is it safe to assume that these definitions will always be the same. The reason I ask is I was wondering if the following statement is a good or bad idea:

<code>
    BOOL hasTopSelection = [[SomeFunctionToCheckForTopSelection]]();
    BOOL hasBottomSelection = [[SomeFunctionToCheckForBottomSelection]]();
    int numberOfSelections = hasTopSelection + hasBottomSelection;
</code>

I know you could write this:

<code>
    int numberOfSelections = 0;
    if ([[SomeFunctionToCheckForTopSelection]]()) numberOfSelections++;
    if ([[SomeFunctionToCheckForBottomSelection]]()) numberOfSelections++;
</code>

but the first example will avoid two conditionals. 

----

Generally <code>NO/false</code> means zero and <code>YES/true</code> means everything but zero.

For several methods in Cocoa this is emphasized.

In C++ though, you are guaranteed that if you cast a bool to int, it will take the form of zero or one.

With regard to your code, use inline if's:
<code>
BOOL hasTopSelection = [[SomeFunctionToCheckForTopSelection]]();
BOOL hasBottomSelection = [[SomeFunctionToCheckForBottomSelection]]();
int numberOfSelections = (hasTopSelection?1:0) + (hasBottomSelection?1:0);
</code>

Remember, functions often do not explicitly return YES, but instead e.g. return <code>str[i] == '\0'</code> or similar (and the compiler knows nothing about <code>YES</code> and <code>NO</code>, <code>BOOL</code> is defined to be a <code>char</code>) type.

----

Yes, inline ifs work nice here. Your point about the return value being 8 bits wide is true (see [[TypeIDDoesNotCastToTypeBOOL]]). I guess I should never assume that a return of type BOOL will actually be the defined values of YES or NO (even when dealing with [[AppKit]] or Foundation objects).  

''I can only second that, though you can assume that the return value takes the form of <code>NO</code>, but not <code>YES</code>, as that is the complement of <code>NO</code>, which basically means �all values not equal to <code>NO</code>�.''