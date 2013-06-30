

Hi, folks, and sorry my english. I have such a problem in my app, but i'll show it on an simple example.

    

- (id)timer
{
	static const double interval = 0.1;

	if (_timer == nil)
	    _timer = General/[NSTimer
          scheduledTimerWithTimeInterval:interval
          target:self
          selector:@selector(update)
          userInfo:nil
          repeats:YES];
  
  return 0;
}

- (id)update
{
  General/NSImage *imageFromBundle = General/[[NSImage alloc] initWithContentsOfFile:@"/mybmp.bmp"];
  
  if([imageFromBundle isValid]) printf("\n imageFromBundle valid \n");

  if (imageFromBundle)
  {
    [myImageView setImage:imageFromBundle]; //  General/NSImageView* myImageView
    [imageFromBundle release];
  }
  else
  {
    General/NSLog(@"File could not be loaded.");
  }
  
  return 0;
}



So as you can see i've started timer pointed to 'update' function, where simply opening and drawing bmp file. But is not drawing! Only 'white' area ov General/NSImageView in my gui. What is the problem? May be you know.. (( The thing is that when i'm not runnig General/NSTimer and simply run 'update' BMP is normaly drawed...

----

This is because you need to add it to the General/NSRunLoop first:

    
- (id)timer
{
	static const double interval = 0.1;

	if (_timer == nil){
	    _timer = General/[NSTimer
          scheduledTimerWithTimeInterval:interval
          target:self
          selector:@selector(update)
          userInfo:nil
          repeats:YES];
       General/[[NSRunLoop currentRunLoop] addTimer:_timer forMode:General/NSDefaultRunLoopMode];
  }
  return 0;
}



Also, this method should be -(void), as it doesn't return any object. -(id) methods are used when you need to return various object instances. You may return _timer.

----
No he doesn't. The     scheduled in the method name means that the timer has already been added to the run loop for you.


----

Not sure about this, but doesn't @selector(update) point to -(void)update; instead of -(void)update:(id)sender; (which would be @selector(update:))? 

----

You may need to force drawing here. After you set your image view's image, call:     [myImageView display]; ... that may fix it.

----

I've already tried force redraw, nothing new..
There is one more thing that i've not undisclosed. I'm grabbing frames from camera, i mean system web camera, by General/QuickTime components like General/SGStartRecord.. and then having some frame data i'm trying to draw it in General/NSImageView.. For now i suppose that it's the problem of some type of General/SequenseGrabber loop.. and i don't know were and what for to look at..

    

int opencam (...)
{
  grabber = General/OpenDefaultComponent (General/SeqGrabComponentType, 0);

  ....
  result = General/SGSetDataProc (grabber, General/NewSGDataUPP(dataproc), (long) capture)
  ....
  result = General/SGStartRecord (grabber);
  ....   

  dr = new Dr();
  dr->taskgrabber(grabber);

  return 1;
} //init components

General/OSErr dataproc (General/SGChannel channel, Ptr data, long len, long *, long, General/TimeValue time, short, long refCon)
{
  handledata(data);  
  return noErr;

} //callback

void handledata(void* data)
{
  ...  
  dr->drawframe(data, roi);
  ...
  
  return;
} //editing data

-------------

void Draw::drawFrame(void* data, mySize roi)
{
  ...
  General/NSImage* outimage = General/[[NSImage alloc] initWithSize:General/NSMakeSize(roi.width, roi.height)];
  [myViewClass updateImage:outimage];

} // another editing data an send it to redraw. For NOW it's not used!!


void Dr:: taskgrabber(General/SeqGrabComponent grabber)
{
  //[myViewClass setgrabber:grabber];
  [myViewClass update];

} // need to show my General/SeqGrabComponent to another class. For NOW it's used for simply file drawing function calling

--------------

- (id)update//:(General/NSImage*)outimage
{
  General/NSImage *imageFromBundle = General/[[NSImage alloc] initWithContentsOfFile:@"/mybmp.bmp"];
  
  if([imageFromBundle isValid]) printf("\n imageFromBundle valid \n");

  if (imageFromBundle)
  {
    [myImageView setImage:imageFromBundle]; //  General/NSImageView* myImageView
    [imageFromBundle release];
  }
  else
  {
    General/NSLog(@"File could not be loaded.");
  }
  
  //[output setImage:outimage];

  return 0;
} //simply file drawing functions



- (id)setgrabber:(General/SeqGrabComponent)grabber
{
  _grabber = grabber;
    
  [self timer];
  
  return 0;
}



- (id)timer
{
  static const double idleInterval = 1.0 / 60.0;

  General/SGIdle(_grabber); // grab frame

  if (_timer == nil)
  	_timer = General/[NSTimer
          scheduledTimerWithTimeInterval:idleInterval
          target:self
          selector:@selector(timer)
          userInfo:nil
          repeats:YES];
 
  return 0;
}



So if i'll call (id)update - i can see BMP. But if i call first sequencegrabber initialization and so on - and finaly coming to (id)update - i CAN'T see Bmp (( Its path is opencam()-> taskgrabber()-> (id)update for now, i other word initialization and drawing opened image.. 

Well i've tried one more thing, i've comented opencam (...) function except calling dr->taskgrabber(grabber); ... Nothing new) So it's now the problem of camera initialization..