

A scripting language used on web pages, and originally created by Netscape. General/JavaScript offers basic interaction, but no file system access. If you're interested in adding General/JavaScript capabilities to your applications, the Mozilla General/JavaScript engine is open-source - get it from http://www.mozilla.org/

Also check out Rhino from the same site ( http://www.mozilla.org/rhino ) which is a General/JavaScript implementation in Java, with a command line interface. It's bundled with JSC which is the General/JavaScript to Java byte-code compiler (do I have to point out how wildly cool this is?).

--General/TheoHultberg

----

General/JavaScript for OSA adds the possibility of writing General/AppleScript in General/JavaScript (with the mozilla engine!), look for it here: http://www.latenightsw.com 

--General/TheoHultberg

----

General/JavaScript is an interesting language to program in; it is not object oriented in the same way as General/ObjC, C++ and Java is, where every class inherits form other classes in a tree-like structure. In General/JavaScript inheritance is created by something called prototypes. 

There are no real classes in General/JavaScript everything is objects, and new objects are made by calling a function that acts as a constructor (init in General/ObjC), the function itself is an object. Instance variables can be added on the fly, wherever, whenever, some examples:

    

// General/MyClass is a constructor function for General/MyClass, not a real class,
// but as close as one gets
General/MyClass = function( name ) {
   // an instance variable
   this.name = name;

   // a method
   this.sayHello = function( ) { alert( "Hello my name is " + this.name ); }
}

// let's try, so long everything looks like General/ObjC/Java...
var myObject = new General/MyClass( "Theo" );

// shows the value of the instance variable called name
alert( myObject.name );

// alerts "Hello my name is Theo"
myObject.sayHello();

// let's do some unconventional (not-like-General/ObjC-C++-Java) things:

// add a new instance variable to myObject:
myObject.surname = "Hultberg";

// another way of doing the same thing, showing that General/JavaScript 
// objects really are dictionaries/associative arrays
myObject["surname"] = "Hultberg";

// this is cool: add a new method to the object:
myObject.saySurname = function( ) { alert( this.surname ); }

// let's do some very odd and cool things, showing the power 
// of prototypes. so long we have just modified the actual object
// now we will modify all objects created with General/MyClass:

// add an instance variable
General/MyClass.prototype.className = "General/MyClass";

// add a method to all objects of this type
General/MyClass.prototype.toString = function( ) { return "[object General/MyClass]"; }

// note that these are NOT class methods, but new instance methods
// so when I do this, I get "[object General/MyClass]"
alert( myObject.toString() );




General/JavaScript is really the coolest scripting language there is, I'd love to see a CLI version of it, with access to the filesystem and GUI-routines. Most people just thinks it's a C-style scripting language for the web, but it's not. 

There is actually a CLI version in Rhino, see above. [late edit]

-- General/TheoHultberg


RUMOR has it that Mac OS X 10.2 will be scriptable not just by General/AppleScript, but also via General/JavaScript !!!  Your CLI wish just may come true sometime late this summer.  :)

Bummer that it didn't (current version is now 10.2.2 and no General/JavaScript)...


Well, as posted above, it already is, just not made-by-apple (see www.latenightsw.com). It would be nicer if apple did it, since then it would be more integrated, now one needs General/JavaScript for OSA. General/AppleScript is far from the CLI, though. It would be cool to be able to make General/JavaScript-Cocoa-apps in General/AppleScriptStudio though. 

--General/TheoHultberg

----
Apple's recent contribution to the KDE kjs project (http://www.opensource.apple.com/projects/others/General/JavaScriptCore-0.2.tar.gz) is a nice sign.

----

Brendan Eich, the creator, talks about his creation and where it's heading: http://weblogs.mozillazine.org/roadmap/archives/008325.html

-- Theo

----

Apple's General/JavaScript implementation includes a kind of bridge (similar in spirit to Cocoa-Java, General/AppleScript Studio, General/PyObjC et al.) between Objective-C objects and General/JavaScript. It can make Objective-C objects behave like General/JavaScript objects when used by JS code, and allows access to JS objects from the Objective-C side by using proxies and setValue:forKey: / valueForKey:. However, I don't know if it can handle some features that are usually essential for code to be completely useable to create a full Cocoa app (i.e. subclassing), although I'm surprised Apple didn't create an General/AppleScript Studio-like environment in Xcode for JS. See the plugin architecture for Dashboard for a demonstration of what General/JSCore can do on the Objective-C side. -- l0ne aka General/EmanueleVulcano