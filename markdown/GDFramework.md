This is a framework for using the "GD" graphics library in Objective-C.
You can use this library for reading and writing images in GIF, JPEG and PNG
formats. You can resize and crop images, draw within them and render
text using General/TrueType fonts. There is also a grand total of one image filtering 
method.

If you're writing a daemon foundation tool you can't use the General/NSImage or General/NSFont
classes. The GD library is also much simpler - for better or worse - than 
Apple's frameworks. The GD library (and the PNG / JPEG libraries) are quite 
difficult to compile for Mac OS X. Here I provide a universal version of the
GD library and I have copied the JPEG and PNG libaries from another source.
Download the framework and source code here: 

http://mutablelogic.com/cocoa/General/GDFramework.zip (3.4Mb)

More information about the GD library here:

http://www.libgd.org/

There are comprehensive instructions within the "readme.txt" file in the framework,
including instructions on how to:

 

* Detect image formats

* Read and write images from General/NSData objects and files, and convert to General/NSImages

*  Draw lines, rectangles and strings

* Use colour and fonts

* Resize and crop

* Rebuild the GD libraries into universal binaries.

 

Let me know if there's any GD routines you'd like included in this framework, or if you
want to contribute any code to the framework, thanks - General/DavidThorpe.
  
----

Is there any way to convert between General/GDImage and General/NSImage, General/CIImage, General/CGImage, etc.? Perhaps, even if you can do nothing better than passing -General/TIFFRepresentation to -initWithData:, you should add -initWithBitmapImageRep: so that in the future you might be able to provide a better implementation.

----

Thanks, I've added a method to convert into an General/NSImage from a General/GDImage, although no translation the other way at the moment - not sure there's a lot of point because you can use the Quartz routines for drawing with General/NSImage's. The idea of this framework is a more lightweight alternative for quick "command line" and "daemon-based" batch editing. I would like to add TIFF and BMP support, but this isn't native to GD and I'll have to implement them myself, and will take a little bit longer - General/DavidThorpe