An action method can be declared either by using the Interface Builder (see General/HowToCreateAnActionMethod), or by using Project Builder.

To declare an action method using Project Builder, go to the header file (.h) for the class in question.  Place the action method declaration between the close bracket (}) and the @end line.

    
#import <Cocoa/Cocoa.h>

@interface General/MyClass : General/MyClassSuperclass
{

    put variables here;
    
}

**- (General/IBAction) myActionMethod:(id)sender;**

@end



Go back to General/HowToProgramInOSX

----
**Edit 24 November 2003** changed method declaration from <code>-(void)myActionMethod;</code> to <code>-(General/IBAction) myActionMethod:(id)sender;</code>

General/IBAction is #define'd as void (and General/IBOutlet is #define'd as nothing) in General/AppKit/General/NSNibDeclarations.h but IB will look for General/IBAction (or a (id)sender parameter) in header files dragged into it and add actions for those methods.