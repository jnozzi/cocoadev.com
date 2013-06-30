I am trying to make a clickable URL using an General/NSTextField. I've seen Apple's example using an General/NSTextView, but it seems overblown. My basic assumption is that an General/NSTextField descends from General/NSControl, and I should be able to enable it and set up its action so my controller gets clicks. Here is my code. Are my assumptions just wrong?

    
[fiInfoURL setStringValue: [model infoURLStr:row]];     // fiInfoURL is an General/NSTextField
[fiInfoURL setEnabled:YES];
[fiInfoURL setTarget: self];
[fiInfoURL setAction:@selector(doInfoURL:)];
[fiInfoURL sendActionOn:General/NSLeftMouseDownMask];


I never see doInfoURL gettting invoked when I click. Is there something more I can do to make this work, or do I need to create a text view instead.

----

Is it possible that you do not yet know about the General/FieldEditor?  Every window has a shared text object, the General/FieldEditor, that handles real text editing (see General/FieldEditor for more info).  Try using Apple's example code to create a custom General/NSTextView subclass, then specify that an object of that class should be the field editor for your text field with the General/NSWindow delegate method     -windowWillReturnFieldEditor:toObject:.

----

Your assumption is incorrect; not every General/NSControl sends its action to its target when clicked. General/NSTextField, for example, sends its action when you press return, or tab out to another field, depending on how you configured it in IB. If you want a control that responds to mouse clicks, use an General/NSButton.

*He wants clickable General/URLs within a text field.  General/NSButton would not be appropriate.*

Where do you see that? He's setting the entire text field's contents to be the URL string, and he explicitly states that he wants to make a clickable URL using an General/NSTextField, not that he wants to embed a clickable URL within a larger body of text in an General/NSTextField. General/NSButton is entirely appropriate.

----

I assume a non-editable text field would work OK. How about subclassing and overriding     mouseDown? Would that work?