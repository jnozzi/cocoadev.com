I'm currently trying to create a real-time [[CIImage]]-based filter for a captured video-stream. The basic task is this: take a [[CIImage]] of size (sx, sy) and apply a mapping that yields an [[CIImage]] of size (dx, dy), where dx > sx, dy > sy.

The mapping is basically an array of coordinates with dimension (dx, dy). At each point, the source-pixel is stored. This is the inner loop of my mapping, just to make you grasp the idea:

<code>
  for(int dy = 0; dy < _dest.height; dy++) {
    coord ''mappingRow = _mappingRows[dy];
    unsigned int ''pixelRow = _dest.rowtab[dy];
    for(int dx = 0; dx < _dest.width; dx++) {
      int sx = mappingRow[dx].x;
      int sy = mappingRow[dx].y;
      ''(pixelRow++) = _source.rowtab[sy][sx];
    }
  }
</code>

So far, so good. The _source and _dest-variables are structs that contain all information necessary to deal with [[CIContext]] and look like this:

<code>
typedef struct {
  [[CGContextRef]] port;
  [[CIContext]]'' context;
  int width;
  int height;
  int bytesPerRow;
  int byteCount;
  [[CIFormat]] picelFormat;
  void '' data;
  int '''rowtab;
} [[ContextInfo]]; 
</code>

They are initialized in the init-method of my filter-object, as well as the mapping-table.

Everything works just fine when using the filter once. This is the whole map-method, containing the above loop. I draw the image to _source, map it to _dest.data and create an [[CIImage]] out of that.


<code>
- ([[CIImage]] '') map: ([[CIImage]]'')inputImage {
  [[CGRect]] extent = [inputImage extent];
  
  [_source.context drawImage: inputImage
	  atPoint: extent.origin
	  fromRect: extent];
  for(int dy = 0; dy < _dest.height; dy++) {
    coord ''mappingRow = _mappingRows[dy];
    unsigned int ''pixelRow = _dest.rowtab[dy];
    for(int dx = 0; dx < _dest.width; dx++) {
      int sx = mappingRow[dx].x;
      int sy = mappingRow[dx].y;
      ''(pixelRow++) = _source.rowtab[sy][sx];
    }
  }

  [[CIImage]] '' r = [[[[[CIImage]] alloc] 
		  //initWithBitmapData:[[[NSData]] dataWithBytes: _dest.data length: _dest.byteCount] 
          initWithBitmapData:[[[NSData]] dataWithBytesNoCopy: _dest.data length: _dest.byteCount freeWhenDone: NO] 
		  bytesPerRow: _dest.bytesPerRow 
		  size:[[CGSizeMake]](_dest.width, _dest.height) 
		  format:kCIFormatARGB8
		  colorSpace:_colorSpace] autorelease];
  return [ r autorelease ];
}
</code>

As you might see, the raw pixel buffers _source.data and _dest.data are allocated once and are supposed to be worked on as long as the filter exists. 

Now when using this filter in my sequence-grabbing application that captures an [[NSImage]] from my i-Fire camera, I do this in an extra method:

<code>
-([[NSImage]]'') mapWithNSImage: ([[NSImage]]'') image 
{	
  [[NSBitmapImageRep]] ''bitmap = [[image representations] objectAtIndex: 0];
  [[CIImage]] ''im = [[[[[CIImage]] alloc] initWithBitmapImageRep: bitmap] autorelease];

  im = [self map: im];

  bitmap = [[[NSCIImageRep]] imageRepWithCIImage: im];
  [[CGRect]] extent = [im extent];
  image = [[[[[NSImage]] alloc] initWithSize: [[NSMakeSize]](extent.size.width, extent.size.height)] autorelease];
  [image addRepresentation: bitmap];
  return image ;
  
}
</code>

See also (http://www.gigliwood.com/weblog/Cocoa/Core_Image__Practic.html)