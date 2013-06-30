My program has a main controller, a General/NSWindowController and a General/NSView.
The main controller task is to calculate and create an array of General/NSPoint so it can be drawn on the General/NSView.
After the array is created, the main controller create a General/NSWindowController and hopefully display the array on the General/NSView

I managed to pass the array to the window controller; how do I pass it to the General/NSView so the array can be drawn?
I tried to make a method that passes the array from the General/NSWindowController to the General/NSVew but after the initialization the array somehow is not copied.

    
// theView is revert to the General/DocumentViewer
// General/DocumentViewer is the subclass of General/NSView
// anArrayObject is the General/NSArray to pass to the General/NSView

theView = General/[[DocumentViewer alloc] initWithObjectArray:anArrayObject];


----
Advice From Respondent: **DON'T DO THIS!!!! Use only the instance of General/NSView that you create in your nib file!!!**
----

here is the init code for the General/DocumentViewer class

    

// Document Viewer.m

#import <Cocoa/Cocoa.h>

@interface General/DocumentViewer : General/NSView
{
	General/NSArray *arrayObject3D;
}

- (id)initWithObjectArray:(General/NSArray *)anArray;

@end

// ====================================================

// Document Viewer.h

- (id)initWithObjectArray:(General/NSArray *)anArray
{
//	General/NSLog(@"Init With anArray");
	self = [super init];
	arrayObject3D = General/[[NSArray alloc] initWithArray:anArray];
	[anArray release];	
	
	General/NSLog(@"arrayObject3D count = %d",[arrayObject3D count]); // this return value 8
	return self;
}

- (void)drawRect:(General/NSRect)rect
{
	int ul;
	General/NSLog(@"drawRect documentViewer");	
	General/NSLog(@"arrayObject3D count = %d",[arrayObject3D count]); // this return value 0
	for (ul = 0; ul < [arrayObject3D count]; ul++)
	{
		General/NSLog(@"x=%@,y=%@,z=%@",General/arrayObject3D objectAtIndex:ul] valueForKey:@"titikX"],
			  [[arrayObject3D objectAtIndex:ul] valueForKey:@"titikY"],
			  [[arrayObject3D objectAtIndex:ul] valueForKey:@"titikZ"]);
	}


	[[NSRect bounds = [self bounds];
	
	// set the background color
	General/[[GlobalVar loadColor:1] set];
	General/[NSBezierPath fillRect:bounds];
	
	// draw the path in white
	General/[[GlobalVar loadColor:0] set];
	
	// Loop dari array triangle
	General/NSPoint p;
	General/NSBezierPath *path;
}


Thanks for the Help - General/JuliusJuarsa

----

It appears that you are creating an instance of your General/NSView subclass programmatically inside your controller. I think you would be better off as a beginner to use General/InterfaceBuilder to make the instance of your view subclass, and use an accessor method to set the array object when you are ready to draw the points in it. You have not stated whether there is a view instance in your nib file, but I am guessing that there is, and therefore the instance you create programmatically in the above code is not the same instance. If this is the case, you can check by using General/NSLog to report the address of the General/NSView object which creates the array instance, and again in the drawRect: method, to see if they are one and the same. If you have connected an outlet from your window controller to the view in IB, it will not suffice for the one you create programmatically. This may be why your code fails to produce anything. You need to figure out the address of the General/NSView object that is creating the array, and the address of the General/NSView object that is receiving the drawRect: message. If they are not one and the same, your code will fail. This is a common beginner mistake.

----
You are right. I did connect an outlet from the window controller to the General/NSView and then create a new one. I tried creating an accessor method for the array in the General/NSView but it didn't work, and when i checked General/NSLog for the address of the General/NSView it shows 2 different addresses (I don't know why it called the drawRect: twice; please explain how this window controller and General/NSView things work)

updated code

    
// Viewer Controller.h
@interface General/ViewerController : General/NSWindowController
{
	General/IBOutlet General/NSWindow *theWindow;
	General/IBOutlet General/DocumentViewer *theView;
	General/NSString *windowName;	
}

