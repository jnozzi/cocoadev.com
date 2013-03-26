This page provides a summary of how Objective-C is implemented in C using Apple's Objective-C runtime.  Other runtimes are similar.

As a C programmer, perhaps you need the "magic" removed so you can see what is happening in Objective-C.


Objective-C adds the concepts of ''objects'' and ''message sending'' to the C language.  Any message may be sent to any object.  By default, there is a runtime error if the receiver of a message does not understand the message, although some receivers may suppress the error or handle the unrecognized message my passing it on to an object that does understand it.


But first, let's propose these implementation neutral definitions: '''An Objective-C object is anything that can receive a message.  A message is just a request for the receiver to do something using arguments that may be provided with the message.  In some cases, sending a message may return a value to the sender.'''


Those definitions may seem vague, but it is that simple, and there are huge implications to this.  Just to whet your appetite, neither the receiver nor the message needs to be known at compile time, and this is the great strength (flexibility) of Objective-C and similar languages like Smalltalk, Ruby, and Python but not like C++ or Java.


So, for a C programmer, what is an Objective-C object ?  In implementation, and Objective-C object is any C structure whose first element is a variable of type %%BEGINCODESTYLE%%Class%%ENDCODESTYLE%%.  In %%BEGINCODESTYLE%%objc.h%%ENDCODESTYLE%% on your hard drive, you will find the C type %%BEGINCODESTYLE%%Class%%ENDCODESTYLE%% is declared as

<code>
typedef struct objc_class ''Class;
</code>

Another fun C typedef is the %%BEGINCODESTYLE%%id%%ENDCODESTYLE%% type used to store a pointer to any Objective-C object:

<code>
typedef struct objc_object {
	Class isa;
} ''id;
</code>

So, any variable of type  %%BEGINCODESTYLE%%id%%ENDCODESTYLE%% is just a pointer to any structure that contains as its first element a pointer to a variable of type %%BEGINCODESTYLE%%Class%%ENDCODESTYLE%%.

Now that you know exactly what an Objective-C object is from a C programmer's point of view, what is a message ?

Apple's Objective-C implementation provides a couple of C functions:

<code>
id objc_msgSend(id self, SEL op, ...);
id objc_msgSendSuper(struct objc_super ''super, SEL op, ...);
</code>

The %%BEGINCODESTYLE%%SEL%%ENDCODESTYLE%% type is the C type that identifies what message is being sent.  In %%BEGINCODESTYLE%%objc_msgSend(id self, SEL op, ...)%%ENDCODESTYLE%%, %%BEGINCODESTYLE%%self%%ENDCODESTYLE%% is the receiver of the message, %%BEGINCODESTYLE%%SEL%%ENDCODESTYLE%% identifies the message being sent, and any number of arguments may follow.

%%BEGINCODESTYLE%%objc_msgSendSuper()%%ENDCODESTYLE%% is similar to %%BEGINCODESTYLE%%objc_msgSend()%%ENDCODESTYLE%%.  The only relevant difference between the two is where the function looks first to find an %%BEGINCODESTYLE%%IMP%%ENDCODESTYLE%% to call in response to the message.  What's an %%BEGINCODESTYLE%%IMP%%ENDCODESTYLE%% you ask ?

<code>
typedef id (''IMP)(id, SEL, ...);
</code>

%%BEGINCODESTYLE%%IMP%%ENDCODESTYLE%% is a C typedef for a pointer to a function that takes the same arguments as %%BEGINCODESTYLE%%objc_msgSend()%%ENDCODESTYLE%% and returns the same type.  The code that is executed in response to receipt of Objective-C messages is compiled into C functions by the Objective-C compiler.  Pointers to those functions are then associated with messages using a hash table that maps %%BEGINCODESTYLE%%SEL%%ENDCODESTYLE%% to %%BEGINCODESTYLE%%IMP%%ENDCODESTYLE%%.

%%BEGINCODESTYLE%%objc_msgSend()%%ENDCODESTYLE%% and %%BEGINCODESTYLE%%objc_msgSendSuper()%%ENDCODESTYLE%% simply use the provided %%BEGINCODESTYLE%%SEL%%ENDCODESTYLE%% argument to look-up the corresponding %%BEGINCODESTYLE%%IMP%%ENDCODESTYLE%% and than call the %%BEGINCODESTYLE%%IMP%%ENDCODESTYLE%% passing the same arguments that were passed to %%BEGINCODESTYLE%%objc_msgSend()%%ENDCODESTYLE%% and %%BEGINCODESTYLE%%objc_msgSendSuper()%%ENDCODESTYLE%%.

That is Objective-C.


Now that you know what an object is, let's look at some Objective-C code to see the corresponding C code.

<code>
[[NSArray]] ''fileTypes = [[[NSArray]] arrayWithObject:@"td"];
</code>

%%BEGINCODESTYLE%%[[NSArray]] ''%%ENDCODESTYLE%% and %%BEGINCODESTYLE%%[[NSOpenPanel]] ''%%ENDCODESTYLE%% are both synonyms for the C type %%BEGINCODESTYLE%%id%%ENDCODESTYLE%%.

The following code will produce '''exactly''' the same machine code when compiled with Objective-C as the code above:

<code>
id fileTypes = [[[NSArray]] arrayWithObject:@"td"];
</code>

So you know that %%BEGINCODESTYLE%%fileTypes%%ENDCODESTYLE%% is a variable that points to a %%BEGINCODESTYLE%%struct objc_object%%ENDCODESTYLE%%.


%%BEGINCODESTYLE%%id fileTypes = [[[NSArray]] arrayWithObject:@"td"];%%ENDCODESTYLE%% is a synonym for

<code>
struct objc_object ''fileTypes = objc_msgSend(objc_lookUpClass("[[NSArray]]"), sel_getUid("arrayWithObject:"), @"td");
</code>

For reference: In %%BEGINCODESTYLE%%objc.h%%ENDCODESTYLE%% see the declaration %%BEGINCODESTYLE%%SEL sel_getUid(const char ''str);%%ENDCODESTYLE%%.
In  %%BEGINCODESTYLE%%objc-runtime.h%%ENDCODESTYLE%% see the declaration   %%BEGINCODESTYLE%%id objc_lookUpClass(const char ''name);%%ENDCODESTYLE%%.


ignoring %%BEGINCODESTYLE%%@"td"%%ENDCODESTYLE%% for a moment...

you now see that %%BEGINCODESTYLE%%id fileTypes = [[[NSArray]] arrayWithObject:@"td"];%%ENDCODESTYLE%% is just a syntactically nicer way of writing 

<code>
struct objc_object ''fileTypes = objc_msgSend(objc_lookUpClass("[[NSArray]]"), sel_getUid("arrayWithObject:"), @"td");
</code>

In reality, the Objective-C compiler can optimize things a bit to eliminate some of the function calls at run-time, but that is beside the point right now.

What is the significance of the string %%BEGINCODESTYLE%%"[[NSArray]]"%%ENDCODESTYLE%% ?  There is an Objective-C class named %%BEGINCODESTYLE%%[[NSArray]]%%ENDCODESTYLE%% provided by the Cocoa framework.  As you can guess from the C language implementation of Objective-C, %%BEGINCODESTYLE%%objc_lookUpClass()%%ENDCODESTYLE%% just returns an %%BEGINCODESTYLE%%id%%ENDCODESTYLE%% type value that was associated with the string%%BEGINCODESTYLE%%"[[NSArray]]"%%ENDCODESTYLE%% by the Objective-C compiler.  Yes, that's right, just like the compiler generates a hash table to associate %%BEGINCODESTYLE%%IMP%%ENDCODESTYLE%% with %%BEGINCODESTYLE%%SEL%%ENDCODESTYLE%%, it generates a hash table to associate %%BEGINCODESTYLE%%id%%ENDCODESTYLE%%s with Objective-C class names like %%BEGINCODESTYLE%%[[NSArray]]%%ENDCODESTYLE%%.  So, when the compiler compiled the class %%BEGINCODESTYLE%%[[NSArray]]%%ENDCODESTYLE%%, the compiler generated the following  things:


*the compiler generated a static C structure whose first element is of type  %%BEGINCODESTYLE%%Class%%ENDCODESTYLE%%.
*the compiler generated a hash table entry associating a pointer to the static structure with the string  %%BEGINCODESTYLE%%"[[NSArray]]"%%ENDCODESTYLE%%.
*the compiler generated a hash table entry associating a  %%BEGINCODESTYLE%%SEL%%ENDCODESTYLE%% with the string  %%BEGINCODESTYLE%%"arrayWithObject:"%%ENDCODESTYLE%%.
*The compiler generated a C function containing code to be executed in response to the  %%BEGINCODESTYLE%%arrayWithObject:%%ENDCODESTYLE%% message selector (%%BEGINCODESTYLE%%SEL%%ENDCODESTYLE%%).
*the compiler generated a hash table entry associating a pointer to the C function (%%BEGINCODESTYLE%%IMP%%ENDCODESTYLE%%) with the  %%BEGINCODESTYLE%%SEL%%ENDCODESTYLE%% previously associated with the string  %%BEGINCODESTYLE%%"arrayWithObject:"%%ENDCODESTYLE%%.


All that stuff generated by the compiler makes %%BEGINCODESTYLE%%id fileTypes = objc_msgSend(objc_lookUpClass("[[NSArray]]"), sel_getUid("arrayWithObject:"), @"td")%%ENDCODESTYLE%% work at run-time.