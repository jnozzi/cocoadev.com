I've got a bit of a pickle of a situation going on. So before I carry on, let me attempt to describe my situation.

I've got a slider which controls a real-world device (A servo) -- on dragging the slider, positional updates are sent to the servo. The granularity is not important, as the slider's only there to verify a connection and range boundings. This all works fine. 

Now, the reality of course is that a servo has a maximum speed, and that may or may not be the same speed the slider's moving at -- and, to make things nice & hairy, the slider, via an General/NSTimer, follows its servo's current position (since this is a GUI frontend to a very complex feedback-based system the servos can move of their own "accord"). What this means is the slider follows its servo, until you drag it to some position, and on letting go, the slider will show the servo's progression to that target value.

This might justify a custom control, but I don't feel like it's worth the time investment.

Anyway, the trouble is, I have to use an General/NSTimer attached to the General/NSRunLoop via General/NSEventTrackingRunLoopMode so that other controls and views in the heirarchy are able to update themselves while the slider drags -- but this means the slider "jerks" around under the mouse cursor.

What I'd like is notification that the slider has begun dragging and ended dragging so I can toggle a flag which the timer's update function will use to determine wether to update the slider position or not -- I tried the General/NSControl notifications  General/NSControlTextDidBeginEditingNotification and the corresponging end notification since they seemed like they *might* be relevant. But they didn't get called, so I assume General/NSSlider's don't send those notifications.

Ideally, I could just have something like this in my timer's callback:

    
if ( ![servoSlider isTracking] )
{
    [servoSlider setFloatValue: somePosition];
}



Am I missing something? I looked at the General/NSSlider, General/NSControl, General/NSSliderCell, General/NSActionCell & more and couldn't find either a method to return YES if the control's active or tracking or a notification that did anything like what I need.


--General/ShamylZakariya

----

Just subclass General/NSSlider and name the class General/ServoSlider?, parse the header for the new class in IB (see General/ComponentDevelopment for info on parsing headers in IB), change the custom class for the slider in IB to your new subclass (General/ServoSlider?), implement mouseDown: for your slider subclass (but don't forget to send the event to "super"), connect the slider in IB to a controller object General/IBAction (I'm sure you alread have this connection).

Now you are sent a message upon a mouseDown event and an action message when the user is done dragging the slider.

The subclass should also use a custom General/NSSliderCell (see General/PostNotificationWhenSliderEndEditing), this code should work:

**General/ServoSlider.h**

    
#import <General/AppKit/General/AppKit.h>

#define kNotifySliderCellDidEndEditing @"General/NotifySliderCellDidEndEditing"

@interface General/NotifySliderCell : General/NSSliderCell
@end

@interface General/ServoSlider : General/NSSlider
@end


**General/ServoSlider.m**

    
#import <General/AppKit/General/AppKit.h>
#import "General/ServoSlider.h"

@implementation General/NotifySliderCell

- (void)stopTracking:(General/NSPoint)lastPoint at:(General/NSPoint)stopPoint 
    inView:(General/NSView *)controlView mouseIsUp:(BOOL)flag
{

    if (flag == YES) {
        General/NSNotificationCenter *nc = General/[NSNotificationCenter defaultCenter];
        [nc postNotificationName:kNotifySliderCellDidEndEditing
                          object:self];
    }

    [super stopTracking:lastPoint at:stopPoint 
                 inView:controlView mouseIsUp:flag];
}

@end

@implementation General/ServoSlider

- (void)sliderCellDidEndEditing:(id)sender {
    General/NSLog(@"sliderCellDidEndEditing");
}
 
- (void)viewDidMoveToWindow {
    General/NSSliderCell *notifySliderCell = General/[[[NotifySliderCell alloc] init] autorelease];
    [self setCell:notifySliderCell];
    General/NSNotificationCenter *center = General/[NSNotificationCenter defaultCenter];
    [center addObserver:self
                    selector:@selector(sliderCellDidEndEditing:)
                    name:kNotifySliderCellDidEndEditing
                    object:nil];
}

- (void)dealloc {
    General/NSNotificationCenter *center = General/[NSNotificationCenter defaultCenter];
    [center removeObserver:self];
    [super dealloc];
}

- (void)mouseDown:(General/NSEvent *)theEvent {
    General/NSLog(@"mouseDown");
    [super mouseDown:theEvent];
}
@end


--zootbobbalu

Looks good to me! I appreciate it. Thanks,

--General/ShamylZakariya

----

Well, after some time experimenting, I decided that I was taking the wrong approach, overall -- it seemed semantically incorrect to have the slider both represent "real" position and control "intended" position for the servos, so, I figured out a neat an unobtrusive way to make display both simultaneously. 

I made the slider always represent the intended ( holding ) position for the servo, and marker beneath it shows ( constantly updated ) the actual position.

Check out the screenshot:

http://home.earthlink.net/~zakariya/files/General/TrackingSliders.gif

Anyway, I just thought I'd followup.

--General/ShamylZakariya

*Cool solution, that looks nice!*

----

Hey Shamyl, I have an ECE background so signals and systems are always interesting to me. Are you heathkit'n this or are you doing this for research? --zootbobbalu

