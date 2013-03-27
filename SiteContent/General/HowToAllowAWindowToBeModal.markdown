

Hi. I joined the General/AbiWord project (http://www.abiword.com/) and decided to fix Bug #285 - add Yes to All to Save and Quit dialog box ( http://bugzilla.abisource.com/show_bug.cgi?id=285 ). In order to do so I had to do a lot because General/NSAlertPanel only allows 3 buttons, no more. I have everything ready, but when I go to run the project, I get this error when I choose to quit - they appear in Terminal when I run it from there:

    2007-03-26 15:28:46.797 General/AbiWord[5982] *** Assertion failure in -[XAP_CocoaApplication _commonBeginModalSessionForWindow:relativeToWindow:modalDelegate:didEndSelector:contextInfo:], General/AppKit.subproj/General/NSApplication.m:3057
2007-03-26 15:28:46.819 General/AbiWord[5982] Modal session requires modal window

I tried subclassing and implementing     canBecomeKeyWindow, but that didn't work. The documentation is unclear at the method (it probably likes sheets better - not what I want because more than one document is open). So what do I do? - General/PietroGagliardi

PS - I had to force quit after the error - every time I tried to quit, it regenerated the error. Otherwise, everything worked perfectly.

----
Every single time I have ever seen this error, it has been because I was passing     nil to     beginModalSessionForWindow: or one of its friends.

----
That was it, actually! Now what? Here's my code:

    
@interface XAP_Cocoa_MyModalWindowClass : General/NSWindow {
}
@end


@interface XAP_CocoaDialog_MessageBox_Controller : General/NSObject {
	General/IBOutlet XAP_Cocoa_MyModalWindowClass *_messageBoxPanel;
	General/IBOutlet General/NSTextField *_messageBoxPrimary, *_messageBoxSecondary;
	General/IBOutlet General/NSButton *_messageBoxYes, *_messageBoxNo, *_messageBoxYesToAll, *_messageBoxCancel;
}
- (XAP_Dialog_MessageBox::tAnswer)runBoxPrimaryString:(General/NSString *)primary secondaryString:(General/NSString *)secondary yesButton:(General/NSString *)yesButton noButton:(General/NSString *)noButton yesToAllButton:(General/NSString *)yesToAllButton cancelButton:(General/NSString *)cancelButton;
- (General/IBAction)doYes:(id)sender;
- (General/IBAction)no:(id)sender;
- (General/IBAction)yesToAll:(id)sender;
- (General/IBAction)cancel:(id)sender;
@end

@implementation XAP_CocoaDialog_MessageBox_Controller

- (XAP_Dialog_MessageBox::tAnswer)runBoxPrimaryString:(General/NSString *)primary secondaryString:(General/NSString *)secondary yesButton:(General/NSString *)yesButton noButton:(General/NSString *)noButton yesToAllButton:(General/NSString *)yesToAllButton cancelButton:(General/NSString *)cancelButton
{
	[_messageBoxPrimary setStringValue:primary];
	[_messageBoxSecondary setStringValue:secondary];
	[_messageBoxYes setStringValue:yesButton];
	[_messageBoxNo setStringValue:noButton];
	[_messageBoxYesToAll setStringValue:yesToAllButton];
	[_messageBoxCancel setStringValue:cancelButton];
	[_messageBoxPanel makeKeyWindow];
	General/NSLog(@"%@", _messageBoxPanel);
	return (XAP_Dialog_MessageBox::tAnswer) General/[NSApp runModalForWindow:_messageBoxPanel];
}

- (General/IBAction)doYes:(id)sender
{
	General/[NSApp stopModalWithCode:(int) XAP_Dialog_MessageBox::a_YES];
}

- (General/IBAction)no:(id)sender
{
	General/[NSApp stopModalWithCode:(int) XAP_Dialog_MessageBox::a_NO];
}

- (General/IBAction)yesToAll:(id)sender
{
	General/[NSApp stopModalWithCode:(int) XAP_Dialog_MessageBox::a_YESTOALL];
}

- (General/IBAction)cancel:(id)sender
{
	General/[NSApp stopModalWithCode:(int) XAP_Dialog_MessageBox::a_CANCEL];
}

@end

@implementation XAP_Cocoa_MyModalWindowClass

- (BOOL)canBecomeKeyWindow
{
	return YES;
}

@end


The window is connected in my NIB file. Should I get rid of the new window class altogether?

----
This error appears most often when a NIB file hasn't been loaded using General/NSBundle. Send General/NSBundle the +loadNibNamed:owner: method (sending the appropriate owner in the nib as the owner argument), and this will get it unpackaged and ready to use. Be warned however, to only do this once. Period. Calling it multiple times will create multiple instances of everything, and calling it in something like -awakeFromNib will cause an infinite loop, I bet you can guess why. Hope this helps. --General/LoganCollins
----
Thanks, Logan. So how do I unload the nib file after I'm done with it - that only makes sense, right?

----
Subclass General/NSWindowController instead and these problems are mostly taken care of.

----
That's done, but now it shows the dialog box in an infinite loop.

    
@interface XAP_CocoaDialog_MessageBox_Controller : General/NSWindowController {
	General/IBOutlet General/NSTextField *_messageBoxPrimary, *_messageBoxSecondary;
	General/IBOutlet General/NSButton *_messageBoxYes, *_messageBoxNo, *_messageBoxYesToAll, *_messageBoxCancel;
}
- (XAP_Dialog_MessageBox::tAnswer)runBoxPrimaryString:(General/NSString *)primary secondaryString:(General/NSString *)secondary yesButton:(General/NSString *)yesButton noButton:(General/NSString *)noButton yesToAllButton:(General/NSString *)yesToAllButton cancelButton:(General/NSString *)cancelButton;
- (General/IBAction)doYes:(id)sender;
- (General/IBAction)no:(id)sender;
- (General/IBAction)yesToAll:(id)sender;
- (General/IBAction)cancel:(id)sender;
@end

@implementation XAP_CocoaDialog_MessageBox_Controller

- (XAP_Dialog_MessageBox::tAnswer)runBoxPrimaryString:(General/NSString *)primary secondaryString:(General/NSString *)secondary yesButton:(General/NSString *)yesButton noButton:(General/NSString *)noButton yesToAllButton:(General/NSString *)yesToAllButton cancelButton:(General/NSString *)cancelButton
{
	XAP_Dialog_MessageBox::tAnswer i;

	[_messageBoxPrimary setStringValue:primary];
	[_messageBoxSecondary setStringValue:secondary];
	[_messageBoxYes setStringValue:yesButton];
	[_messageBoxNo setStringValue:noButton];
	[_messageBoxYesToAll setStringValue:yesToAllButton];
	[_messageBoxCancel setStringValue:cancelButton];
	i = (XAP_Dialog_MessageBox::tAnswer) General/[NSApp runModalForWindow:[self window]];
	General/self window] close];
	return i;
}

