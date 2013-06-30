

I need to use a method from my M**'yDocument.h/.m files
in another file - lets just call this file Example.h/.m. Normally to do this, I'd just do a #import "M**'yDocument.h", right? Well that doesn't seem to work here - when I try to use
a method from M**'yDocument in Example it just reports the method as undefined. What's wrong here? Am I missing something?

Thanks,
-General/JohnWells

----

So, which method is that? How did you declare it in M**'yDocument.h?

The above report is terribly sparse on details, so I am loathe to sign on to the notion of "#import not working".
You might, ummm, try checking your typography where the reference to the "undefined" method appears.

Or check your syntax in the way you have declared and/or defined the method in the M**'yDocument class
(for example, did you specify all the arguments (correctly)? etc. etc. blah blah)

see also General/AnatomyOfADotHFile and General/HowToDeclareAVariable

note how these discuss the matter of whether and when to import .h files in other header files
and the use of @class in forward declarations

In a routine circumstances, importing your headers is sufficient, so something may very well be peculiar in your source code.

----

What I'm trying to do is tell M**'yDocument to open a new browser window using the URL obtained through clicking on a link in an external app. This is the actual code I'm using:

    
// file General/URLHandlerCommand.m

#import "General/URLHandlerCommand.h"
#import "General/MyDocument.h"
#import "General/WebKit/General/WebView.h"

@implementation General/URLHandlerCommand

- (id)performDefaultImplementation {
    General/NSString *urlString = [self directParameter];
	
	//General/NSLog(@"url = %@", urlString);
	General/webView mainFrame] loadRequest:
   [[[NSURLRequest requestWithURL:[NSURL General/URLWithString:General/urlString stringValue] stringByAddingPercentEscapesUsingEncoding:4]
   ];

    return nil;
}

@end


And here is General/MyDocument.h:

    
/* General/MyDocument */

#import <Cocoa/Cocoa.h>

@interface General/MyDocument : General/NSDocument
{
    General/IBOutlet id backForwardView;
    General/IBOutlet id refreshView;
    General/IBOutlet id stopView;
    General/IBOutlet id urlView;
	General/IBOutlet id webView;
	General/IBOutlet id mainWindow;
	General/IBOutlet id backForwardButton;
	General/IBOutlet id googleView;
	General/IBOutlet id spinnerView;
	General/IBOutlet id urlField;
	General/IBOutlet id statusText;
}
- (General/IBAction)bfClicked:(id)sender;
- (General/IBAction)refreshView:(id)sender;
- (General/IBAction)stopClicked:(id)sender;
- (General/IBAction)goGoogle:(id)sender;
- (General/IBAction)goURL:(id)sender;
- (id)webView;
@end


loadRequest: and the like are of course handled by General/WebKit. The error reported is "'webView'" undeclared", so I suppose that technically one of the controls is not being shared.
-General/JohnWells

----

Right. OK. Technically, nonsense. You cannot send a message to an object
(well, yes, you *can* send a message to nil with no ill effects)
without getting a reference to it. In other words without an object *variable* in your other class.
In this case you have **NOT** created a webKit object in
your URL-H**'andlerCommand class yet just by referring to the one
that exists in M**'yDocument. It doesn't exist in your other class until you get a reference to it.

This goes to the heart of what an *instance* of a class is. Alternatively, you need an outlet in the other class that
points to the instance of the class that exists in M**'yDocument.

 It seems you have an accessor method that *returns* a General/WebView object from M**'yDocument.
But in URL-H**'andlerCommand you
are seeking to invoke a *method of that web view* without first obtaining a reference to it. Instead of doing that

why don't you try       [...[ [ myDocument webView ] mainFrame ] loadRequest...]

When General/SharingMethodsBetweenClasses A**'ccessorsAreYourFriends   :-)