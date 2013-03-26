Apple's SimpleScripting project is located at

http://developer.apple.com/library/mac/#samplecode/SimpleScripting/Introduction/Intro.html

After downloading and building this sample application, you can use the ScriptEditor to access the single application-level property it supports: "ready".

<code>
   tell application "SimpleScripting"
      set isReady to ready
   end tell
</code>

The read-only ready property always returns a boolean "true" value.

The property is defined in the .sdef file with this code:

<code>
   <class name="application" code="capp" description="Our simple application class." inherits="application">
      <cocoa class="NSApplication"/>
      <property name="ready" code="Srdy" type="boolean" access="r" description="we're always ready"/>
   </class>
</code>

and the Objective-C code that implements the property:

SimpleApplication.h

<code>
   @interface NSApplication (SimpleApplication)
      - (NSNumber*) ready;
   @end
</code>

SimpleApplication.m

<code>
   @implementation NSApplication (SimpleApplication)
      - (NSNumber*) ready {
         return [NSNumber numberWithBool:YES];
      }
   @end
</code>

That's about all there is to this -- it really IS a simple scripting application. The ReadMe.txt file included in the sample code has more details on exactly what the application is doing. Please read it.


-----

[[HowToSupportAppleScript]]