- ([[IBAction)doYes:(id)sender
{
	General/[NSApp stopModalWithCode:(int) XAP_Dialog_MessageBox::a_YES];
}

- (General/IBAction)no:(id)sender
{
	General/[NSApp stopModalWithCode:(int) XAP_Dialog_MessageBox::a_NO];
}

- (General/IBAction)yesToAll:(id)sender
{
	General/[NSApp stopModalWithCode:(int) XAP_Dialog_MessageBox::a_YESTOALL];
}

- (General/IBAction)cancel:(id)sender
{
	General/[NSApp stopModalWithCode:(int) XAP_Dialog_MessageBox::a_CANCEL];
}

@end


created with

    
XAP_CocoaDialog_MessageBox_Controller *ctrl;
ctrl = General/XAP_CocoaDialog_MessageBox_Controller alloc] initWithWindowNibName:@"xap_CocoaDlg_MessageBox_YesNoAllCancel"];


What's happening?

----
Hello?

----
Please, have patience.

I'm not sure why you expect a response, since you don't give us enough information. Saying that it shows your window "in an infinite loop" is useless. Tell us *what is happening*. What diagnostics have you done, where does the loop happen, what have you done to try to solve this? If you ask a useless question then expect to get no answers.

[[MailingListMode General/HowToAskQuestions

----
Sorry. I haven't patched the source code to make it available to the public yet. So I run the app and go to Quit General/AbiWord. Out pops the dialog box. When I click a button, the window just stays there, as if it closed and reopened again. Using General/NSLog<nowiki/>s to test this out resulted in the fact that there was no infinite loop, but rather the buttons never got the event. If it still doesn't work, I'll repost with an explanation.

UPDATE: The buttons are connected in the nib file, so something else is wrong.

----
Please, please, please read over General/MailingListMode and understand why this style of asking frequent questions and posting frequent updates is *not* appropriate to this site.

If you take the time to go over your work and diagnose things carefully, you will get a much better response from this site. There is normally no need to post things this frequently. If you have a question, take as much time as you can to make the question as complete and useful as possible. When you run into a new problem, repeat that process. Posting these little updates and such is useless and counterproductive.

----
OK, then I'll give you the full scoop on doing this with General/AbiWord source code.

First, get General/DarwinPorts.

Next, go into Terminal and type all of this while in your ~ directory:

    
sudo -s


Type your password, hit Return, and type these commands:

    
port install autoconf
port install automake
exit


General/DarwinPorts' version of autoconf and automake are better than Apple's.

Next, type these commands:

    
svn co http://svn.abisource.com/abimacsdk/trunk/portssdk
cd portssdk
export PATH=/opt/local/bin:$PATH
make all
cd ..
export CVSROOT=:pserver:anoncvs@anoncvs.abisource.com:/cvsroot
cvs login


The password is "anoncvs".

    
cvs -z3 co abi
cd abi


Now download my patch: http://disk.mac.com/pietro10/Public/mypatch
Download it to the abi folder that is now created in your Home folder.

Type:

    
patch -p0 < mypatch
./autogen.sh --with-abiports
make
src/wp/main/cocoa/General/AbiWord.app/Contents/General/MacOS/General/AbiWord


Create and type some stuff in 3 documents. Don't save. Just go to Quit General/AbiWord. Choose Cancel, then go to Quit General/AbiWord again. The window is now nil for some reason!

----
It is good to see that Abiword builds from the head once again. Your proposed solution to the bug ought to be rejected by the General/MacOS Abiword maintainer on the grounds that it doesn't match the expected  General/MacOS X user experience. Further, the existing behaviour does match Carbon applications such as Appleworks.

I don't myself have an axe to grind, as I don't use word processors, but you could quickly see what I mean if you look at, say, General/TextForge. The Dialogue should run something like "You have N documents with usaved changes ...", with buttons <Discard Changes> <Review Changes ...>. 

At this point you might want to look at the Abiword blogs and see which applications are being compared to Abiword and design yours to match.

You might also want to bear in mind that bug 285 looks like being passed by, and you might want to open a Cocoa specific bug.

Sorry to be so negative, and I will endeavour to look at your code.  - Ben

----
I've known General/AbiWord to be compared with General/OpenOffice.org and it suffers the same thing, and I used up my trials of MS Office and iWork so I can't try those.

How would I use Carbon to write a 4-button messagebox? The default Alert only has 3 buttons.

Both BC Spreadsheet and General/TextForge have that feature, so I think it is a Cocoa/General/NSDocument thing. I'll go chat with the developers if there is no other way.

----
I wasn't able to get General/OpenOffice to compile, I ran into the problem described here: http://www.computerandvideogames.com/forums/viewtopic.php?t=18166&sid=378c54311b2542f59df49717d2b171aa , but General/NeoOffice has carbon behaviour (and is probably a carbon application *tout court*).

We don't take carbon questions here, I believe that there is a comparable carbon site to this cocoa one, but there are also numerous mailing lists and other resources for carbon. It has been a little while since I was last asked a carbon question: I would probably refresh my understanding by reviewing the Simpletext and Textedit example applications. If memory serves there is a page on the Apple site that does the same thing rather entertainingly.

(Abiword was once a carbon application - it could be compiled using Codewarrior on Classic Mac).

The dialogue for quitting when there are unsaved documents is described at http://developer.apple.com/documentation/General/UserExperience/Conceptual/General/OSXHIGuidelines/General/XHIGWindows/chapter_17_section_6.html ; (it is neither Cocoa nor General/NSDocument specific, and should be available to any native application you write). See further information at http://developer.apple.com/documentation/Cocoa/Conceptual/General/AppArchitecture/Tasks/General/GracefulAppTermination.html concerning     reviewUnsavedDocumentsWithAlertTitle:cancellable:delegate:didReviewAllSelector:contextInfo: ; which - and perhaps this is what you meant - does indeed cover Cocoa and "the constellation of     General/NSDocument,     General/NSWindowController, and     General/NSDocumentController objects".

You should review the     runModalForWindow: method, for example, I have found these applications (all on the General/CocoaOpen page) which use it for an application modal window: General/CVSEdit uses '    runModalForWindow: to run an Application Modal Panel stored in its     General/MainMenu.nib; Stackinator uses     runModalForWindow: to run an Application Modal Panel stored in a different .nib (opened with     loadNibNamed: ); General/TeXShop uses uses     runModalForWindow: to run an Application Modal Panel stored in the Document     .nib;  Freecell uses     runModalForWindow:to run an Application Modal Panel stored in its     General/MainMenu.nib.

You should review the     General/NSRunAlertPanel function for example, http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Miscellaneous/AppKit_Functions/Reference/reference.html .

You should look at these pages on the Apple site: http://developer.apple.com/documentation/Cocoa/Conceptual/General/WinPanel/Concepts/General/UsingModalWindows.html , the "Types of Dialogs and When to Use Them" page that I gave you earlier, http://developer.apple.com/documentation/Cocoa/Conceptual/Sheets/Tasks/General/UsingAppModalDialogs.html , http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/Classes/NSAlert_Class/Reference/Reference.html .

----
Sorry about General/MailingListMode - I plead guilty under Section 2 of that page and I will atone by refactoring this one, and perhaps adding any good stuff to General/WindowPriority .

----
I downloaded the current sources using these instructions: http://www.abisource.com/developers/download.phtml and didn't recognise yours (is that the intel branch) and built using http://www.abisource.com/~fjf/ . Have you been able to download your patch?