Is there any sample code to demonstrate being able to drag an image OUT of an General/NSImageView and drop it into other apps as an image?

----

You just have to put the image data on the pasteboard in mouseDragged:

http://developer.apple.com/documentation/Cocoa/Conceptual/General/DragandDrop/Concepts/dragsource.html

http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Classes/General/NSView.html#//apple_ref/doc/uid/20000014/BBCDEIEF

----

How do you detect the dragging?

*subclass General/NSImageView and override     mouseDragged:*

----

I tried that, but it's not catching the event - do I have to make it a responder or something? 

----

Putting

- (void)mouseDragged:(General/NSEvent *)event
{
	General/NSLog(@"hi");
}

Into the implementation of the General/NSImageView subclass doesn't work...any ideas?

----

Try also catching mouse downs. Make sure a mouse down event is properly handled before mouseDragged is called.

    
-(void)mouseDown:(General/NSEvent*)event {
    General/NSLog(@"Wassup");
    [super mouseDown:event];
}


----

It appears to be catching mouse downs properly - but still no go with the mouse drags.  Thanks.

----
Here's some (slightly modified) code from the *Basic Event Handling* docs...

    

- (void)mouseDown:(General/NSEvent *)theEvent
{
    BOOL keepOn = YES;

    while (keepOn) {
        theEvent = General/self window] nextEventMatchingMask: [[NSLeftMouseUpMask |
                General/NSLeftMouseDraggedMask];

        switch ([theEvent type]) {
            case General/NSLeftMouseDragged:
                     [self mouseDragged:theEvent];
                     keepOn = NO;
                    break;
            case General/NSLeftMouseUp:
                    keepOn = NO;
                    break;
            default:
                    /* Ignore any other kind of event. */
                    break;
        }
    }
    return;
}


----

Here's another (General/PyObjC; should be obvious how to translate to straight Objective-C, and ignore the 'self' arguments) version that I've implemented. It's still not perfect (I'm sure I'm not doing the 'at' and/or 'offset' arguments correctly, for example) but it works.

    

class Dragger(General/NSImageView):
    def mouseDown_(self,theEvent):
        return General/NSResponder.mouseDown_(self,theEvent)
    
    def mouseDragged_(self,theEvent):
        pb = General/NSPasteboard.pasteboardWithName_(General/NSDragPboard)
        pb.declareTypes_owner_(General/NSArray.arrayWithObject_(General/NSTIFFPboardType),self)
        pb.setData_forType_(self.image().General/TIFFRepresentation(),General/NSTIFFPboardType)
        
        General/NSView.dragImage_at_offset_event_pasteboard_source_slideBack_(self,self.image(),
            General/NSPoint(0.0,0.0),self.image().size(),theEvent,pb,self.window(),objc.YES)

        return General/NSResponder.mouseDragged_(self,theEvent)
    
    def draggingSourceOperationMaskForLocal_(self,isLocal):
        return General/NSDragOperationCopy



*Isn't that implementation of     mouseDown: basically redundant? After all, it just calls General/NSResponder's implementation. Maybe this is just a Python quirk... --General/JediKnil*

----

----

Half-newbie here: Can anyone suggest how to drag FROM General/NSImageViews?

----

Well, it really wasn't intended for that purpose, just to accept an image. It *IS* however a descendant of General/NSView. Just look up how to do drag and drop with a view. One thing you'll learn is that you need to provide a "drag image" for the drag op. Just use the General/NSImageView's -image to grab the current image.

----

I have successfully subclassed General/NSImageView to allow it to act as a drag source. Drop an email to jeff [at] bitprophet [dot] org if you'd like to see what I did. In the end it was very simple to implement, however finding out the correct thing to do was a bit of a pain (I'm also a newbie).