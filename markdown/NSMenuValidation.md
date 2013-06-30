http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Protocols/General/NSMenuValidation.html

A protocol used for menu items to figure out whether or not the target allows the action method to be sent.

The example given in the documentation uses the menu title to figure out which item the method is sent for, but I'd strongly recommend using the action of the menu item instead, since the title will change with localization.

----

Here's a sample of one way to do it:

    

-(BOOL)validateMenuItem:(General/NSMenuItem *)theMenuItem
{
    BOOL enable = [self respondsToSelector:[theMenuItem action]]; //handle general case.

    if ([theMenuItem action] == @selector(doSomethingIfSomethingIsSelected:))
    {
        enable = [textView selectedRange].length > 0;
    }
    else if ([theMenuItem action] == @selector(doSomethingIfMyListIsntEmpty:))
    {
        enable = [array count] > 0;
    }
    
    return enable;
}



----

I have a small app that is really a "Cocoa Application". Because I'm using the Cocoa Bindings (General/NSArrayController and General/NSUserDefaultsController) I have made it a "Cocoa Document Based Application". However, I want to only be able to have one document window available at a time. I was trying to do this with with Menu Validation but have not managed to get it working. How do I persuade my "General/MyDocument" instance to cause the File -> New menu item to be disabled ?

----

Did you try to implement     validateMenuItem: in General/MyDocument.m and return     NO for the     newDocument: action method?

However, I do not think this is really enough -- the user would still be able to open new documents from General/AppleScript etc.

I wonder why you would want to a) limit the options of the user and b) make it document oriented, when clearly it is not!?!

--General/AllanOdgaard

----

Allan, yes I tried that - no effect. The reason for making it document oriented was the bindings - hard to do bindings easily for a non-document application (document owner). 
I could not find a suitable tutorial for using NS*Controllers in a non document-based application.
The reason  that it is not a document-based application is that it is a hardware monitor. It makes little sense for a user to create another document without a device to represent it.

----

*hard to do bindings easily for a non-document application*

Huh? Why is that? Is it because in the Nib you bind to File's Owner, which is the document? Cause you can easily mimic that for non-document applications.

Basically calling     General/[NSBundle bundleWithNibNamed:someName owner:self] will load the nib and have the calling class as File's Owner, to which you can then bind.

----

Have you got a short example that does this ? 

----

I don't know exactly what you are after. Create a simple application (non document-based), create an General/NSObject subclass in the General/MainMenu.nib and name it General/AppDelegate add a newWindow: action method and bind New... to that method.

Also add an     General/IBOutlet General/NSWindow* window to the interface of your General/AppDelegate and the code for the method should look like this:
    
- (General/IBAction)newWindow:(id)sender
{
   if(!window)
      General/[NSBundle loadNibNamed:@"General/MyWindow" owner:self];
   [window makeKeyAndOrderFront:self];
}


Now create a new empty nib, add a window, drag the General/AppDelegate.h file to this Nib, change File's Owner custom class to General/AppDelegate, connect the window outlet of the General/AppDelegate (i.e. File's Owner) to the window, and you should be set...

In the General/MyWindow.nib you can then bind to File's Owner, and you will actually bind to the General/AppDelegate object.

----

Thank you for that. I then added:

    

-(BOOL)validateMenuItem:(General/NSMenuItem *)theMenuItem
{
    BOOL enable = [self respondsToSelector:[theMenuItem action]]; //handle general case.

    if ([theMenuItem action] == @selector(newWindow:))
    {
        enable = [window isVisible]?NO:YES;
    }
    
    return enable;
}



to disable the File -> New item when the window was created.

I'm having some problems with my menu action object being the object for the window - like when using     awakeFromNib: to set things up - this is called for the General/MainMenu.nib as well as for the Window.nib. I'd like to get     awakeFromNib: called when the New... menu is chosen and the window comes up, not when when app is initialized.

----

    General/AwakeFromNib is called in both circumstances, use a boolean or let another class be responsible for the General/MyWindow.nib (probably an     General/NSWindowController subclass).

You can release the window in     windowShouldClose: and set it to     nil, but you can also just use     [window isVisible] in the menu validation code.

You should probably read at least the General/NSBundle (including the General/AppKit additions) and the General/NSWindowController documentation.

----

    [window isVisible] in the validation does the right thing - Thank You.

"let another class be responsible for the General/MyWindow.nib"

How would I do this ?

----

You are really asking extremely basic questions, I would suggest that you read some of the tutorials at http://www.cocoadevcentral.com/

I think the one about the about window or the preference pane (at http://www.cocoadevcentral.com/articles/000040.php) shows how to let another class be responsible for a nib.

But basically you just alloc/init the class, send it whatever method you want to have it laod the Nib and show the window.

If you make an General/NSWindowController subclass, that'd
    
// General/AppDelegate.m
- (General/IBAction)newDocument:(id)sender
{
   windowController = General/[[NSWindowController alloc] initWithWindowNibName:@"General/MyWindow"];
   [windowController showWindow:self];
}


You should subclass the window controller to add your code to actually handle the window etc. -- and General/MyWindow.nib should then have that window controller subclass as File's Owner.

----

The General/NSMenuValidation aspect of this was the handling of the File -> New General/NSMenuItem. However, using Menu Validation for this is the wrong approach - correctly handling General/NSWindowController subclasses is the right approach.

http://developer.apple.com/documentation/Cocoa/Conceptual/Documents/Concepts/General/WinControllersAndNibs.html

has useful information about Nibs and General/NSWindowController. Also

http://developer.apple.com/documentation/Cocoa/Conceptual/General/LoadingCode/Tasks/Componentizing.html

has an introduction to doing this correctly.

Is it better to take a document-based approach and subclass General/NSDocumentController to limit the document windows, or to take a non-document-based approach and subclass General/NSWindowController ?

----

Depends on how much you want to use from the document controller system, but generally I'd say the latter approach is the better. The things you get from the document controller sounds like things that you want to avoid.

----

I'm noticing some strange binding and menu validation behavior showing up on Leopard that does not occur in Tiger. If I have the menu item's title bound to General/NSUserDefaults (anything else?) then validateMenuItem: is not called on the item's target for that item. This is frustrating, one because it works in Tiger and two because there are circumstances when I'd like the title bound but would like to change the state on the fly during validating in a way that cannot be accomplished with bindings. Is this a Leopard bug or just one of those "oh, we changed the behavior" features.

----
This is not a fix, but removing the binding and setting the title in     validateMenuItem: ought to be a one-liner in this case.