Describe General/CocoaWOMacOSXServerProblems here.
Hello I'm a General/WebObjects developer of simple applications. The deployment
of this application is done on a General/MacOS X Server 10.3.2 with Java 1.4.2
and WO 5.2.2. In some of that applications I use a class that use Cocoa
API to resize user uploaded image... It works perfectly on Mac OS 10.3.2
(non server) when I develope but it doesn't works in Mac OS X Server
10.3.2 when I deploy, the instance of the application quit unexpectly. On
Mac OS X Server 10.2.8 it works perfectly... the problem appear to be
when in the Cocoa class I invoke the method:
General/NSApplication.sharedApplication()... Can you help me please?

Thank'you very much

    
Cocoa General/APIs Class
---------
import com.apple.cocoa.foundation.*;
import com.apple.cocoa.application.*;
import com.webobjects.foundation.*;

public class General/CocoaImageTools  {

	private static General/NSApplication app;
	
	public static com.webobjects.foundation.General/NSData
scaleImage(com.webobjects.foundation.General/NSData image, int maxWidth) {
		if (app==null) app = General/NSApplication.sharedApplication();
		float newWidth = 0;
		float newHeight = 0;
		int myPool = General/NSAutoreleasePool.push();
		com.apple.cocoa.foundation.General/NSData imageCData = new 
com.apple.cocoa.foundation.General/NSData(image.bytes(0, image.length()));
		General/NSImage originalImage = new General/NSImage(imageCData);
		float widthOriginalImage = originalImage.size().width();
			float heightOriginalImage = originalImage.size().height();
			
			if (widthOriginalImage > heightOriginalImage){
				newHeight = (heightOriginalImage * maxWidth)/widthOriginalImage;
				newWidth = maxWidth;
			}
			else{
				newHeight = maxWidth;
				newWidth = (widthOriginalImage * maxWidth)/heightOriginalImage;
			}
			System.out.println("Calcolo dimensioni");

			General/NSImage thumbImage = new General/NSImage(new General/NSSize(newWidth, newHeight));
			thumbImage.lockFocus();
			General/NSGraphicsContext.currentContext()
.setImageInterpolation(General/NSGraphicsContext.General/ImageInterpolationHigh);
			originalImage.drawInRect(new General/NSRect(0,0,newWidth, newHeight), new 
General/NSRect(0,0,originalImage.size().width(), originalImage.size().height()),
General/NSImage.General/CompositeSourceOver, 1.0f);
			thumbImage.unlockFocus();
			com.webobjects.foundation.General/NSData result;
			result = jpegImageData(thumbImage);
			General/NSAutoreleasePool.pop(myPool);
			return result;
	}
....
}


----

You may not be able to attach to the windowserver from the daemon if it was launched in a different context (the bootstrap context in this case, probably). I suggest you find some other Java image manipulation library that doesn't rely on a connection to the windowserver.

 -- General/FinlayDobbie