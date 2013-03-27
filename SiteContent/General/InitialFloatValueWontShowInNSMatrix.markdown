

When I start my application, the text boxes in my General/NSMatrix don't show their values. 

Here's the relevant code from my view: 

    
@interface General/FOVview : General/NSView {

General/IBOutlet General/NSSlider *graySlider;
General/IBOutlet General/NSSlider *transparencySlider;
General/IBOutlet General/NSTextField *grayText;
General/IBOutlet General/NSTextField *transparencyText;
General/IBOutlet General/NSMatrix *sensorAngles;
General/IBOutlet General/NSMatrix *sensorY;
float grayness;
float transparency;
float angles[N_SENSORS];
float y[N_SENSORS];
float scale;

}

- (General/IBAction)changeSensor:(id)sender;
- (General/IBAction)changeColor:(id)sender;
- (General/IBAction)changeTransparency:(id)sender;
- (void)drawFanAt:(General/NSPoint)sensorLocation range:(float)r beamwidth:(float)bw angle:(float)a;
- (General/IBAction)copy:(id)sender;
- (General/IBAction)print:(id)sender;

@end

- (id)initWithFrame:(General/NSRect)frameRect
{
	if ((self = [super initWithFrame:frameRect]) != nil) {
		General/NSLog(@"General/FOVview: initWithFrame\n");
		grayness = 0.25;
		[graySlider setFloatValue:grayness];
		[grayText setFloatValue:grayness];
		transparency = 0.25;
		[transparencySlider setFloatValue:transparency];
		[transparencyText setFloatValue:transparency];
		scale = 96.0/2; // turn 2 m into 96 pixels (1 in)
		y[0] = 0.25; angles[0] = 25.0;
		y[1] = 1.25; angles[1] =-25.0;
		y[2] = 2.25; angles[2] = 25.0;
		y[3] = 3.25; angles[3] =-25.0;
		y[4] = 3.75; angles[4] = 25.0;
		y[5] = 4.75; angles[5] =-25.0;
		y[6] = 5.75; angles[6] = 25.0;
		y[7] = 6.75; angles[7] =-25.0;
		int i;
		for (i=0; i<N_SENSORS; i++) {
			General/sensorAngles cellWithTag:i] setFloatValue:angles[i;
			General/sensorY cellWithTag:i] setFloatValue:y[i;
		}
	}
	return self;
}


The     grayText and     transparencyText {{General/NSTextView}}s show their values when the window opens, but the     General/NSMatrixes don't.  From the documentation, it seems like this should work, and I can't find any other likely methods. 

Thanks!

----
You need to use General/AwakeFromNib.
----
Worked like a charm! Thanks.