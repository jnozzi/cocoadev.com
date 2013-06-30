Cocoa allows you to substitue a custom General/FieldEditor, Apple provides documentation [http://devworld.apple.com/documentation/Cocoa/Conceptual/General/TextEditing/Tasks/General/FieldEditor.html] but the examples have a few bugs. See General/CreatingCustomFieldEditor for discussion, including broken code examples, on this topic, this page is an example of how it's actually supposed to work.

**Why use a custom field editor?**

If you want to change the default behaviour of text fields being edited in your application, you want a custom General/FieldEditor. There are other cases discussed in General/CreatingCustomFieldEditor and the Apple documentation.

**What's the Setup?**

You will add a field editor to the General/NSWindowController subclass, in this example it will be an General/NSTextField.

    

// General/MyWindowController.h

@interface General/MyWindowController : General/NSWindowController
{
    General/NSTextField* custom_field_editor;
}

@end



**What's the implementation?**

    
// General/MyWindowController.m

#import "General/MyWindowController.h"

@implementation General/MyWindowController

- (void) windowDidLoad
{
    custom_field_editor = General/[[NSTextView alloc] initWithFrame:General/NSMakeRect(0,0,0,0)];
    // one-time setup of the field editor, you could also set text colors or styles at this time
    [custom_field_editor setEditable:YES];
    [custom_field_editor setFieldEditor:YES];
    [custom_field_editor setSelectable:YES];
}

- (void) dealloc
{
    [custom_field_editor release];
}

#pragma mark General/NSWindowDelegate Methods

(id) windowWillReturnFieldEditor:(General/NSWindow*) sender toObject:(id) anObject
{
    if ([anObject isKindOfClass:General/[NSTextField class]])
    {
        // do any per-edit setup here (e.g. select all text)
        return custom_field_editor;
    }
    return nil;
}

@end


Has anyone actually used this? It seems all kinds of messed up. Aside from the underscores in variable names, it's declaring a pointer to an General/NSTextField, and then allocating an General/NSTextView. And there should be the actual custom field editor somewhere.

----
Yes, it works for me (David Phillip Oster). Except: my custom field editor is a subclass of General/NSTextView, and my windowWillReturnFieldEditor: always returns the field editor. I use it because my tableview's controller sets the text of cut/copy/paste menu items to "Cut rows", etc. so I needed a subclass of General/NSTextView so the field editor could set the text of the menu items back.