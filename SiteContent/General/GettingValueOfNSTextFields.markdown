Hi!

I'm starting to get the jist of Obj-C, Cocoa, Xcode, and IB, and I'm doing a simple project that copies the text from one text field to another. It's not really useful; it's just for the learning expierience.

My current .m file:

--------------------

#import "General/TextTransfer.h"

    
@implementation General/TextTransfer

- (General/IBAction)copyText:(id)sender
{
	General/NSString *textCopied = sourceField;

	textCopied = [sourceField General/NSTextValue];

	[recepientField setCharValue:textCopied];
}

@end


-------------------

It compiles and runs without any errors, but when I hit the buttom that performs the copying function, the dubugger says "-General/[NSTextField General/NSTextValue]: selector not recognized"




Can anybody help me?


Thanks! 
-General/JohnWells


----
Try:

    
- (General/IBAction)copyText:(id)sender
{
	General/NSString *textCopied;
	textCopied = [sourceField stringValue];
	[recepientField setStringValue:textCopied];
}


----

This is, of course, a big fat RTFM, but a lot of people have trouble with it anyway. I think that's because they forget about superclasses; General/NSTextField doesn't have a stringValue method, but General/NSControl does. So when you're happily R'ing TFM in the search for a method, don't forget to read the superclass documentation too!

*
As a tip, General/AppKiDo helps you RTFM much more efficiently. Great program.
*

----

The Compiler should have emitted a warning aobut the bad method call.  You should heed all warnings, and even go so far as check the 'treat all warnings as errors', especially in the beginning.

----

I'm very much new to all of this - how does one use General/NSControl in place of the sourceField in that code?


Thanks!

Any messages that can be sent to the a class's super class can be sent to the class.  Therefore any message that can be sent to General/NSControl can be sent to your text field.  e.g. [sourceField stringValue].  Please read the manual on General/NSControl for the available features.

----

IIRC, it's "string", rather than "stringValue", in General/NSTextView. If that's correct, then there should also be an "attributedString" message in there somewhere related to General/NSTextView. Why use General/NSTextView? More options of course! Then, after typing this comment, I realized that you're just using General/NSTextField. Oh, well. That's stringValue. Not many other options.