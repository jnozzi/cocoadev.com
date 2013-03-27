I can load a nib file from my project in order to make a view with the content of that nib:

    
- (id)initWithFrame:(General/NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		if (General/[NSBundle loadNibNamed:@"content"
							 owner:self])
		[self addSubview:viewContent];
		else General/NSLog(@"Failed to load content.nib");
	}
	return self;
}


Then I can bind dynamically the objects of this nib to control them.

But why can't I simply drag a General/NSView object in my General/MainMenu.nib, "populate" it, and then make copy of this view to use "clones" in my program?

I tried this : i added a custom view to the General/MainMenu.nib file of my project and i connect an outlet "content" to my controller.

When i do this� :

    
- (General/IBAction)add:(id)sender
{
	General/MySubview *subview = [content copy];
	[mainView addSubview:subview];
	General/NSRect frame = [subview frame];
	[subview setFrame:General/NSMakeRect(0,yPosition,frame.size.width,frame.size.height)];
	yPosition += 70;
}


� it doesn't populate the subview as I did it in IB.

Is it possible to do such a thing? Maybe it's my copyWithZone: code that is not correct?

    
- (id)copyWithZone:(General/NSZone *)zone
{
	General/MySubview *copy = General/[[MySubview alloc] initWithFrame:[self frame]];
	return copy;
}


----

The copy makes a new view with the same class and the same frame. You aren't doing anything to copy subviews or other attributes.

The best way to do this is to put this view in a separate nib, and then reload the nib every time you want a new copy of it.

It's also possible to encode/decode your view with an General/NSKeyArchiver to get a deep copy of it. Something like this should work

    
General/NSData *viewData = General/[NSKeyedArchiver archivedDataWithRootObject:view];
General/NSView *deepCopy = General/[NSKeyedUnarchiver unarchiveObjectWithData:viewData];


----

It's working just fine, nice trick.

----

I'm trying to use a view 'drawn' in IB several times:First I opened my General/MainMenu.nib files and added a small view named "element" with UI element in it.Then on my main window, I added custom view "myPlan" to hold the several "element" views.A button is used to add the elements, here is the code of the add: method

    

@interface Controller : General/NSObject{    General/IBOutlet id plan;    General/IBOutlet id elementUI;    int yPos;}- (General/IBAction)add:(id)sender;//� more code �- (General/IBAction)add:(id)sender{	Element *myElement = General/Element alloc] initWithFrame:[[NSMakeRect(0,yPos,244,43)];	[myElement addSubview:elementUI];	[plan addSubview:myElement];	[myElement release];	yPos = yPos+44;}



So each time I press the button, I want a new element added to the plan with the UI set in IB in each element. But it's not working: the UI is added on each new element but disappears each time I add a new one. In other words, the UI appears only on the last added element. What is wrong? 

----

You need to put the element into its own nib and load a new copy each time 

----

When I do that, I have problems saving the data stored in each elements because I don't know how to bind things from different nib files.

----

Every view needs its own controller. Then in your main controller you can stick them into an array or something and talk to the views through them.