I'm currently trying to create a real-time General/CIImage-based filter for a captured video-stream. The basic task is this: take a General/CIImage of size (sx, sy) and apply a mapping that yields an General/CIImage of size (dx, dy), where dx > sx, dy > sy.

The mapping is basically an array of coordinates with dimension (dx, dy). At each point, the source-pixel is stored. This is the inner loop of my mapping, just to make you grasp the idea:

    
  for(int dy = 0; dy < _dest.height; dy++) {
    coord *mappingRow = _mappingRows[dy];
    unsigned int *pixelRow = _dest.rowtab[dy];
    for(int dx = 0; dx < _dest.width; dx++) {
      int sx = mappingRow[dx].x;
      int sy = mappingRow[dx].y;
      *(pixelRow++) = _source.rowtab[sy][sx];
    }
  }


So far, so good. The _source and _dest-variables are structs that contain all information necessary to deal with General/CIContext and look like this:

    
typedef struct {
  General/CGContextRef port;
  General/CIContext* context;
  int width;
  int height;
  int bytesPerRow;
  int byteCount;
  General/CIFormat picelFormat;
  void * data;
  int **rowtab;
} General/ContextInfo; 


They are initialized in the init-method of my filter-object, as well as the mapping-table.

Everything works just fine when using the filter once. This is the whole map-method, containing the above loop. I draw the image to _source, map it to _dest.data and create an General/CIImage out of that.


    
- (General/CIImage *) map: (General/CIImage*)inputImage {
  General/CGRect extent = [inputImage extent];
  
  [_source.context drawImage: inputImage
	  atPoint: extent.origin
	  fromRect: extent];
  for(int dy = 0; dy < _dest.height; dy++) {
    coord *mappingRow = _mappingRows[dy];
    unsigned int *pixelRow = _dest.rowtab[dy];
    for(int dx = 0; dx < _dest.width; dx++) {
      int sx = mappingRow[dx].x;
      int sy = mappingRow[dx].y;
      *(pixelRow++) = _source.rowtab[sy][sx];
    }
  }

  General/CIImage * r = General/[[[CIImage alloc] 
		  //initWithBitmapData:General/[NSData dataWithBytes: _dest.data length: _dest.byteCount] 
          initWithBitmapData:General/[NSData dataWithBytesNoCopy: _dest.data length: _dest.byteCount freeWhenDone: NO] 
		  bytesPerRow: _dest.bytesPerRow 
		  size:General/CGSizeMake(_dest.width, _dest.height) 
		  format:kCIFormatARGB8
		  colorSpace:_colorSpace] autorelease];
  return [ r autorelease ];
}


As you might see, the raw pixel buffers _source.data and _dest.data are allocated once and are supposed to be worked on as long as the filter exists. 

Now when using this filter in my sequence-grabbing application that captures an General/NSImage from my i-Fire camera, I do this in an extra method:

    
-(General/NSImage*) mapWithNSImage: (General/NSImage*) image 
{	
  General/NSBitmapImageRep *bitmap = General/image representations] objectAtIndex: 0];
  [[CIImage *im = General/[[[CIImage alloc] initWithBitmapImageRep: bitmap] autorelease];

  im = [self map: im];

  bitmap = General/[NSCIImageRep imageRepWithCIImage: im];
  General/CGRect extent = [im extent];
  image = General/[[[NSImage alloc] initWithSize: General/NSMakeSize(extent.size.width, extent.size.height)] autorelease];
  [image addRepresentation: bitmap];
  return image ;
  
}


See also (http://www.gigliwood.com/weblog/Cocoa/Core_Image__Practic.html)