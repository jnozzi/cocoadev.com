**Question: How can I enable or disable controls within a utility window (floating tool bar) based on the selection in the front most document?** 

**Answer:** 
Use the responder chain.

The responder chain is a critical design pattern in Cocoa and one of  
the great strengths of Cocoa.  Automatic menu validation (and much  
more) works based on the responder chain.  Maintaining the state of a  
tool bar can/should also work based on the responder chain.

One implementation is to override -update in the subclass of General/NSPanel  
that contains the tool bar or use the General/NSWindowDidUpdateNotification.

*
- (void)update

Updates the window. The default implementation of this method does  
nothing more than post an General/NSWindowDidUpdateNotification to the  
default notification center. A subclass can override this method to  
perform specialized operations, but should send an update message to  
super just before returning. For example, the General/NSMenu class implements  
this method to disable and enable menu commands.
An General/NSWindow is automatically sent an update message on every pass  
through the event loop and before it's displayed onscreen. You can  
manually cause an update message to be sent to all visible General/NSWindows  
through General/NSApplication's updateWindows method.
See Also: -setWindowsNeedUpdate: (General/NSApplication), -updateWindows 
 
(General/NSApplication)  http://developer.apple.com/documentation/Cocoa/Conceptual/General/WinPanel/Concepts/General/HowWindowIsDisplayed.html
*


Inside your -update method or General/NSWindowDidUpdateNotification handler,  
for each control on the tool bar, use 
    
General/[NSApp targetForAction:[currentControl action] to:[currentControl target]  
   from:currentControl].  


If the value returned is nil, disable the  
control.  If the value is non-nil, further interrogate the returned  
object to manage the state of the toolbar control.


*
- (id)targetForAction:(SEL)anAction to:(id)aTarget from:(id)sender

Finds an object that can receive the message specified by the  
selector anAction. If anAction is NULL, nil is returned. If aTarget  
is nil, General/NSApp looks for an object that can respond to the message - 
that is, an object that implements a method matching anAction. If  
aTarget is not nil, aTarget is returned. The search begins with the  
first responder of the key window. If the first responder does not  
handle the message, it tries the first responder's next responder and  
continues following next responder links up the responder chain. If  
none of the objects in the key window's responder chain can handle  
the message, General/NSApp asks the key window's delegate whether it can  
handle the message.
If the delegate cannot handle the message and the main window is  
different from the key window, General/NSApp begins searching again with the  
first responder in the main window. If objects in the main window  
cannot handle the message, General/NSApp tries the main window's delegate. If  
it cannot handle the message, General/NSApp asks itself. If General/NSApp doesn't  
handle the message, it asks the application delegate. If there is no  
object capable of handling the message, nil is returned.
See Also: -sendAction:to:from:, -tryToPerform:with:, - targetForAction:"
*

----
**Question: I would never in a million years have thought  of this.  How did you know to try this ?**

**Answer:**

I agree that this powerful technique is not well covered in Apple's documentation or examples.  
A quick search of Apple's example code on my disk reveals that there  
are no examples on my disk that use -update:.  It used to be that  
Draw.app, the predecessor to Sketch.app, used -update: and  
General/TextEdit.app probably did too.  It is slightly ironic that by  
providing automatic menu validation, a document architecture, and  
other features in the framework, Apple may have inadvertently  
obscured lower level techniques. 

**On the other hand, are you sure that simply setting the toolbar item targets to nil doesn't give you the desired effect? --General/JediKnil**

Setting the target to nil will make it send its action to the responder chain. However, this can lead to very odd behavior. For example, it is possible to activate the toolbar button of a non-main, non-key window by holding down Command while clicking it. If the toolbar item's target were nil, then it would end up sending its action to the key or main window, which is not likely to be correct. -- General/PrimeOperator