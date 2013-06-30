

Some sample code for displaying a simple sheet with OK/Cancel buttons on it:
    
- (void)runSheet
{
    int modalVal;

    General/[NSApp beginSheet:theSheet 
            modalForWindow:self
            modalDelegate:self 
            didEndSelector:NULL 
            contextInfo:NULL];

    modalVal = General/[NSApp runModalForWindow:theSheet];

    General/[NSApp endSheet:theSheet];
    [theSheet orderOut:nil];	
}

- (General/IBAction)acceptSheet:(id)sender
{
    General/[NSApp stopModalWithCode:1];
}

- (General/IBAction)cancelSheet:(id)sender
{
    General/[NSApp stopModalWithCode:0];
}



**theSheet** is an outlet connected to the sheet, which is an General/NSPanel in General/InterfaceBuilder. 

**-acceptSheet** and **-cancelSheet** are actions that can be connected, for example, to OK/Cancel buttons on the sheet using General/InterfaceBuilder.

Upon return from **runModalForWindow**, the variable **modalVal** will contain either 0 or 1, depending on whether the sheet was canceled or accepted, respectively.

----

From: Seth Willits

Since sheets that are modal for the entire application are big no-no's, use this method which presents the sheet modal only to the window it is attached to.

    
- (General/IBAction)openSheet:(id)sender
{
	General/[NSApp beginSheet: theSheet
			modalForWindow: theParent
			modalDelegate: self
			didEndSelector: @selector(sheetDidEnd: returnCode: contextInfo:)
			contextInfo:NULL];
}

- (General/IBAction)theSheetOK:(id)sender
{
	General/[NSApp endSheet:theSheet returnCode: General/NSOKButton];
	[theSheet orderOut:nil];
}

- (General/IBAction)theSheetCancel:(id)sender
{
	General/[NSApp endSheet:theSheet returnCode: General/NSCancelButton];
	[theSheet orderOut:nil];
}

- (void)sheetDidEnd:(General/NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	if (returnCode == General/NSOKButton)
		General/NSBeep();
}


----

From: Alex Karahalios <Alex at Karahalios dot org>

Subject: Re: Use of General/NSSavePanel (or Open)    
@interface General/ModalSavePanel : General/NSSavePanel
- (int)runModalForDirectory:(General/NSString *)path file:(General/NSString *)name
		   relativeToWindow:(General/NSWindow*)window;
@end

@implementation General/ModalSavePanel
- (int)runModalForDirectory:(General/NSString *)path file:(General/NSString *)name
		   relativeToWindow:(General/NSWindow*)window;
{
     int result;
     [super beginSheetForDirectory: path
                              file: name
                    modalForWindow: window
                     modalDelegate: self
                    didEndSelector: NULL
                       contextInfo:NULL];
     result = General/[NSApp runModalForWindow:self];
     General/[NSApp endSheet:self];
     return result;
}@end


----

From: The DJ <hartman at mac dot com>

Subject: Use of a sheet (Java solution)

Just for the record of the mailinglist, in Cocoa/Java the use of a sheet is as followed:
        public void openMenu(General/NSMenuItem sender) {
        op = new General/NSOpenPanel();
        op.setAllowsMultipleSelection(false);
        op.setCanChooseDirectories(false);
        op.setCanChooseFiles(true);
        op.beginSheetForDirectory(directory,
            filename,null,window,this,
            new General/NSSelector("done",new Class[] {
                General/NSOpenPanel.class, int.class}),
            null);
    }
    
    public void done(General/NSOpenPanel sheet, int returnCode){
            if (returnCode == General/NSAlertPanel.General/DefaultReturn) {
                open_file = sheet.filename();
                System.out.println(open_file);
            }
    }


----

From: General/MattRidley

Subject: simpler way to get an OK/Cancel sheet, without using Interface Builder

You can just use the General/NSBeginAlertSheet() function, documented in the Functions section of the General/AppKit documentation.

    

- (void)runAlertSheet
{
	General/NSBeginAlertSheet(@"You must be insane!", @"OK", @"Cancel",
		nil, myWindow, self, NULL,
		@selector(endAlertSheet:returnCode:contextInfo:),
		NULL,
		@"Are you sure you want to do such a reckless thing?");
}

- (void)endAlertSheet:(General/NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo
{
	if (returnCode == General/NSAlertDefaultReturn) {
		General/NSLog(@"Clicked OK");
	}
	else if (returnCode == General/NSAlertAlternateReturn) {
		General/NSLog(@"Clicked Cancel");
	}
}



Note that **myWindow** is an outlet connected to the window you want the alert sheet to display over (roll out from).

----
When I try to use the code above, it works fine -- except that I get an alert window displayed instead of a slide down sheet...  Ideas what I am doing wrong???

----

You should never use modal sheets...whats the use?

-- chmod007@mac.com
----
Are you not understanding the distinction between application modal and window modal ?  Sheets exist for two purposes: 1) Identify which window is affected by the message on the sheet.  2) Operate modally for the affected window and not interfere with any other windows.
----
----

When should I display my sheet so that it runs after startup of the app?  Right? now I have it in (void)windowDidBecomeKey: and have it set up to only run the shhet once (using a boolean to see if it has run before), but the sheet still isn't in focus. I need to click on the text field.

*how about applicationDidFinishLaunching or windowControllerDidLoadNib*

-- General/SamGoldman
----
For complete example code that displays a sheet once when a document is open and also supports nice application quit behavior:
See http://www.stepwise.com/Articles/2006/eb1/index.html
----
You could always use awakeFromNib, and then you can get rid of your flag.

    
- (void)awakeFromNib {/* Foo */};


----
awakeFromNib is ok for most situations but if you're not careful/cluefull you could give yourself a headache. I like applicationDidFinishLaunching - you want it shown when the app finishes launching...very logical.

----

From: Steve Christensen <punster=at=mac=dot=com>
Subject: Re: Use of General/NSSavePanel (or Open)

I tried Alex Karahalios' code above and found that it didn't didn't clean up correctly. Here's my version, done as a category on General/NSSavePanel:

    
@interface General/NSSavePanel(General/ModalSheets)

- (int)runModalForDirectory:(General/NSString*)path file:(General/NSString*)name
            types:(General/NSArray*)fileTypes relativeToWindow:(General/NSWindow*)window;

- (void)modalSavePanelDidEnd:(General/NSOpenPanel*)panel returnCode:(int)returnCode
            contextInfo:(void*)contextInfo;

@end

@implementation General/NSSavePanel(General/ModalSheets)

- (int)runModalForDirectory:(General/NSString*)path file:(General/NSString*)name
            types:(General/NSArray*)fileTypes relativeToWindow:(General/NSWindow*)window
{
    int result;

    [super beginSheetForDirectory:path file:name modalForWindow:window
            modalDelegate:self
            didEndSelector:@selector(modalSavePanelDidEnd:returnCode:contextInfo:)
            contextInfo:nil];

    result = General/[NSApp runModalForWindow:self];

    General/[NSApp endSheet:self];

    return result;
}

- (void)modalSavePanelDidEnd:(General/NSOpenPanel*)panel returnCode:(int)returnCode
            contextInfo:(void*)contextInfo
{
    General/[NSApp stopModalWithCode:returnCode];
}

@end

----
�----

That's a mighty weird bug... I'd double check that the English and Spanish/French nibs are wired up the same way with the same properties - maybe go so far as to recreate the other nibs from the English.