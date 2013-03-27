

(usually spelled Java)

Java is a modern object oriented programming language from General/SunMicrosystems. In theory it can run on any General/OperatingSystem that has a General/JavaVirtualMachine (General/JavaVM), which makes it General/CrossPlatform in a way that previously only a General/ScriptingLanguage could be.

You can program Cocoa applications in Java through General/AppleComputer's General/JavaBridge General/XcodeObjCJavaBridge

http://java.sun.com/

http://wiki.java.net/bin/view/Javapedia/General/WebHome  General/JavaPedia -- a wiki for all things Java  (June 20, 2003)

----

Actually, you don't need to use the General/JavaBridge, explicitely... you just use the Java Cocoa classes and everything works fine (they use the bridge internally to call the Objective-C cocoa classes).

If you're a Java developer, you don't need to learn Objective-C to do Cocoa development.  Its fun and easy to do, though.

General/JayPrince

----

If you expect to be taken seriously as a Cocoa developer, however, you're going to have to use Objective-C rather than Java. The use of Java with Cocoa has been deprecated by Apple and the bridge is already missing some key classes and technologies (e.g. General/CoreImage.)