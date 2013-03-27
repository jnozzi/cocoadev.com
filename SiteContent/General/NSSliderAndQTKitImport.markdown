
Have problem in getting my Slider Working.  Basically I'm trying to modify the example given on the ADC website but add a Playback Rate slider for the movie being played.

http://developer.apple.com/samplecode/General/QTKitImport/General/QTKitImport.html

Basically what I have done is added a slider in the interface Builder, below the General/QTMovieView object in the main window.  I have setup an General/IBOutlet slider in the main controller which connects to the slider and also a action call slide.


In the header file General/MovieDocument.h i added the General/IBOutletNSSlider *slider      and    - (General/IBAction)slide:(id)sender;    to the rest of the code
     
@interface General/MovieDocument : General/NSDocument
{
        // movie window
    General/IBOutlet General/NSWindow		*mMovieWindow;
    General/IBOutlet General/QTMovieView	*mMovieView;
    General/IBOutlet General/NSSlider       *slider;

        // movie document
    General/QTMovie					*mMovie;
}
- (General/IBAction)slide:(id)sender;
 


and in the General/MovieDocument.m file I added 
     
- (General/IBAction)slide:(id)sender
{
     float sliderValue = [ sender floatValue ];
	 General/NSLog( @"float value %f", sliderValue );
	 [mMovie setRate: sliderValue];
}
 

But this does not work at all, the speed of the playback of the movie does not change when i move the slider when I run the program and the log does not record down the changes in the slider.  Anyone can help? or suggest anything that I may solve this problem?  General/THanks

----
Did you connect the General/NSSlider in the Nib to the slide: action in your controller?  Also make sure you have continuous checked (or unchecked) on the slider to have it react the way you would prefer.  Continuous means that it will constantly call the action slide: while the mouse is down and the value is changing.  Otherwise, it will only call the slide once the mouse has been released.

-General/VinayVenkatesh