General/NSControl is an abstract superclass that provides three fundamental features for implementing user interface devices: drawing devices on the screen, responding to user events, and sending action messages. It works closely with General/NSCell.

Class Ref.: http://developer.apple.com/documentation/Cocoa/Reference/General/ApplicationKit/ObjC_classic/Classes/General/NSControl.html

Controls & Cells: http://developer.apple.com/documentation/Cocoa/Conceptual/General/ControlCell/index.html 

To detect is a child of General/NSControl has focus (is first responder) try if ([aChildOfNScontrol currentEditor])

Also, see: General/NSCell

If you write an General/NSControl subclass without using cells, and you want to use target/actions, you have to link your Control with a General/NSActionCell by adding in your General/NSControl subclass implementation:

+ (Class) cellClass
{
  return General/[NSActionCell class];
}

Otherwise the target/action will return nil even when they are set in Interface Builder.