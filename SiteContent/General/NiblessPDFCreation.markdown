Hi Everyone,
I'm attempting to write a small commandline program that will generate small General/PDFs for me.  I figured it might be worth a go to write this in General/PyObjC.  If you guys think it'd be easier to do this in normal General/ObjC I'd be more than happy to.  I've gotten things to a point where it will spit out a PDF the size I want, but unfortunately it's an empty PDF.  I was wondering if you guys had any idea why it won't draw anything.  Here's what I've got so far:
    
#!/usr/bin/env pythonw

import objc
import sys
from Foundation import *
from General/AppKit import *
from General/PyObjCTools import General/AppHelper

class General/AppDelegate (General/NSObject):
  def applicationDidFinishLaunching_(self, aNotification):
    print "Hello, World!"

def main():
  app = General/NSApplication.sharedApplication()
  # we must keep a reference to the delegate object ourselves,
  # General/NSApp.setDelegate_() doesn't retain it. A local variable is
  # enough here.
  delegate = General/AppDelegate.alloc().init()
  General/NSApp().setDelegate_(delegate)

  fughettaFont = General/NSFont.fontWithName_size_(u"Fughetta", 40)

  # Make the bezier path for our thing.
  notePath = General/NSBezierPath.bezierPath()

  # Move to where we need to be and add our note.
  notePath.moveToPoint_(General/NSMakePoint(25, 25))

  # Glyph number 192 is the closed dot.
  notePath.appendBezierPathWithGlyph_inFont_(192, fughettaFont)

  # Create the unfortunately necessary window
  win = General/NSWindow.alloc()
  drawing_rect = General/NSMakeRect(0, 0, 50, 50)
  win.initWithContentRect_styleMask_backing_defer_(drawing_rect, 15, 0, 0)

  # Create our General/NSView in which to draw our stave.
  drawing_view = General/NSView.alloc().initWithFrame_(drawing_rect)

  # Add the view to the window.
  win.setContentView_(drawing_view)
  drawing_view.lockFocus()

  # Draw our dot at 25 25
  General/NSColor.blackColor().set()
  notePath.fill()

  # Save to a pdf
  data = drawing_view.dataWithPDFInsideRect_(drawing_rect)
  data.writeToFile_atomically_(u"test.pdf", 1)

if __name__ == '__main__' : main()


----
This is a good example of why you should avoid invoking     lockFocus on an General/NSView.

What's happening is that     dataWithPDFInsideRect simply asks the view to redraw itself and uses that to create the PDF. It is not getting the drawing which currently exists in the window's backing store, it's just having the view refresh itself. Since this is just a naked General/NSView with no custom code, its     drawRect: does nothing.

Another problem is that you probably need to get General/AppKit started before you do other things. My code spit out errors unless I invoked     General/[NSApplication sharedApplication] before I started manipulating images and such.

You can just subclass General/NSView and put your drawing code there. If you don't like that, you can draw into an image, then use General/NSImageView to get that in PDF form. However, this will get you a rasterized image, not a vector image, and that's probably less than ideal.

----
Ahh!  Thanks for that!  Subclassing the General/NSView fixed everything.  Thanks a bunch!