Effective Use of the Objective-C/Java Bridge
----
Author: [[AlainODea]]

Last Update: October 20, 2004 ([[EvanSchoenberg]])
----
Getting and using Java objects in Objective-C Cocoa projects is easy once you figure it out. Unfortunately, Apple's documentation on using the Objective-C/Java Bridge is not only scarce, it is also inaccurate. The goal of my hint is to provide you with the ability to develop a project including your own Objective-C code, Java library classes, and your own Java classes.

The primary advantage of the Java bridge is access to functionality provided by the [[JavaClassLibrary]] that is either non-existent or inconvenient in Cocoa. 

I have verified that the same steps work for any Objective-C project type. However, in the interest of providing a simple working demo, my explanation will use a Foundation tool.

Follow these steps to see the Objective-C/Java Bridge in action:

*Open Project Builder/Xcode
*Create a new Foundation project called <code>[[HelloBridge]]</code>
*Create a new Pure Java Package target called
<code>[[JavaClasses]]</code>
*Add the [[JavaClasses]] product to the resources build step of the [[HelloJava]] target
*Create a new Java class called
<code>[[HelloBridge]].java</code>
Content:
<code>
public class [[HelloBridge]] {
   private String string = "Hello";

   public void setString(String string) {
      this.string = string;
   }

   public String getString() {
      return this.string;
   }

   public void printString() {
      System.out.println(this.string);
   }
}
</code>
*Add
<code>[[HelloBridge]].java</code>
To build phase
<code>Sources </code>
In target
<code>[[JavaClasses]]</code>
*Create a new empty file called
<code>[[JavaInterfaces]].h</code>
And add it to target
<code>[[HelloBridge]]</code>
Content:
<code>
// Provide Objective-C interfaces for the Java classes
// Not only good practice, it provides Code Sense
@interface java_util_Vector : [[NSObject]]
{}
- (void)add:(id)anObject;
- (id)get:(int)index;
@end

@interface [[HelloBridge]] : [[NSObject]]
{}
- (void)setString:([[NSString]] '')string;
- ([[NSString]] '')getString;
- (void)printString;
@end
</code>
*Modify
<code>main.m</code>
Content:
<code>
#import <Foundation/Foundation.h>
#import "[[JavaInterfaces]].h" 
int main (int argc, const char '' argv[]) {
   [[NSAutoreleasePool]] '' pool = [[[[NSAutoreleasePool]] alloc] init];
   
   // Load the Java VM
   id vm = [[NSJavaSetupVirtualMachine]]();
   
   // Start the Java class loader
   // no need to provide &vm, since we just got it above
   [[NSJavaClassesFromPath]]([[[NSArray]] arrayWithObject:[[[[NSBundle]] mainBundle] pathForResource:@"[[JavaClasses]]" ofType:@"jar"]], nil, YES, nil);
   
   // Load a new instance of the java.util.Vector Java class into an Objective-C pointer
   java_util_Vector '' vector = [[NSJavaObjectNamedInPath]](@"java.util.Vector", nil);
   [vector add:@"one item!"];
   [[NSLog]](@"item 1=%@",[vector get:0]);
   [vector release];
   
   // Load a new instance of our custom [[HelloBridge]] Java class into an Objective-C pointer
   [[HelloBridge]] '' hello = [[NSJavaObjectNamedInPath]](@"[[HelloBridge]]", nil);
   [[NSLog]](@"item 1=%@",[hello getString]);
   [hello setString:@"Test"];
   [[NSLog]](@"item 1=%@",[hello getString]);
   [hello printString];
   [hello release];
   
   [pool release];
   return 0;
}
</code>
*Build the target <code>[[JavaClasses]]</code> *Build and Run the target <code>[[HelloBridge]]</code> *The standard output should show the two timestamped [[ObjC]] [[NSLog]] entries and one plain [[JaVA]] System.out.println() entry


----

Problems:

*Your code crashes with the call to [[NSJavaClassesFromPath]]() when I follow your instructions.
*How does the application product find the [[HelloBridge]].class without adding it to the target in some way?
*There was also a redundant instruction about adding [[HelloBridge]].java to the [[JavaClasses]] target.
*The string constant in a ''.java file should not have the "@" symbol for an [[NSString]] constant.


I've made some changes which fixed the problem for me. � [[BrentGulanowski]]

----
Relevant Links:

[[JaVA]] [[JavaBridge]] [[JavaVersusObjectiveC]] [[CallingObjCFromJava]]

----

I'm having another problem with using the Java Bridge via Objective-C. I've got a jar that I've compiled with Eclipse that causes errors like this:

<code>
Java [[HotSpot]](TM) Client VM warning: Attempt to guard stack yellow zone failed.
Java [[HotSpot]](TM) Client VM warning: Attempt to guard stack red zone failed.
2004-09-20 18:50:18.785 [[HelloBridge]][29049] [[NSJavaVirtualMachine]]
2004-09-20 18:50:18.786 [[HelloBridge]][29049] <[[NSJavaVirtualMachine]]: 0x328720>
com.apple.misc.[[BundleClassLoader]]@40e45a: while trying to define archiveresource:file:/Volumes/Clarke/Users/brentgulanowski/Programming/PB builds/[[JavaClasses]].jar/+/[[HelloBridge]].class, (null), got throwable: java.lang.[[UnsupportedClassVersionError]]: Unsupported major.minor version 48.0
java.lang.[[UnsupportedClassVersionError]]: Unsupported major.minor version 48.0
	at java.lang.[[ClassLoader]].defineClass0(Native Method)
	at java.lang.[[ClassLoader]].defineClass([[ClassLoader]].java:488)
	at java.lang.[[ClassLoader]].defineClass([[ClassLoader]].java:423)
	at com.apple.misc.[[BundleClassLoader]].getClassesFromLocations([[BundleClassLoader]].java:158)
	at com.apple.misc.[[BundleClassLoader]].getClassesFromResourceLocator([[BundleClassLoader]].java:115)
</code>

[[JavaClasses]] is a jar just like in the tutorial above. But that jar references another jar called JXTA.jar (http://www.jxta.org). I try to access a class from JXTA in my test Java class and that leads to the error. I would really like some help, if possible. Any Java gurus around? � [[BrentGulanowski]]

----

Brent, I've run into the same problem.  It seems that the [[NSJavaVirtualMachine]] class insists upon loading Java 1.3.1, even though a later version may be installed... and if your .jar file requires a later version (say, 1.4.2, which is the current version as of this writing), then it has a major.minor version of 48.0 and gets rejected by the [[ClassLoader]].

I haven't found a workaround yet; Apple indicates here ( http://developer.apple.com/documentation/Java/Reference/Java14JavaDict/[[KeysValues]]/chapter_3_section_1.html ) that [[JVMVersion]] is needed in the .plist to specify a version other than 1.3.1, but this only seems to work for a double-clickable app which is loading a jar, not for a Cocoa program loading the [[NSJavaVirtualMachine]] to load the jar. � [[EvanSchoenberg]]

Evan, I have succeeded in getting the JVM 1.4 to load properly.

I've found that if you want to use code that requires 1.4, you have to change at least one other of two settings and maybe both of them, but that these settings are (as far as I can find) only exposed in legacy targets. Next to the JVM version setting (Legacy target->Settings->Java Compiler Settings->Target VM Version:) is a Source Version pop up -- I set both of these to 1.4, in addition to the Info.plist entry. I don't know which of these made the difference; haven't had time to explore further. I haven't found analogous settings in Native targets. � [[BrentGulanowski]]

----

There is a simple solution for [[XCode]] and native targets.
Open your info.plist file and in the main dict add
<code>
<key>Java</key>
<dict>
	<key>[[JVMVersion]]</key>		
	<string>1.4''</string>
</dict>
</code>
it will work
Pierre Oleo

----

Everyone seems to want to call Java code from Objective-C (with good reason), but how do you go about calling Objective-C code (that I wrote myself) from Java? The only thing I can find is http://developer.apple.com/documentation/Cocoa/Conceptual/Legacy/[[JavaBridge]]/[[JavaBridge]].5.html, which doesn't seem very helpful. None of the instructions in there apply to Xcode. The reason I want to do this? Using a Java framework, I am trying to find out what the inheritance chain of an Objective-C class is (by name), and there's really no way to do that...as far as I can see, I'm stuck!

--[[JediKnil]]

----

[[JediKnil]], you might want to have a look at this page: http://www.montagetech.com/developer_bridget.html. I agree with you that Apple should update the [[JavaBridge]] and provide some better documentation for it. Browsing through the cocoa mailing lists, there's clearly interest in the technology. I'm still holding out faint hope that Apple will make Java a true peer of Objective-C in 10.4, although it's probably just wishful thinking on my part. I'm currently looking into the feasibility of writing an open-source version of the [[JavaBridge]] in my spare time (see the [[JavaBridge]] page for more info). Let me know if you have any thoughts on the subject.

-[[EricWang]]

----

Thanks Eric, that really helped me...almost. I can build a library in objc, create a java object, and ''attempt'' to call a method. No good. The Java Bridge throws me back with a link error:

<code>[[AppKitJava]]: uncaught exception java/lang/[[UnsatisfiedLinkError]] (className)</code>

I looked at the stub files generated by bridget, and I don't see any obvious mistakes. Of course, they're written using macros in macros in macros and lots of crowded syntax, so I don't understand ''much'' of it. It's just the methods -- I don't see what I'm doing different than the Montage people...

Thanks again for your first link. If you have any suggestions...

[EDIT: Never mind :) I was using the wrong version of the library. Thanks again for the link. I put up step-by-step instructions on the page [[CallingObjCFromJava]].]

