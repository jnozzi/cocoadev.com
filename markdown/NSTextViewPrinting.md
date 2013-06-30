How do you print an General/NSTextView properly?  Any time I try it, it strips off a section on the right.  Can anybody help me? - General/RossDude
----
Printing is fairly simple in Cocoa. If you are doing basic print jobs, then there are two classes you need to understand in order to accomplish it:

An General/NSPrintOperation object handles the entire printing process and is normally created in the print method. In a **document-based application** you can override     printDocument: to handle the printing. In a **non-document based application** you may want to create a custom method to handle the printing and link the print menu action to it. When creating an General/NSPrintOperation, you specify the General/NSView you want to print and how you want it to print on the page using an General/NSPrintInfo object. If no print info object is specified, then it will use the shared print info object.

General/NSPrintInfo handles how the view is printed on a page (if it is centered, etc.). In a document based application each General/NSDocument has its own     printInfo object so each document can have its own print settings. In a non-document based app, you can use the     General/[NSPrintInfo sharedPrintInfo] class method to access a global print info object.

I print a few General/NSTextViews in a program, but I made a separate (non-drawn) window to arrange the printed parts. How big is your view? Is it near the right side of the page? Is it possible it's just that the margin settings are off? If you have a wide monitor (15" PB, for example), I think it's possible to create a layout that's too wide for the printer. Can you provide more info? -dan
----
I make a standard General/NSTextView.  In the program, I'll make an General/NSTextView that will have the margin settings so that the left side is at the zero mark and the right side is at the 8 1/2 mark.  When I go to print the thing, even if the General/NSTextView can contain all of the text, it chops off the section on the right, which seems to be somewhere around 6 1/2, or some weird number.  I have found this kind of thing with the General/ToolbarSample example as well.  If you try running that and printing from there, you get the same kind of thing I'm getting.  I hope that's enough info. :)

----

Here is how I do it in my document based text editor.

Make a copy of your existing General/NSTextView, set the properties on your printInfo instance, and you're done.

    
- (void)printShowingPrintPanel:(BOOL)flag
{

// set printing properties
General/MyPrintInfo = [self printInfo];
General/[MyPrintInfo setHorizontalPagination:General/NSFitPagination];
General/[MyPrintInfo setHorizontallyCentered:NO];
General/[MyPrintInfo setVerticallyCentered:NO];
General/[MyPrintInfo setLeftMargin:72.0];
General/[MyPrintInfo setRightMargin:72.0];
General/[MyPrintInfo setTopMargin:72.0];
General/[MyPrintInfo setBottomMargin:90.0];

// create new view just for printing
General/NSTextView *printView = General/[[NSTextView alloc]initWithFrame: 
	General/NSMakeRect(0.0, 0.0, 8.5 * 72, 11.0 * 72)];
//	General/[MyPrintInfo imageablePageBounds]];
General/NSPrintOperation *op;

// copy the textview into the printview
General/NSRange textViewRange = General/NSMakeRange(0, General/textView textStorage] length]);
[[NSRange printViewRange = General/NSMakeRange(0, General/printView textStorage] length]);

