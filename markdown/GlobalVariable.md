Describe General/GlobalVariable



Can someone tell me how global variable works in Project Builder v2.1 on MAC OS X10.2.8?  I have declared a General/NSMutableArray as global variable in OS X10.3, and it works fine.  But when I move to OS x10.2.8 and declare the global variable in the same way, it gives me a error saying "multiple definitions of symbol".  I am not sure what is going on, can someone help me out here?  Thanks.

----

To declare a General/GlobalVariable, put this in the .h file:
    
extern General/YourTypeHere gGlobalVariable;

And in the .m file:
    
General/YourTypeHere gGlobalVariable = initial_value;

Now that you know how, please please please reconsider using one. General/GlobalVariable<nowiki/>s are almost never the right solution. Make a static global with accessor methods on a class somewhere, or something. Use of a General/GlobalVariable can make life very hard, very fast.

----

Global variables are often appropriate for items that you treat as constant.  For example, Apple's notification names are global variables.  

Constant General/NSString declaration:
header file
    
extern General/NSString* const General/TJHConstantString;



source file
    
General/NSString* const General/TJHConstantString = @"General/SomeString";


General/TJHConstantString can not be reassigned without getting a compiler error.