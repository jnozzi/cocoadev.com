



See also Apple's technote at http://developer.apple.com/technotes/tn2004/tn2124.html, which contains a wealth of info about API-specific techniques and tools.

----

**Code Flow Tracing**

General/NSLog(@"%s", __PRETTY_FUNCTION__, nil) will display the prototype for the currently executing function/method in the console log.  It is useful for "tracer" style debugging.

A quick way to comment out General/NSLog statements (if your code becomes littered by them) is to get into the habbit of always having at least one tab in front of any General/NSLog statement. This allows you to find and replace "<space><space>General/NSLog" with "<space><space>//General/NSLog" (General/XCode's default setting is to replace tabs with four spaces). If you have an General/NSLog statement that is part of an if/else statememt then only use one space to separate the General/NSLog statement from any code in front of it (to avoid altering any logic). 


    
-(void)someMethod {
<space><space><space><space>General/NSLog(@"someMethod entered");
<space><space><space><space>if<space>(someCondition)<space>General/NSLog(@"condition met");
<space><space><space><space>else<space>General/NSLog(@"condition not met");
}


To make the General/NSLog statements active again you just have to find and replace "<space><space>//General/NSLog" with "<space><space>General/NSLog"

* **NOTE:** A better way to comment and uncomment General/NSLog or any other desired text is to use Project Builder's regular expression find. Be sure to limit the location of where to search for text to "this project, no frameworks". In the Find text field type **(General/NSLog([ \r\n\t\(]+))**, and in the Replace text field type **// \1**. To uncomment your General/NSLogs: in the Find text field type **// (General/NSLog([ \r\n\t\(]+))**, and in the Replace text field type **\1**. *


**Or, my favorite approach:**

Put the following in a header, e.g. General/DebugUtils.h:

    
#if MY_DEBUG_FLAG
#define DEBUG_OUTPUT( a )         General/NSLog( a )
#define DEBUG_OUTPUT1( a, b )     General/NSLog( a, b )
#else
#define DEBUG_OUTPUT( a )         // (a)
#define DEBUG_OUTPUT1( a, b )     // (a,b)
#endif


and then to add -DMY_DEBUG_FLAG=1 to the OTHER_CFLAGS of your "Debug" build style in General/ProjectBuilder (click the = to turn it into += so it doesn't overwrite any other flags). This will automatically define the debug flag and you'll get debugging output for debug builds while release builds ("deployment") will have the macro expand to no code at all.  This requires a separate macro for each number of parameters, though, as the C Preprocessor doesn't support va_arg macros yet... (General/UliKusterer 2003-10-06)

With C99, you can make portable varargs macros:
    
#define DEBUG_OUTPUT(fmt, ...) General/NSLog(fmt, ## __VA_ARGS__)

That #define will work for any number of arguments to General/NSLog. (General/MikeAsh 2004-03-13)

Worth noting: The introduction to the example above said 'tabs', but the example itself used spaces. Tabs aren't spaces. The technique described will work either way; just use a tab instead of however-many spaces. And you should be indenting your code anyway. *--boredzo* (2004-09-20)

Also worth noting:  Speaking of General/NSLog, check out this excellent article: "A Better General/NSLog" at http://www.borkware.com/rants/agentm/mlog
or its follow up at Hopeless Geek ( http://www.hopelessgeek.com/2005/11/18/better-logging )  Simple to implement and will provide file, function and line number of the log call.

----

**Backtrace All Threads**

"t a a bt" in gdb's console will get you a backtrace of all threads, not just the current one.  (The full command is "thread apply all backtrace", but gdb will accept abbreviations.)

----

**Environment Variables That Affect Your App**


Read     /System/Library/Frameworks/Foundation.framework/Versions/C/Headers/General/NSDebug.h for interesting environment variables you can set to get extra debugging information.  General/NSZombieEnabled, for example, will tell you if you are sending messages to objects you have released.  On 10.4 and below, an important exception is that General/NSZombie does **not** work with any 'toll free bridged' class.  So General/NSZombie won't help you with catching over releases of General/NSStrings, etc.  General/CFZombieLevel however will help in those cases. On 10.5, General/NSZombie works with all classes, so General/CFZombieLevel is not needed.

One way to set this variable is to select "Edit Active Target" from the Project menu, choose the "Executables" tab, then the "Env Vars" tab.  Add a variable called General/NSZombieEnabled, with value YES.

----

**Breaking on Exceptions**

*Note: "Double-Click for Symbol" no longer exists in General/XCode 4*

You can break into the debugger whenever an exception is raised.  Go to the Breakpoints window in Xcode, and double click "Double-Click for Symbol".  Add a breakpoint for "-General/[NSException raise]" and for "objc_exception_throw" to the breakpoints list.

You can also accomplish this from the gdb console by entering "b -General/[NSException raise]" or "fb -General/[NSException raise]", and then the same command for     objc_exception_throw. The latter is not frequently encountered in Tiger but is essential in Leopard, as much of the internal Cocoa code has moved to     @throw which bypasses     -General/[NSException raise] and will not trigger a breakpoint set there.  You might want to add these to your ~/.gdbinit file.

When stopping at objc_exception_throw the exception object is stored in $edx ($rax on x86_64), you can print information about the exception in the gdb console like so:
    
(gdb) po [$eax className]
General/NSException
(gdb) po [$eax name]
General/NSAccessibilityException
(gdb) po [$eax reason]
<object returned empty description>
(gdb) po [$eax userInfo]
{
    General/NSAccessibilityErrorCodeExceptionInfo = "-25205";
}


----

**Talking to Objects**

General/NSLog(@"%@", anyObject) will send -description to anyObject, and print the results. This replaces the 'printf' method of debugging from C.  Cocoa collection and data classes implement -description to print out a human-readable dump of the object's contents; most Cocoa classes use the General/NSObject default implementation of -description which prints the object class name and address in memory. So, for example, if anyObject is a dictionary, the output will be a list of the key-value pairs in the dictionary. (The values will each get sent -description as well, and so on...). Note, however, that if the object is being observed by way of KVO, the -description method is broken, this is due to the 'isa-swizzling' used under the hood.

You can do the same thing from the gdb console: type "po anyObject".

If you are really feeling like a daredevil, you can even call arbitrary Objective-C code from gdb! For example, "po General/array objectAtIndex:2] objectForKey:@"foo"]". Watch out though -- if the code throws an exception you might find yourself unable to continue debugging. But you can avoid that by tweaking a parameter in gdb: "set unwindonsignal on" before you do it. You might want to add that to your ~/.gdbinit file.

----
[[[NSObject description] is not that good at times,  i highly depend on General/CFShow() for clear details , for example consider the following :
    
	General/NSDictionary *dict = General/[[NSFileManager defaultManager] attributesOfItemAtPath:path error:NULL];
	General/CFShow([dict class]);
	General/CFShow(General/[[NSDictionary dictionaryWithDictionary:dict] class]);

it returns :
General/NSFileAttributes
General/NSCFDictionary
    
General/CFShow(dict);
General/CFShow(General/[NSDictionary dictionaryWithDictionary:dict]);  

show you that there is a difference in the object , by contrast if you do just General/CFShow([dict description]); and General/CFShow(General/[[NSDictionary dictionaryWithDictionary:dict] description]) they show the same thing 
--General/VladAlexa

----

**Tracking down General/MemoryLeaks**

The page for General/ObjectAlloc has an introduction into using that application to find General/MemoryLeaks.

----
**Implement - (General/NSString *)description for Your Classes**

A typical way to implement the -description method is:

    
// Description method for General/PersonObject
- (General/NSString *)description
{
    General/NSString *desc = General/[NSString stringWithFormat:@"%@\n\ 
                                                  \tName: %@\n\ 
                                                  \tAge: %i\n\ 
                                                  \tOccupation: %@\n\ 
                                                  \tSpouse: %@",
                         [super description], // grab output from the default
                         [self name],         // name returns a string
                         [self age],          // age returns an int
                         [self occupation],   // occupation returns a string
                         [self spouse]];      // spouse returns a person object
	return desc;
}


Now     General/NSLog(@"%@", personObjInstance, nil) will print out the string you just formed. Be sure to return an autoreleased string. Remember, if the object is being observed using KVO an implementation of the -description selector may obscure your own, this is due to the 'isa-swizzling' used under the hood.

*Is it possible to use the keypath "self" to get a reference to the real object, so that -description will work?*

----

**Stack Traces in General/ObjC**

With a bit of code, you can have General/StackTraces in General/ObjC - just click on the link to see how.

----

Before working too hard fixing a problem where you think it is, make sure the problem is actually there (particularly with  crashers)  I'm a fan of temporarily #ifdefing out code and seeing if it still crashes.  if it crashes in the same place, you can pretty much exclude the code  you've just #ifdef'd out and not spend any time looking at it.  I help a friend this week track down a retain/release issue, and he was fretting for a long time over some iterator stuff, when the real problem was an init call several lines back releasing an autoreleased object.   By #ifdefing out the iterator stuff, I knew not to waste any time look at it.

Also, being able to reproduce the problem at-will is a very powerful tool.  If you can make your app crash in 5 steps (vs "I randomly click and eventually it dies"), it then becomes much easier to narrow in on the problem.

My general technique when faced with a problem is to a) try to reproduce it reliably then b) eliminate as much other code from my consideration, then c) unleash debuggers and General/CavemanDebugging to narrow in on the problem.

++General/MarkDalrymple

----
If gdb gets confused and starts spitting messages like "warning: pre-compiled symbol file random_symbol_file.syms out of date", the situation can be remedied by doing the following in the terminal:
    
cd /usr/libexec/gdb
sudo ./cache-symfiles 


++General/TimothyKukulski
----
**Assembly code**

At times, you may want to see what parameters get passed to one of Apple's methods. An assembly-language method. Well, it is possible. When a method is called, the PPC registers are assigned as follows:

*$r3 � self
*$r4 � The selector
*$r5-$r10 � Parameters

This is not the entire story if the method has a variable argument list, or takes floating-point, vector, structure (i.e. General/NSRect), or long long parameters. See http://developer.apple.com/documentation/General/DeveloperTools/Conceptual/General/MachORuntime/2rt_powerpc_abi/chapter_9_section_5.html for exceptions and details.

So if you happen to know that the first parameter (in $r5) is an General/ObjC instance, you can print it out at the     (gdb) prompt by typing:
    po $r5
or call other methods by typing something like:
    print (int)[$r5 hash]

Note that assembly-language routines will typically move these registers around ASAP, so watch out for that. The assembly statement will be "mr <to>,<from>".

�General/DustinVoss

The above works on General/PowerPC, but not on 32-bit Intel.  On 32-bit Intel, arguments to a function are passed on the stack, not in registers. 64-bit Intel restores sanity to the equation by passing arguments in registers.

Quoth the almighty Technical Note TN2124, Mac OS X Debugging Magic:
----
On General/PowerPC, a good rule of thumb is that the first parameter is in GPR3 (General Purpose Register 3), the second parameter is in GPR4, and so on. The GDB syntax for these is $r3, $r4, and so on. On return, any function result is in GPR3 ($r3).

On Intel, there are two rules of thumb.


*If you've stopped at the first instruction of a routine, the first parameter is at 4 bytes above the stack pointer, the second parameter is 8 bytes above the stack pointer, and so on. The GDB syntax is *(int *)($esp+4), *(int *)($esp+8), and so on.

*If you've stopped elsewhere in the routine (after the frame has been created), the first parameter is at 8 bytes above the frame pointer, the second parameter is 12 bytes above the frame pointer, and so on. The GDB syntax is *(int *)($ebp+8), *(int *)($ebp+12), and so on.

In both Intel cases, any function result is in register EAX ($eax).

----
**Interpreting Crash Logs**

Apple's tech note TN2123 describes interpreting the output of Crash Reporter. http://developer.apple.com/technotes/tn2004/tn2123.html

One tip: the     atos command-line utility described in the tech note will not work if you have Zerolink enabled.

----

**
Debugging Cocoa Exceptions in Codewarrior --
**


If you are using the Codewarrior debugger instead of General/XCode, it's not obvious how to drop into the debugger on an exception.  You can create a category on General/NSException to always drop into the debugger and go back up in the stack to see what happened.  Unfortunately, since you are replacing the 'raise' method, you won't see the helpful message that gets printed to the log. Does anyone know a better way to get the Codewarrior Debugger to break and still print the helpful log information?

    

@implementation General/NSException (General/StopOnException)

-(void)raise
{
	General/NSLog(@"%@", self, nil);
	assert (0);	
}

@end



----
**
Event Handling
**

See General/NSTraceEvents

----

see also General/DebuggingTechniquesDiscussion
 Pour participer   maintenir votre  numéro, vous aurez   compte   driver ( signal ) [http://obtenir-rio.info rio bouygues]. Vous obtiendrez  pour  gratuit  par appelant   mots  du serveur ou du service à la clientèle  support clients   votre propre   fournisseur de services  [http://obtenir-rio.info/rio-bouygues code rio bouygues] . Vous ne  CAN  recevez immédiatement  un SMS  avec vos . Avec  votre actuelle [http://obtenir-rio.info/rio-orange numero rio orange], alors  vous serez en mesure de vous abonner  la  offre de  de son   à propos   rouge.