Well, I'm 100% self taught, but I'm doing this for my own research into AI (maybe someday I'll go back to school to study it properly). Anyway, the electronics are mostly home brewed, but I'm using some off-the-shelf stuff for AD conversion and serial-to-servo control. Since I'm not remotely experienced with EE I'm trying to keep as much in software as possible.

Anyway, in case you're interested, this is part of the frontend to an environment simulator for AI-based walking/locomotion systems. The simulator exposes the same interfaces as the hardware, so I can do tests while sitting in a coffee shop, instead of the machine shop ;)

As it regards signals & systems, the whole precept for the "brain" is the idea of feedback based emergent systems of asynchronous, quasi-autonomous mini agents ( each consists of less than 100 LOC ) each handling some aspect of motor control; they work together to build an overall behavior satisfying the needs of the machine at the moment, like, "walk forward". It's a lot of fun.

You can see, then, why it's important to be able to show feedback dynamically while controlling input!

--General/ShamylZakariya

Wow... do you have a webpage set up about this? If not, you should. I'd be willing to host small files if you need the space.

-- General/RobRix

Actually, I'm working on a page. But it's hard since I'm a graphic designer by day and it would hurt my sense of professionalism to just slap a page together ;)

--General/ShamylZakariya

That's cool you are 100% self taught!! My focus in school was solid state devices which involved many simulations, so programming was forced upon me. I started with C and now I'm a full blown Cocoa addict!! I'm also an audio nut and have designed and built countless speaker/PA systems from scratch. Passive and active filters are always of interest, even causal systems fascinate me. I have been wanting to dive into General/FFTs on my mac to design digital audio filters, but there *aint* many �beginner guides to frequency domain programming for Cocoa�. I have a decent understanding of the General/QuickTime API now, so lately my concentration has been focused on figuring out signal processing with �os x�, more specifically creating General/GUIs to display real time signals grabbed from a QT movie that is playing. This involves many thread safety issues, but I�m to the point where I can safely hand blocks of raw 32 bit floating point samples to the main application thread to do whatever�

Now I starting to optimize an General/NSView that can draw frames of samples. The CPU overhead is about 24% (450MHz G4 no quartz extreme) to display 40,960 samples per frame at a sampling rate of 44.1kHz. The current draw method only draws points relative to the size of the view, but this is still a computationally heavy load. I think I can get the CPU usage down to almost nothing when I finish a draw method that doesn�t rely on an General/NSBezierPath and instead works with a raw bitmap (if anyone knows the most efficient way to rotate a bitmap horizontally for display purposes I'm all ears, is it better to use an General/NSAffineTransform, or go with a dedicated General/OpenGL implementation to rotate a bitmap 90 degrees?). 

Once I finish the UI element for displaying real time digital signals, I want to figure out how to manipulate samples in the frequency domain. Discrete General/FFTs are not scary to me, but figuring how to harness Altivec for signal processing is a little beyond the scope of the topics posted here and most other Cocoa application development discussions. 

Have you used Altivec for any signal processing work? --zootbobbalu

I also started with C & Pascal, back in maybe 1989/1990 when I first got my hands on a Mac classic in junior high school; you know, the kind with the 5 inch BW monitor and two disc drives. The thing is, I always loved programming, but it's always been a thing on the side for me, since I was an art major in college and work as a graphic designer now. It wasn't until a few years ago that I decided to pursue feedback systems and robotics, so I have to be honest in saying that my mathematical foundations are weak, at best, though for what it's worth I'm actually reasonably quick when it comes down to brass tacks.

You know, if anything, I've always figured that I could just leave math out, or keep it as simple as possible... I think that when it comes to robotics/AI, people tend to worry too much about ludicrously complicated algorithms to model neuron response/triggering/etc because it lets them think they're figuring things out ( when in fact, science knows *nothing* about how the brain works -- trust me, my GF's in neuroscience ). The best AI results so far have been from people like Rodney Brooks who've kept their feedback systems as simple mathematically and logically as possible, and I'm pursuing that approach as well.

As it pertains to Cocoa ( stay on topic! ), my actual AI systems are written entirely in c/c++ and have absolutely no math, whatsoever.  However, the simulation environment, which basically provides a fairly realistic physical environment for the robots to ( learn to ) walk around in depends on a huge open-source physics library called the General/OpenDynamicsEngine ( http://opende.sf.net ) which could benefit greatly from Altivec optimizations.

I'll be honest in saying that I don't really understand ODE's deep mathematics, however, I've been using it for a while and I'm grokking it pretty well anyway. Further, I've read up on the altivec c API which apple's provided and it looks nice. The ODE core developers are planning on an x86 General/SIMDizing of ODE, and I can read over that to get an idea of how to vectorize it in a PPC friendly manner.

However, to answer your question, nope. I've done no "real" signal processing and I've never written a line of Altivec code... I bet I'll have to at some point ;)

I would like to know how you're cranking such good performance from General/NSView drawing... it's not like Cocoa's drawing General/APIs are slow, but they're not fast either. Were I in such a situation, I'd just go 100% General/OpenGL -- in case you're worried about the learning curve, I had avoided GL so hard for so long I'd actually written my own *basic* portable c++ 3d engine ( with depth buffering, textures, etc ) solely to stay away from GL -- but in march I bought the General/RedBook and have never looked back. I'll probably never use *anything* but General/OpenGL from now on for anything more than trivial drawing tasks.

--General/ShamylZakariya