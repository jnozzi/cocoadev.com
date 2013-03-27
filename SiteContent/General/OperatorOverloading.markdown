

Is it possible as in General/CPlusPlus to overload operators in classes?

For example the + operator, so you could do A + B where A and B are both General/NSNumbers.

----

*No. General/ObjectiveC is basically C with a preprocessor.*

You might be able to use General/ObjectiveCPlusPlus and implement     operator+ for the class as a standalone function.

----

The problem is that operator functions must have either a class (as in a General/CPlusPlus class) or an enumerated type as one of its arguments.  The only way to really get overloaded operators to work with General/ObjectiveCPlusPlus is to wrap the General/ObjC class in a General/CPlusPlus class.  Here is a rather crude example:
 #import <Foundation/Foundation.h>
 
 #include <iostream>
 #include <ostream>
 
 class Number
 {
 	NSNumber* val;
 public:
 	Number (int);
 	~Number ();
 	
 	int get () const;
 };
 
 Number::Number (int intVal)
 {
 	val = General/NSNumber alloc] initWithInt: intVal];
 }
 
 Number::~Number ()
 {
 	[val release];
 }
 
 int Number::get () const
 {
 	return [val intValue];
 }
 
 Number operator+ (Number& r, Number& l)
 {
 	return Number (r.get () + l.get ());
 }
 
 int main (int argc, char*' argv)
 {
 	Number one = Number (1);
 	Number two = Number (2);
 	
 	std::cout << (one + two).get () << std::endl;
 
 	return 0;
 }
This will compile with "g++ -[[ObjC++ -framework Foundation filename.mm".

----

*The discussion below was moved from the General/CPlusPlusInCocoa page to here, where it is more relevant and helpful*

How can General/ObjectiveCPlusPlus be used for General/OperatorOverloading of either General/CPlusPlus classes or General/ObjectiveC classes?

----

It works the same way as regular C++. In C++ one tends to work with objects, not pointers to objects. General/ObjectiveC requires pointers to objects. 

As someone else has said, you can't mix the definitions of C++ and Objective-C classes. But you can use pure C++ inside an Objective-C method.

Here is an example. If this looks good to you, (as it does to me) you should use Objective-C++.

 - (void) print
   {
   try
     {
     std::string msg("wrong");
 
     NSLog(@"This is just %s", msg.c_str());
 
     // Create an object right here.
     std::ostringstream out;
 
     out << "This is a message: " << [self getText];
 
     std::cout << out.str() << std::endl;
     }
   catch(std::exception & err)
     {
     std::cout << err.what() << std::endl;
     }
   catch(...)
     {
     std::cout << "Unknown error!" << std::endl;
     }
   }

----

In that case, it would make sense, if one was doing heavy logic calculations, to do them in pure General/CPlusPlus that acts on input from normal General/ObjectiveC and that sends output to General/ObjectiveC.