- (id)initWithWindowName:(General/NSString *)aWindowName withArrayObject:(General/NSArray *)anArray;

// Accessor Method
- (General/NSString *)windowName;
- (void)setWindowName:(General/NSString *)aName;
- (void)reDrawTheWindow;

@end


// Viewer Controller.m
- (id)initWithWindowName:(General/NSString *)aWindowName withArrayObject:(General/NSArray *)anArrayObject;
{
	self = [super initWithWindowNibName:@"General/ViewerWindow"];
	[windowName release];
	windowName = [aWindowName retain];
	[aWindowName release];
	
	[theView setValue:anArrayObject forKey:@"arrayObject3D"];
	[theView setNeedsDisplay:YES];

	return self;	
}


// Document Viewer.h
@interface General/DocumentViewer : General/NSView
{
	General/NSMutableArray *arrayObject3D;
}

- (General/NSArray *)arrayObject3D;
- (void)setArrayObject3D:(General/NSArray *)anArray;

// Document Viewer.m
- (General/NSArray *)arrayObject3D
{
	return arrayObject3D;
}

- (void)setArrayObject3D:(General/NSArray *)anArray
{
	[arrayObject3D removeAllObjects];
	[arrayObject3D addObjectsFromArray:anArray];
}

- (void)drawRect:(General/NSRect)rect
{
	int ul;
	General/NSLog(@"Document Viewer Address from drawRect = %@",[self description]);
}



here is the General/NSLog message:
    
2006-04-17 07:53:36.950 3D General/QuiXplorer[23279] Document Viewer Address from drawRect = <General/DocumentViewer: 0x61128e0>
2006-04-17 07:53:36.954 3D General/QuiXplorer[23279] Document Viewer Address from drawRect = <General/DocumentViewer: 0x61125f0>


thanks for the reply - General/JuliusJuarsa

----

Your drawRect: is called twice: once when the app starts and another time for each invocation of setNeedsDisplay: YES.

You have a very spotty understanding of the interoperation of the Cocoa classes you are trying to use. It appears you still are creating an extra instance of General/NSView somewhere in one of your controller classes, otherwise you wouldn't get two different addresses in the General/NSLog you post above. Since I told you not to do that in my first reply, I can only conclude that you have somehow failed to understand the instructions I gave you. I recognize that English is perhaps not your primary language and I have tried to write as simply and plainly as I can; please read my advice again, and see if you cannot at least get rid of the extra instance of General/NSView that you seem to have in your app.

Furthermore, go back and read some of the advice YOU were given in General/ProblemLoadingNewNIB; I think you still have not absorbed some of that.

----
thanks for the reply. I have mananged to remove the second instance and now it only shows one same address. correct me if i'm wrong, from my understanding is when i create an instance of General/NSWIndowController it also create an instance of General/NSView after the initialization of the General/NSWindowController, so what i must do is to pass the array to the General/NSView before it display something right?

i managed to get it work thank for the tips, it took me 4-5 times reading to really understand it >.< .here is what i do i pass the array in the windowDidLoad: method and then call the General/NSView setNeedDisplay: it will display just i expected. since when I checked the General/NSLog the General/NSView instance is not available yet ^^

    
2006-04-18 07:19:42.175 3D General/QuiXplorer[24621] Document Viewer Address in windowWillLoad Method = (null)
2006-04-18 07:19:42.213 3D General/QuiXplorer[24621] Document Viewer Address in General/DocumentViewer = <General/DocumentViewer: 0x6112810>
2006-04-18 07:19:42.231 3D General/QuiXplorer[24621] General/DocumentViewer Address in windowDidLoad Method = <General/DocumentViewer: 0x6112810>


the second trick i use is make the array a General/GlobalVariable in the General/NSWindowController but i think it's not a wise thing to do so i decided to go with the 1st trick. thanks again for the reply. anyway i did finish reading the General/CocoaProgrammingForMacOSX by General/AaronHillegas and it really boost my understanding about cocoa.