Inside of a document-based program, how do you refer to the window that the document is in?  Or, the window a custom view is in?  --General/AlexanderD

----

The first question is invalid because a document may have more than (or less than, in some cases) one window. So let's expand the question "How do you refer to the windows that the document is in?"

    
General/NSEnumerator *e = General/document windowControllers] objectEnumerator];
[[NSWindowController *wc = nil;

while (wc = [e nextObject]) {
    General/NSWindow *window = [wc window];

    // now do something with the window
}


The second question is a bit easier:

    
General/NSWindow *window = [customView window];


Enjoy! -- General/MikeTrent

----

To expand a bit on window controllers, the document model is quite lovely to allow them. It basically lets you have multiple viewpoints of your document's data if you're careful. That's why there's this layer of abstraction there. Believe me, you'll love it someday if you don't already. -- General/RobRix

*Unless you want to have more than one document in the same window, then you'll hate the MDI*

----
Mike,

    Let me explain what I wanted to do in more detail.   I currently have the General/MyDocument.nib file with one window.  On this window I have a slider.  I would like the slider to control the transparency of the window using setAlphaValue:.  I have an General/IBOutlet for the slider in General/MyDocument.h and an General/IBAction called setWindowTransparency: in which I would like to have code like the following
    
 [window setAlphaValue:[sender floatValue]];

So, where do I get the window that has the slider in it?  if there were more than one window open, I would want the slider to control the window it is on.  If there were no windows open, then the slider would not exist, so there would be no problem.  How does this fit in with your code above? --General/AlexanderD

Third verse, same as the second:

    
 General/sender window] setAlphaValue:[sender floatValue;


Maybe you're asking this question because you don't have a window controller. I second (third?) Robbo, window controllers are a good idea; better than just lumping everything into your General/NSDocument class. If you are using a General/NSDocument w/o a General/NSWindowController, just make a "window" instance variable in your document, and hook it up like your example above.

-- General/MikeTrent

Mike,

Thank you, thank you, thank you.  It works and it is simple!  Now, Rob and Mike, I am ready to listen to your advice.  What is the point of a window controller?  Why is it good?  What does it offer you?  I am currently using the model (two classes) view (one custom view class) controller (myDocument class acts like the controller class) paradigm.  How does the window controller fit in here, and how does it make code more efficient, elegant, understandable, powerful, etc.?  Enlighten me. --General/AlexanderD

Sure. General/NSDocument is a document model. It's responsible for doing things like opening, saving, printing, and collecting all of the document information in one place. General/NSWindowController is a window controller. It's responsible for putting items into a window, responding to user events, and reading things off of the window again. While you can, as a convenience, entrust a General/NSDocument class do to both file I/O and user interface handling, it's better to let each object do what it does best. That is, let the window manager control the window, and the document control the window manager. It's just good programming practice. It also has practical advantages; once you separate the window handling code from the document handling code, you can easily support multiple windows per document (or, again, multiple documents per window, if you're into that kind of thing)

You do this by overriding -General/[NSDocument makeWindowControllers] instead of -General/[NSDocument windowNibName]. In your nib file, create a General/NSWindowController subclass (again, I recommend something better than General/MyWindowController, such as General/TextEditorWindowController, or whatever), and change the File's Owner to use that subclass. Create files for your General/NSWindowController subclass in IB or PB, which ever you prefer. In -General/[NSDocument makeWindowControllers], just alloc/initWithWindowNibName the window controller with the proper nib name, and call -General/[NSDocument addWindowController:] to add the window controller to the document. Easy peasy. Don't forget to add some way for your document and window controller to talk together.

-- General/MikeTrent

Thank you again, Mike.  This is starting to make sense.  It was my understanding, before, that each window was linked to a document so all the controlling of the window was done in the General/NSDocument class.  From what you say, this idea is not correct.  So, from what you're saying, I should transfer the methods and variables I had in General/NSDocument that pertain to objects in the window (buttons, text fields, custom views, sliders, progress bars, etc), into a windows controller.  This controller could even keep track of several windows (or panels?) within a particular document (right?).  For example, a program like Photoshop would have a windows controller that controlled all the panels surrounding the main document window as well as the document window itself.  Is this right? --General/AlexanderD

Sorry for the delay.

"This controller could even keep track of several windows (or panels?) within a particular document (right?)." Yes and no. Yes, your custom window controller class can be instantiated several times, once for each window. No, a specific window controller cannot refer to multiple windows. No, the document "keeps track of" multiple window controllers, but it doesn't keep track of multiple windows (unless you write a bunch of custom code -- but the whole point of Cocoa is to avoid this!)

For example, a program like Photoshop would have one unique winodw controler for every document window and utility panel on the screen. Using Safari as another example, I can think of three potential window controller opportunities: the main viewer, the downloads panel, and the preferences panel. Note that there can be multiple viewers -- meaning there would be document objects, each one with a window controller, each one in turn, managing one window. Note that there is only one download panel and preferences panel, and neither of these panels display document information (neither download stats nor preferences seem like valid "document"s) -- that's ok, there's no rule that says window controllers must be owned by documents. Window controllers are very handy even outside of the General/NSDocument model.

Here's a quick guideline. For every unique "kind of window" you have, you should have one unique "kind of window controller". 

-- General/MikeTrent

----

' ...... For every unique "kind of window" you have, you should have one unique "kind of window controller".................'

I have requoted you Mike, because, of all the waffle and crap that has been spouted by others in the past about using window controllers

and loading nibs, this one sentence gave me the insight into how to use this aspect of Cocoa properly !

It ought to be carved on the bezel of every programmers' screen ............

Chris


*There's lots of things that ought to be carved there... Maybe Apple should start making 30" screens with 15" General/LCDs?*

**Or maybe people ought to just RTFM ... :-)**

****************************************************

Here is an example that seems to work, based on the above information. If someone finds an error, please correct it.

//
//  General/MyDocument.m
//  General/LoadingWindows
//
//

//#import "General/MyDocument.h" - contents of the .h file follow to make this more compact.

/*
 1. This project was created directly from v2.4.1 of Xcode's File:General/NewProject:Cocoa Document-based Application
 
 2. Two nibs were created by first opening the General/MyDocument.nib file with IB and saving a copy first as General/FirstWindow.nib
 then a second copy as General/SecondWindow.nib.
 
 3. In both new nib files, General/NSWindowController was subclassed and called General/FirstWindowController or General/SecondWindowController respectively.
 
 4. File's Owner was set to the new window controller subclass respectively.
 
 5. The windows' text boxes were edited to change the text to First Window or Second Window.
 
 6. The Window Title in the window's Attributes was erased. the title will come from windowTitleForDocumentDisplayName: in the window controller.
 
 7. The respective nibs were saved.
 
 8. The instance of the Window was deleted in General/MyDocument.nib and the nib saved.
 
 9. This program text file was created.
 
 10. Project compiled, linked and run.
 
 11. The Second Widow will appear.
 
 What this finally illustrates is a very simple and straightforward example of how to launch multiple windows
 using multiple nibs from a single document based application. You could add as many documents as you need as well.
 
 What seems to be broken in the document model is that windowControllerWillLoadNib and
 windowControllerDidLoadNib are not called in the General/MyDocument class because the windows are
 inited with nibs whose File's Owner is set to the General/WindowController - as it should be.
 
 In order to get the Will/General/DidLoadNib methods to get called in the General/MyDocument class, you have
 to send a notification to the document from the windowWill/General/DidLoad methods in the window controller class
 and then have the document find out which window sent the notification by determining which
 window controller object originated the notification.
 
 You can see in the Run Log the General/NSLog messages to watch the sequence in which things happen. There are also
 two General/MyDocument methods not called in the example: removeAWindowController and removeAllWindowControllers.
 
 Hope it helps, God knows how long it has taken me to finally sort all this out.

NOTE: OSX 10.5 causes an exception to be thrown if an array being enumerated by an General/NSEnumerator is modified
during enumeration. A different strategy is required to remove any or all elements of an General/NSMutableArray or add to one.
The revised methods removeAllWindowControllers and removeAWindowController show two ways in which this
can be accomplished.

     
 */
#import <Cocoa/Cocoa.h>

@class General/FirstWindowController;
@class General/SecondWindowController;

General/NSDocument	*gTheDocument;

/***********************************************************************************/
@interface General/MyDocument : General/NSDocument
/***********************************************************************************/

{
}

- (void)addObservers;
- (void)removeObservers;

@end

/***********************************************************************************/
@interface General/FirstWindowController : General/NSWindowController
/***********************************************************************************/

{
}

@end

/***********************************************************************************/
@interface General/SecondWindowController : General/NSWindowController
/***********************************************************************************/

{
}

@end

/***********************************************************************************/
@implementation General/MyDocument
/***********************************************************************************/

- (id)init
{
    self = [super init];
    if (self) {
		
        // Add your subclass-specific initialization here.
        // If an error occurs here, send a [self release] message and return nil.
		[self addObservers];
    }
    return self;
}

- (void)dealloc
{
	General/NSLog(@"General/InitialAppDocument dealloc reached");
	[self removeObservers];
    General/[[NSNotificationCenter defaultCenter] removeObserver:self];

    [super dealloc];
}

- (void)addObservers
{
	General/NSNotificationCenter *nc;
	nc = General/[NSNotificationCenter defaultCenter];
	[nc addObserver:self selector:@selector(handleWindowControllerWillLoadNib:) name:@"windowControllerWillLoadNib" object:nil];
	[nc addObserver:self selector:@selector(handleWindowControllerDidLoadNib:) name:@"windowControllerDidLoadNib" object:nil];
}

- (void)removeObservers
{
	General/NSNotificationCenter *nc;
	nc = General/[NSNotificationCenter defaultCenter];
	[nc removeObserver:self name:@"windowControllerWillLoadNib" object:nil];
	[nc removeObserver:self name:@"windowControllerDidLoadNib" object:nil];
}

- (void)removeAllWindowControllers
{
	General/NSWindowController	*wc;
	unsigned	i, n;
	
	n = General/self windowControllers] count];
	for (i = n; i > 0; i--) {
		wc = [[self windowControllers] objectAtIndex:i-1];
		[self removeWindowController:wc];
	}
}

