How do I let people copy data from my document and paste it elsewhere?

How do I provide customised cut and paste from my application?

Some controls, such as General/NSTextField and General/NSTextView, already provide cut and paste operations, so if you are only interested in cut and paste of text, you can use these without any extra work.

If you want to have cut and paste on other standard or custom controls, you need to implement the copy: and or the paste: methods on the control.  There is example code for this below.

In Cocoa, there are multiple General/NSPasteboard instances, but only two are interesting to the beginner:  the General/NSGeneralPBoard, which is used for cutting and pasting text and images between applications, and the General/NSDragPBoard, which is used for drag operations.  Others include the General/NSFindPasteBoard, used for sharing the text to find between multiple applications, and custom pasteboards, which can be used for special purposes in your applications.

In each pasteboard, you can store and request multiple different types of data, such as General/PlainText, General/RTFtext, filenames, file contents, images (of different types) etc.  An General/NSPasteBoard can also translate automatically between different types of data.  This means that if you provide General/RTFtext, then the application that wants to paste will automatically get General/PlainText if it wants it.  In addition, you can define new data types that can be used to transfer custom data within your application.

The Apple documentation http://developer.apple.com/documentation/Cocoa/Conceptual/General/CopyandPaste/index.html
describes these types, but fails to answer the basic question: "How do I implement copy and paste in my application?"

----

**Simple Copy of a General/NSString**

This code will simply copy the General/NSString to the general pasteboard, making it accessible for any other process.

    
   
   General/NSString *string = @"String to be copied";
   General/NSPasteboard *pasteBoard = General/[NSPasteboard generalPasteboard];
   [pasteBoard declareTypes:General/[NSArray arrayWithObjects:General/NSStringPboardType, nil] owner:nil];
   [pasteBoard setString:string forType:General/NSStringPboardType];
   


----

**Copy and Paste of text**

If you provide a custom control, there may be a logical way its contents can be translated into text for copy and paste.  For example, if you provide a control for editing quad-dotted IP addresses, using General/NSTextFields.  A copy operation should translate this into a simple string.

    
   {
   
      sorry, I haven't written the code for this yet!
   }


----

**Copy and Paste of a custom data type:**

The following code shows how you can provide cut and paste of a custom datatype.  You probably don't want to do this unless your application can edit and display some custom data.  To use this code, add it to the control that will be General/FirstResponder when your custom data is being edited by the user.  This is normally the control that contains the data - for instance the General/FirstResponder when I am typing text into a General/NSTextField is the field itself.

    
   
   // Copy immediately
   
   General/NSString *General/MyDataPboardType = @"General/MyDataPboardType";
   
   - (void)copy:(id)sender
   {
       General/NSPasteboard *pb = General/[NSPasteboard generalPasteboard];
       General/NSArray *pb_types = General/[NSArray arrayWithObjects:General/MyDataPboardType, nil];
       [pb declareTypes:pb_types owner:nil];
       [pb setData:[self selectedItemsAsData] forType:General/MyDataPboardType];
   }
   
   - (void)paste:(id)sender
   {
       General/NSPasteboard *pb = General/[NSPasteboard generalPasteboard];
       General/NSData *archived_data = [pb dataForType:General/MyDataPboardType];
       [self dataToDocument:archived_data];
   }
   


----

**Delayed Pasting**

You can choose to write copy-and-paste code so that certain data types that can be copied and pasted from your application are not actually provided until the paste operation occurs.  

For example, suppose your application edited math formulas.  It might be cheap to provide text equivalents, but expensive to provide (TIFF) image versions for other applications to paste.  You would provide the text version immediately into the General/NSStringPboardType, but provided **delayed** pasting of the General/NSTIFFPboardType type.  If an application such as textEdit could only paste text, they would simply get the text version.  If you chose to paste in General/PhotoShop, on the other hand, then your application would be notified at the point the paste occurred, and could generate the TIFF version then.

In another example, your application could pass around an internal data type for cutting and pasting within the application, but if the conversion to normal paste types such as text or images were expensive, you could provide delayed pasters for those.

Note... one has to be careful to handle the case where the user copies something, then edits it, then pastes it.

    
   
   // delayed copy
   
   General/NSString *General/MyDataPboardType = @"General/MyDataPboardType";
   
   - (void)copy:(id)sender
   {
       General/NSPasteboard *pb = General/[NSPasteboard generalPasteboard];
       General/NSArray *pb_types = General/[NSArray arrayWithObjects:General/MyDataPboardType,NULL];
       [pb declareTypes:pb_types owner:self];
   }
   
   - (void)paste:(id)sender
   {
       General/NSPasteboard *pb = General/[NSPasteboard generalPasteboard];
       General/NSData *archived_data = [pb dataForType:General/MyDataPboardType];
       [self dataToDocument:archived_data];
   }
   
   // receive this message to copy data to the clipboard if it wasn't done
   // immediately.
   - (void)pasteboard:(General/NSPasteboard *)pb provideDataForType:(General/NSString *)type
   {
       if ( [type compare:General/MyDataPboardType ] == General/NSOrderedSame )
       {
           [pb setData:[self selectedItemsAsData] forType:General/MyDataPboardType];
       }
   }
   


----

There is some mechanism whereby the owner of the pasteboard can change. I don't understand why this would happen. Anyone care to elaborate?

----

A pasteboard owner may be asked to provide data for certain types on paste, so the owner needs to be a persistent object that won't get released when, e.g. the window the data was copied from is closed.

----

To copy RTF from an General/NSTextView see General/CopyRTFFromTextView

----
When implementing copy in a custom view, you may want to add to your custom view the method 'acceptsFirstResponder' and override the General/NSResponder implementation so that it returns YES. Otherwise, the view never gets to respond to the copy message sent to the first responder by the menu item.