[printView replaceCharactersInRange: printViewRange 
	withRTF:[textView [[RTFFromRange: textViewRange]];

op = General/[NSPrintOperation printOperationWithView: printView printInfo: 
General/MyPrintInfo];
[op setShowPanels: flag];
[self runModalPrintOperation: op delegate: nil didRunSelector: NULL 
contextInfo: NULL];

[printView release];

}

-kinch

Thanks!  I'm not that great at doing printing stuff.  This is just what I need!  Thanks again. - General/RossDude

*Actually, thanks to Cocoa's modular text system architecture, you can create the entire text system beforehand and keep it around for later. Just add this kind of code in a method that's called once before you print (maybe even     awakeFromNib, and     printView will automatically keep track of any changes to your regular text view. (Note: this was taken from Apple's Text System Architecture docs) --General/JediKnil*
    
General/NSTextView *textView; // General/IBOutlet
General/NSTextStorage *textStorage = [textView textStorage];

General/NSLayoutManager *layoutManager = General/[[NSLayoutManager alloc] init];
[textStorage addLayoutManager:layoutManager];
[layoutManager release];

General/NSRect cFrame = General/NSMakeRect(0.0, 0.0, 8.5 * 72, 11.0 * 72);
General/NSTextContainer *container;
container = General/[[NSTextContainer alloc]
    initWithContainerSize:cFrame.size];
[layoutManager addTextContainer:container];
[container release];

// printView is an ivar, so you can use it later in printShowingPrintPanel: 
printView = General/[[NSTextView alloc] initWithFrame:cFrame textContainer:container];


----

**Here's an older example, that was formerly presented as the topic P**'rintFormatting**

I'm working on an app similar to a text-editor, which has a General/NSTextField containing the document's title, and a General/NSTextView containing the document's text. The trouble I'm having is when it comes to formatting them for printing. I want to have the title centered on the page, with bold type, then I want the document's text below it formatted as it is in the text view.

----

Create a new view that is the correct page size, add borders/etc and then start parsing your original text into your new view.

Here's some example code for a document based app:

    
- (General/IBAction)printDocument:(id)sender
{
    General/NSPrintOperation    *printOperation;
    
    // This will scale the view to fit the page without centering it.
    // It would be better to specify these default settings when
    // the document is created instead of in the print method.
    General/self printInfo] setHorizontalPagination:[[NSFitPagination];
    General/self printInfo] setHorizontallyCentered:NO];
    [[self printInfo] setVerticallyCentered:NO];
    
    // Setup the print operation with the print info and view
    printOperation = [[[NSPrintOperation printOperationWithView:[self printableView] printInfo:[self printInfo]];
    [printOperation runOperationModalForWindow:[self window] delegate:nil
            didRunSelector:NULL contextInfo:NULL];
}

- (General/NSView *)printableView
{
    General/NSTextView    *printView;
    General/NSDictionary    *titleAttr;

    
    // CREATE THE PRINT VIEW
    // 480 pixels wide seems like a good width for printing text
    printView = General/[[[NSTextView alloc] initWithFrame:General/NSMakeRect(0, 0, 480, 200)] autorelease];
    [printView setVerticallyResizable:YES];
    [printView setHorizontallyResizable:NO];

    // ADD THE TEXT
    // This assumes there is an General/NSTextField called titleField
    // and an General/NSTextView called mainTextView

    General/printView textStorage] beginEditing];

    // Set the attributes for the title
    titleAttr = [[[NSDictionary dictionaryWithObject:General/[NSFont boldSystemFontOfSize:14] forKey:General/NSFontAttributeName];
    
    // Add the title
    General/printView textStorage] appendAttributedString:[[[[[NSAttributedString alloc]
        initWithString:[titleField stringValue] attributes:titleAttr] autorelease]];
    
    // Create a couple returns between the title and the body
    General/printView textStorage] appendAttributedString:[[[[[NSAttributedString alloc] initWithString:@"\n\n"] autorelease]];
    
    // Add the body text
    General/printView textStorage] appendAttributedString:[mainTextView textStorage;
    
    // Center the title
    [printView setAlignment:General/NSCenterTextAlignment range:General/NSMakeRange(0, General/titleField stringValue] length])];
    
    [[printView textStorage] endEditing];
    
    // Resize the print view to fit the added text
    // (Is this done automatically?)
    [printView sizeToFit];
    
    return printView;
}


I haven't compiled this code so let me know if you come across any errors.

-- [[RyanBates

----

And that handles pagination correctly (sorry, I'm without my book which has printing)?

----

Although I have not tested that exact code snippet, a very similar code snippet seemed to handle pagination correctly. It will resize the view to fit horizontally on the page and place the view on the top left corner (not centering it) with the margin size at their default. These settings are done through General/NSPrintInfo. You may want to check out Apple's documentation on printing which has some more information on pagination:

http://developer.apple.com/documentation/Cocoa/Conceptual/Printing/index.html

-- General/RyanBates

----

One suggestion -- instead of assuming the width of 480 pixels, try this:

    
    printView = General/[[[NSTextView alloc] initWithFrame:General/self printInfo] imageablePageBounds autorelease];


This will make the allocated General/NSTextView the right width based on the actual size and orientation of the printable area of the page.  The only caveat is that General/[NSPrintInfo imageablePageBounds] is only available in 10.2 and later.