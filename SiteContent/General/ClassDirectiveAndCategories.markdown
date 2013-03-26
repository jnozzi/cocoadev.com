This is the idea what I am using.

My mainController.h file
<code>
@class Qualification_Controller;

@interface appController : [[NSObject]]
{
    [[IBOutlet]] id qualDefSheet_NameFld;
   Qualification_Controller '' qualController;
}

-(void)awakeFromNib;

- ([[IBAction]])newQualification:(id)sender;

 @end
</code>

My maincontroller .m file
<code>
#import "appController.h"
#import "Qualification_Controller.h"

@implementation appController

-(void)awakeFromNib
{
	qualController = [[Qualification_Controller shared_QualificationControllerWithView: 
                                  ([[NSOutlineView]] '')qualDefOutline] retain ];
       ...
}

- ([[IBAction]])newQualification:(id)sender
{
	[qualController showQualificationSheet];
}
@end
</code>

The Singleton qualController.h
<code>
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

//#import "QualificationController_SheetCat.h"

@interface Qualification_Controller : [[NSObject]]
{
	[[NSWindow]]'' qualDefSheet;
...
}
+ (id) shared_QualificationControllerWithView: ([[NSOutlineView]] '')qualOutlineView ;
@end
</code>

The Singleton qualController.m
<code>
#import "Qualification_Controller.h"
@implementation Qualification_Controller 

@end
</code>

The for the Singleton qualController category.h file
<code>
#import "Qualification_Controller.h"

@interface Qualification_Controller ( QualificationController_SheetCat )

//#pragma mark -
//#pragma mark [[QualificationSheet]] - handling ( sheet controller )

- (void) showQualificationSheet;

@end
</code>

The for the Singleton qualController category.m file
<code>
#import "QualificationController_SheetCat.h"

@implementation Qualification_Controller  ( QualificationController_SheetCat )

#pragma mark -
#pragma mark awardSheet handling
- (void)showQualificationSheet
{
//open sheet
}
@end
</code>

To say it in words. A appcontroller creates a singleton qualController witch has a category. The appController sends a message to a (showQualificationSheet) methode coded in a category of qualController.

If I do insert the -showQualificationSheet' declaration in QualificationController_SheetCat.h I get 'Qualification_Controller' may not respond to '-showQualificationSheet' '

If I insert the  -showQualificationSheet' declaration in Qualification_Controller.h I get "method definition for '-showQualificationSheet' not found".

What do I wrong here? It works but I dont want those warnings!
Can someone shed some light on this?

----
You need to import the header for the category into any files which use any of the methods it declares. Specifically, add a line:
<code>#import "QualificationController_SheetCat.h"</code>
near the top of your maincontroller.m file. Without that, the compiler has no way to know that the -showQualificationSheet method has been declared for your qualification controller class. -CS
----
Thank you for your reply.

If I put <code>#import "QualificationController_SheetCat.h"</code> in the main controller I get

method definition for '-showQualificationSheet' not found
and
incomplete implementation of class 'Qualification_Controller'

Also I was thinking that if I put <code>#import "QualificationController_SheetCat.h"</code>  in the Qualification_Controller.m file, it should work to, but then I got even an error instead of warnings. This was also my first initial thought, but because it didn't work I commented it out.

cannot find interface declaration for 'Qualification_Controller'

Also, if I look at the idea behind categories, then importing the header of the class who is catergorized should be enough. Because in my feeling the category definition should be enough to let the compiler understands the whole idea.