- (void)removeAWindowController:([[NSWindowController *)windowController
{
	General/NSEnumerator		*e;
	General/NSWindowController	*wc;
	General/NSArray			*theArray;
	
	theArray = General/[NSArray arrayWithArray:[self windowControllers]];
	e = [theArray objectEnumerator];
	while (wc = [e nextObject]) {
		if ([wc isKindOfClass:[windowController class]]) {
			[self removeWindowController:wc];
		}
	}
}

- (void)makeWindowControllers
{
	General/NSWindowController *aController;

	aController = General/[[FirstWindowController allocWithZone:[self zone]] init];
    [self addWindowController:aController];
    [aController release];
	
	aController = General/[[SecondWindowController allocWithZone:[self zone]] init];
    [self addWindowController:aController];
    [aController release];
}

- (void)showWindows
{
	General/NSLog(@"showWindows reached");
	General/NSEnumerator *e = General/self windowControllers] objectEnumerator];
	[[NSWindowController *wc = nil;
	while (wc = [e nextObject]) {
		if ([wc isKindOfClass:General/[SecondWindowController class]]) {
			General/wc window] makeKeyAndOrderFront:self];
		}
	}
}

- (void)windowControllerWillLoadNib:([[NSWindowController *)windowController
{
	General/NSLog(@"windowControllerWillLoadNib reached");
	[super windowControllerWillLoadNib:windowController];
	if ([windowController isKindOfClass:General/[FirstWindowController class]])
	{
		General/NSLog(@"windowControllerWillLoadNib First Window reached");
	}
	if ([windowController isKindOfClass:General/[SecondWindowController class]])
	{
		General/NSLog(@"windowControllerWillLoadNib Second Window reached");
	}
}

- (void)windowControllerDidLoadNib:(General/NSWindowController *)windowController
{
	General/NSLog(@"windowControllerDidLoadNib reached");
	[super windowControllerDidLoadNib:windowController];
	if ([windowController isKindOfClass:General/[FirstWindowController class]])
	{
		General/NSLog(@"windowControllerDidLoadNib First Window reached");
	}
	if ([windowController isKindOfClass:General/[SecondWindowController class]])
	{
		General/NSLog(@"windowControllerDidLoadNib Second Window reached");
	}
}

- (void)handleWindowControllerWillLoadNib:(General/NSNotification *)aNotification
{
	General/NSLog(@"handleWindowControllerWillLoadNib reached");
	[self windowControllerWillLoadNib:[aNotification object]];
}

- (void)handleWindowControllerDidLoadNib:(General/NSNotification *)aNotification
{
	General/NSLog(@"handleWindowControllerDidLoadNib First Window reached");
	[self windowControllerDidLoadNib:[aNotification object]];
}
@end

/***********************************************************************************/
@implementation General/FirstWindowController //General/NSWindowController
/***********************************************************************************/

// standard window init
- (id)init
{	
	General/NSLog(@"First window controller init reached");
    self = [super initWithWindowNibName:@"General/FirstWindow"];
    return self;
}

- (void)dealloc
{
	General/NSLog(@"General/FirstWindowController dealloc reached");
    General/[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

// this gets called when a typical window is loaded from the General/FirstWindow.nib file
- (void)windowWillLoad
{
	General/NSLog(@"General/FirstWindow windowWillLoad reached");
    [super windowWillLoad];
	General/[[NSNotificationCenter defaultCenter] postNotificationName:@"windowControllerWillLoadNib" object:self];
}

// this gets called when a typical window is loaded from the General/FirstWindow.nib file
- (void)windowDidLoad
{
	General/NSLog(@"General/FirstWindow windowDidLoad reached");
    [super windowDidLoad];
	General/[[NSNotificationCenter defaultCenter] postNotificationName:@"windowControllerDidLoadNib" object:self];
}

- (General/NSString *)windowTitleForDocumentDisplayName:(General/NSString *)displayName
{
	return @"First Window";
}

@end

/***********************************************************************************/
@implementation General/SecondWindowController
/***********************************************************************************/

// standard window init
- (id)init
{
	General/NSLog(@"Second window controller init reached");
    self = [super initWithWindowNibName:@"General/SecondWindow"];
    return self;
}

- (void)dealloc
{
	General/NSLog(@"General/SecondWindowController dealloc reached");
    General/[[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

// this gets called when a typical window is loaded from the General/FirstWindow.nib file
- (void)windowWillLoad
{
	General/NSLog(@"General/SecondWindow windowWillLoad reached");
    [super windowWillLoad];
	General/[[NSNotificationCenter defaultCenter] postNotificationName:@"windowControllerWillLoadNib" object:self];
}

// this gets called when a typical window is loaded from the General/SecondWindow.nib file
- (void)windowDidLoad
{
	General/NSLog(@"General/SecondWindow windowDidLoad reached");
    [super windowDidLoad];
	General/[[NSNotificationCenter defaultCenter] postNotificationName:@"windowControllerDidLoadNib" object:self];
}

- (General/NSString *)windowTitleForDocumentDisplayName:(General/NSString *)displayName
{
	return @"Second Window";
}

@end

-------------- Regards...
--Scott Hamilton