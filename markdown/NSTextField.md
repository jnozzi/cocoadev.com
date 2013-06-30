General/AppKit

General/NSTextField : General/NSControl : General/NSView : General/NSResponder : General/NSObject

http://developer.apple.com/library/mac/#documentation/Cocoa/Reference/ApplicationKit/Classes/NSTextField_Class/Reference/Reference.html

Below are some relevant General/CocoaDev articles. You can list articles here by including \\%\\%BEGINENTRY\\%\\%General/NSTextField\\%\\%ENDENTRY\\%\\% somewhere in the article.

[Topic]

To handle start and end of editing session, use one of these delegate methods:

    
-controlTextDidBeginEditing:
-controlTextDidEndEditing:


To control a gain or loss of "focus" in your text-field, use one of these methods:

    
   -(BOOL)becomeFirstResponder
   -(BOOL)resignFirstResponder


You can tell which General/NSTextField's value changed from inside a     -controlTextDidChange: message by getting the delegate of the field editor and comparing its pointer value with the pointer values for your General/NSTextField instances. For example:

    
   - (void)controlTextDidChange:(General/NSNotification *)nd
   {
      General/NSTextField *ed = [nd object];
      
      if (ed == hostName) [self hostNameChanged];
      if (ed == displayName) [self displayNameChanged];
   };


Detect keyDown events in a delegate of General/NSTextView:
    
   - (BOOL)control: (General/NSControl *)control textView:(General/NSTextView *)textView doCommandBySelector: (SEL)commandSelector 
   {
      General/NSLog(@"entered control area = %@",General/NSStringFromSelector(commandSelector));
      return YES;
   }


----
Interesting tech note on recognizing tab and enter in General/NSTextField:
http://developer.apple.com/qa/qa2006/qa1454.html

----
I'm subclassing General/NSTextField so that I can invoke my own code in the becomeFirstResponder method.  So far so good, but then I discovered that the code I put in that method does not know about my app's controller instance.  If I could just send any message at all to my controller instance, like this:

    
   - (bool) becomeFirstResponder 
   {
       bool  superResult=[super becomeFirstResponder] ;
       [myController firstResponderChanged];
       return superResult; 
   }


Then I could do whatever I wanted in my controller's firstResponderChanged method.

However, in the above code example, "myController" is fictional, and despite searching high and low with Google and Apple's own Cocoa reference materials, I can't figure out how to refer to my controller instance in code.  (In my controller's own methods, I can use "self", but that doesn't help in this case.)  Interface Builder shows my controller class instance as an icon, but doesn't seem to have any instance name for it -- just its class name.  Its info box (Attributes, Connections, etc.) also didn't help.

Any ideas?

Much thanks --General/DarelRex@gmail.com

----

If your using bindings you should be able to just do this:

    
   id controller = General/self infoForBinding:contentAttributeKey] objectForKey:@"[[NSObservedObject"];


If not, then you could add a controller ivar to your subclass with appropriate getter/setter methods, but I'm not really sure thats the best idea.

-- j

----
Or just add an General/IBOutlet. It's the standard thing to do and it works just fine.

On another note,     bool is not the same as     BOOL and if the system expects you to return     BOOL then you should do that, as there is no guarantee that the calling conventions will be compatible.

----
Thanks for the valuable info, all.  I am changing that to BOOL (hopefully my compiler warning will then go away!).

Researching bindings and outlets, it suddenly occurred to me that since my controller is already hooked up as the delegate of my subclassed text fields, I could just do this:

    
   [_delegate firstResponderChanged];


It works!   :)  --General/DarelRex@gmail.com

----
You'll note this comment in the interface of General/NSTextField:     /*All instance variables are private*/. So while it's legal to access the     _delegate ivar directly, it's much better to use     [self delegate] instead.

----
Thanks for the tip -- especially since _delegate refuses to compile when I try to use it in a subclass of General/NSTextView.  I will use [self delegate] instead.  --General/DarelRex@gmail.com

----
I want the user to be able to drag-and-drop a file onto an General/NSTextField and have the file's path displayed in the General/NSTextField. This works for the most part since drag-and-drop is provided for free. However, when the user drags-and-drops a file onto an General/NSTextField that already contains text, the path is just inserted into the text. I'd like the text of the General/NSTextField to be replaced. Any idea on how to do that? Thanks!

----
Q. I read in General/NSTextField class reference that it implements     textDidBeginEditing and     textDidEndEditing delegate methods, but they don't seem to work (at least for me). Am i doing something wrong? I declare them in my controller's header and implement them in implementation file. Should i use General/NSControl delegate methods instead? I'm a bit confused -- General/EimantasVaiciunas

----
A. You should use 

    
   - (void)controlTextDidChange:(General/NSNotification *)aNotification
, 

    
   - (void)controlTextDidBeginEditing:(General/NSNotification *)aNotification
, and 

    
   - (void)controlTextDidEndEditing:(General/NSNotification *)aNotification
. 

Yes, the documentation for the delegate methods is in General/NSControl. -- General/AralBalkan