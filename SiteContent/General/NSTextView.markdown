General/NSTextView is the front-end component of the Application Kit's text system. It displays and manipulates text laid out in an area defined by an General/NSTextContainer and adds many features to those defined by its superclass, General/NSText. Many of the methods that you'll use most frequently are declared by the superclass; see the General/NSText class specification for details.

http://developer.apple.com/library/mac/#documentation/Cocoa/Reference/ApplicationKit/Classes/NSTextView_Class/Reference/Reference.html

----

You don't often need to subclass General/NSTextView, but when you do [http://www.omnigroup.com/mailman/archive/macosx-dev/2001-May/014763.html] and [http://developer.apple.com/documentation/Cocoa/Conceptual/General/TextEditing/Tasks/Subclassing.html] are useful links to have.

----

Related pages:

[Topic]

To add a related page, put \\%\\%BEGINENTRY\\%\\%General/NSTextView\\%\\%ENDENTRY\\%\\% anywhere on it. You do not need to edit *this* page.

----

How to detect focus changes in General/NSTextView objects:  http://alienryderflex.com/hasFocus.html

----

Followup to hasFocus:  In the General/NSTextField page, a couple posters said that my technique is bad because it will waste CPU, and suggested that developers use controlTextDidBeginEditing or becomeFirstResponder instead.  I replied as follows:  "controlTextDidBeginEditing doesn't fire until the user *changes* the text. If you want to react to a focus change, it won't work. Also, if you read my article carefully, you'll notice that the polling is based on a timer that fires only 100 times per second. In my tests, this does not significantly tax the processor. I am researching becomeFirstResponder and will followup here. ... Update: I just checked out becomeFirstResponder, and it looks like it might work, but would involve subclassing General/NSTextField and General/NSTextView. No big deal, I guess, but neither is comparing a couple of values only 100 times per second. Neither technique would be necessary if the notification system told you when the user clicked in an General/NSTextField or General/NSTextView, but for some reason it won't."

----

See the General/NSTextField page for more on this topic -- some lively debate and interesting suggestions there.  --Darel Rex Finley

----

Even if you do need to subclass General/NSTextField/General/NSTextView you can do it in a generic manner and you'll be able to reuse that code for years to come! 

----

A somewhat hacky but extremely generic technique would be to simply subclass General/NSResponder, override the method to send a notification, and then use     poseAsClass: so that all responders send that notification.

----
I am (at long last) learning subclassing and getting rid of my timer.  My app will soon use truly zero processor when idle.  Hooray!  --General/DarelRex@gmail.com