To get a screenshot of your screen try this :
    
Please port to Cocoa


Or in General/PyObjC:

    
format = "png"

class General/CocoaScreenshot(General/NSObject):
	# Extension => Cocoa constant dictionary
	        self.fileRepresentationMapping = {
		       '.png': General/NSPNGFileType,
		       '.gif': General/NSGIFFileType,
		       '.jpg': General/NSJPEGFileType,
	   	       '.jpeg': General/NSJPEGFileType,
		       '.bmp': General/NSBMPFileType,
		       '.tif': General/NSTIFFFileType,
		       '.tiff': General/NSTIFFFileType,
		       }

		def _getFileRepresentationType(self):
			""" Cocoa filetype representation function to mach the filetype with the _fileRepresentationMapping dictionary"""
			base, ext = os.path.splitext(shotFile)
			return self.fileRepresentationMapping[ext.lower()]

		def screenshot(self):
			""" Cocoa screenshot implementation """
			# Initialize screen frame and allocate image in memory
			rect = General/NSScreen.mainScreen().frame()
			image = General/NSImage.alloc().initWithSize_((rect.size.width, rect.size.height))
			# Create a transparent fullsize window
			window = General/NSWindow.alloc().initWithContentRect_styleMask_backing_defer_(
							rect, 
							General/NSBorderlessWindowMask, 
							General/NSBackingStoreNonretained, 
							False)

			view = General/NSView.alloc().initWithFrame_(rect)
			window.setLevel_(General/NSScreenSaverWindowLevel + 100)
			window.setHasShadow_(False)
			window.setAlphaValue_(0.0)
			window.setContentView_(view)
			# Send the window to the front, focus General/NSView to execute an action action with 
			window.orderFront_(self)
			view.lockFocus()
			# Create a Bitmap representation of the focused screen frame and make it an image
			screenRep = General/NSBitmapImageRep.alloc().initWithFocusedViewRect_(rect)
			image.addRepresentation_(screenRep)
			view.unlockFocus()
			window.orderOut_(self)
			window.close()

			# Determine filetype, and create a representation (export to filetype)
			representation = self._getFileRepresentationType()

			# JPEG quality support (0-1)
			if format in ('jpeg', 'png', 'JPEG', 'JPG'):
				data = screenRep.representationUsingType_properties_(representation {General/NSImageCompressionFactor: 0.7})
			else:
				data = screenRep.representationUsingType_properties_(representation, None)

			# Write it
			data.writeToFile_atomically_("screenshot." + format, False)


----

Wow.. Python + Cocoa = ugly! Just learn Objective-C... and why is this here when General/ScreenShotCode exists with less hacky solutions?

----

It is the same method as the version you posted. Just a General/PyObjC implementation.

----

This doesn't actually work. I get a blank png...