--[[JediKnil]]

----

Hey folks- I'm having some fun with this Java Bridge stuff.  First of all, I was receiving warning messages:

Java [[HotSpot]](TM) Client VM warning: Attempt to guard stack yellow zone failed.
Java [[HotSpot]](TM) Client VM warning: Attempt to guard stack red zone failed.

so, I changed my info.plist to declare the JVM as 1.4.  That results in the following warning messages:

Java [[HotSpot]](TM) Client VM warning: Attempt to protect stack guard pages failed.
Java [[HotSpot]](TM) Client VM warning: Attempt to deallocate stack guard pages failed.

no idea what these error messages are (I have tried Googling them but no luck).  However, I am able to load Java objects and access functions just fine if I am doing simple set/get operations.  If I try something more complicated like using a Java object to connect to a database, then things get messed up.  I have my java-accessing-code inside exception handling and the exception always comes back as:

java/lang/[[OutOfMemoryError]]

Anyone have any ideas?  I would really like to abstract my database connection/ querying code into Java classes...

Thanks for the help
-Ryan

----

Sorry Ryan, no ideas here...I don't know much about [[HotSpot]]. In general, I think the top example is pretty messy...see http://cocoadevcentral.com/articles/000024.php for a slightly easier example. Also notice the format for multiple-argument call to a Java class, as well as two alternative constructer formats, one which supports arguments:
<code>
// Adds the string "test" to the vector at position 1
[myJavaVector add:1 :@"test"];

// New vector, returns id, could also be alloc-init
[[[NSClassFromString]](@"java.util.Vector") new];

// Varargs constructor
[[[NSClassFromString]](@"java.util.Vector") newWithSignature:@"(Ljava/util/Collection;)", someCollection, nil];
// This uses all parameters as arguments to the Java constructor with the specified
// method signature (look at the [[CocoaDevCentral]] link above for more info).
</code>
--[[JediKnil]]

----

Using information from this page and several others I think I've figured out how to incorporate 3rd party Java JAR files into a Cocoa project. It took experimenting with a Cocoa-Java project and carrying settings over to the straight Java project. In the end it worked yet I was left with some questions...

- warning messages still appear re: the Java Hotspot VM and its guard pages, they do not appear in the Cocoa-Java app
- what's with the different UI for editing Info.plist depending on what type of project you create??

anyways, the details are on my weblog here:
http://www.compsigh.com/entry.jsp?id=cocoajava.text

--emh

----

By the way, DTS is recommending that new development uses JNI rather than the bridge. -- [[FinlayDobbie]]

----

Is that referring to new development accessing Objective-C from Java? I haven't seen any indication that the bridge is going away for Java use by Objective-C developers. '''Apple, however, reccomends not to use it anymore and use JNI in its place.'''

''

But how is JNI supposed to help when trying to use Java objects from Objective-C ????

''

----
The JNI specification covers calling Java methods from C. Java runtimes include native libraries for interfacing with the java runtime. Look for  jni.h in the include directory. You'll need to link with jvm.lib (I beleive) in order to use the functions described in jni.h

The complete JNI tutorial can be found here:

http://java.sun.com/docs/books/tutorial/native1.1/index.html

Also look at this portion of the JNI tuturial:

http://java.sun.com/docs/books/tutorial/native1.1/implementing/index.html

--[[TimHart]]

----

This page is a great resource. Of course it wouldn't be necessary if Apple gave the proper documentation for this stuff...but I digress.

I am getting the error:

<code>
org/osaf/caldav4j/CalDAV4JException (Unsupported major.minor version 49.0)
</code>

Which we all know means that Java 1.5 is required but the JVM is running 1.4 (or less.)

So I added:
<code>

<key>Java</key>
<dict>
	<key>[[JVMVersion]]</key>		
	<string>1.5</string>
</dict> 
</code>

to my Info.plist. I also tried 1.4+, 1.4''. Nothing works. Does anyone have a reccomendation for getting Java 1.5 working in a Cocoa app?

Thanks!!!

[[BobbyRullo]]
'''UPDATE: ''' I figured it out. I needed an additional key:

<code>
    <key>[[NSJavaNeeded]]</key>
    <string>YES</string>
</code>

----

If you want to load the JVM 1.5 in a foundation shell tool, I found you can add this environment variable:

<code>
  export JAVA_JVM_VERSION=1.5
</code>

This is referenced here ( http://developer.apple.com/technotes/tn2005/tn2147.html ) under the section "Requesting a specific J2SE version" - [[DavidThorpe]]