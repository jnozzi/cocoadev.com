

In Objective-C, you can declare a variable in two places.  First, you can declare it in between the braces of the header file for your class.  Then it becomes an *instance variable*. Second, you can declare it within a method in the implementation file for your class.

**The compiler needs to be informed about every type before you use it**. That means you must import the header file into any implementation that uses the variable. To see the General/ParseError that you get if you fail to do this, see General/ParseErrorAtCertainNameNeedHelp.

You declare a variable by first defining the variable's **type**, then you write the name of the variable, and you end the declaration with a semicolon.
    
short myShortVariable;

This declaration defines a variable that is of the type "short" and which is named "myShortVariable".

You can declare more than one variable at a time...
    
float x,y,z;

Here we are declaring three variables of the type "float" which are named "x", "y", and "z".

----

Cocoa objects are declared with a style similar to that of declaring C pointers

Declaration of Cocoa objects as parameters and return values is best presented as an example of the interface part of a sample class
see also General/AnatomyOfADotHFile

    
1  //Pet-Class Interface (Pet.h) 
2  #import <Foundation/General/NSObject.>  
3  #import <Foundation/General/NSString.h> 
4  @interface 
5      Pet : General/NSObject            
6  {                               
7    General/NSString  *name;              
8   int        age;            
9  }                                                     
10  - (void)setName:(General/NSString *)newName; 
11  - (General/NSString *)name;
12  - (void)setAge:(int)newAge;      
13  @end   
                        

Remember that the code you are writing is in Objective-C, not in C. In C you write a prototype like this:

    void setName(General/NSString *newName);

but the Objective-C equivalent is:

    - (void)setName:(General/NSString *)newName;

The parentheses are there because it is the way specify the type of the parameter in Objective-C. Try reading the "The Objective-C Programming Language" book from Apple: http://developer.apple.com/documentation/Cocoa/Conceptual/General/ObjectiveC/index.html.

----

The **' is actually a part of the type. So you are using variables of type General/NSString* when dealing with Cocoa strings. Placing the * beneath the variable name is just an ancient C convention. The compiler will not distinguish between 'General/NSString *name', 'General/NSString* name' or even 'General/NSString*name', IIRC. This IS hard for a newbie - but C was written for Real� Men only, I suppose. ;-)

----
Remember in the interface, anything within the { } are variable declarations.  Anything after the } and before the @end are method declarations. 


*
Line 7, name is a variable, a pointer to a General/NSString(General/NSString *)
*
line 10, newName is a parameter when you call the method "setName" you must pass in a pointer to an General/NSString (General/NSString *)
*
line 11,  "name" is not a variable name but a method name,  this method will return a pointer to an General/NSString (General/NSString *)


Note that declaring scalar types uses the same punctuation style in General/ObjC (see also the discussion on C syntax for how
to declare and pass pointers to scalar types)

----

A good article about how to use global variables in Objective-C can be found here: General/GlobalVariablesInCocoa

Back to General/HowToProgramInOSX