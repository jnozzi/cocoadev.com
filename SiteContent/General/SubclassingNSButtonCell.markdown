I'm trying to clear up a lack of understanding that I clearly have about subclassing.

I have an [[NSMatrix]] of [[NSButtonCells]] already set up.  Works fine - as expected.
Now I want to change the behavior (a new mouse over behavior, actually).  So I tried to subclass [[NSButtonCell]] and test by overriding mouseDown: by creating 
<code>
/'' [[MyButtonCell]] ''/

#import <Cocoa/Cocoa.h>

@interface [[MyButtonCell]] : [[NSButtonCell]]
{
}
@end



#import "[[MyButtonCell]].h"

@implementation [[MyButtonCell]]
- (void)mouseDown:([[NSEvent]] '')theEvent
{
	[[NSLog]](@"[[MYMouseDown]]!");
	//	[super mouseDown: theEvent];
}
@end
</code>

In IB I set the various [[NSButtonCell]] items to my custom class of [[MYButtonCell]].
However when run, the check boxes exhibit the same behavior as before.  Where am I going wrong?

Thanks

----

[[NSCell]] (and thus [[NSButtonCell]]) is not a subclass of [[NSResponder]], and so it doesn't use <code>mouseDown:</code> or any other [[NSResponder]] messages. Look at the documentation/header for [[NSCell]] to see which methods [[NSCell]] uses to detect mouse clicks.

----

Never mind - I'm an idiot.  I'm subclassing [[NSMatrix]], which, in fact, actually ''has'' a mouseDown: method.

----

If you'd rather subclass [[NSButtonCell]], take a look at the mouse tracking methods. <code>-[[[NSCell]] startTrackingAt:inView:]</code>, <code>-[[[NSCell]] trackMouse:inRect:ofView:untilMouseUp:]</code>, etc.

----

I got too cocky after I figured out how to override the mouseDown: method of the [[NSMatrix]].
Now I can't figure out how to handle the mouseEntered:/mouseExited methods of my individual [[NSButtonCells]] in the [[NSMatrix]].  I subclassed [[NSButtonCell]] and tried to simply override those two methods, however it doesn't seem to be working.  What am I not understanding?

----
Again, you're hitting the [[NSCell]]/[[NSControl]] problem. You should really check out http://developer.apple.com/documentation/Cocoa/Conceptual/[[ControlCell]]/index.html and take a look at [[NSCell]]'s documentation. However, don't take this as RTFM...I used to have a lot of the same problems as you. Basically, cells handle stuff differently than views (or responders in general), so you have to use the [[NSCell]] versions of the responder methods. --[[JediKnil]]

----
I really appreciate the advice.  And RTFM isn't an awful suggestion  :-)  but I guess there are some fundamental concepts that I still haven't gotten a hold of.  [[NSButtonCell]] inherits from [[NSCell]], right?  Perhaps I don't know understand what mouseEntered:/mouseExited: does.  Guess it's time for me to RTFM.
----
Ok, I'm trying to get a handle on startTrackingAt:inView: but it only seems to be called when the mouse is in the control AND down.  Am I wrong?  If not, how can I track the mouse when the mouse isn't down.

I can read the documentation, but the likes of me really need examples sometimes.
----
[[NSTableViewRollover]] might work for an example.

----
Not to take away from your problem but [[CCDColoredButtonCell]] could use a pair of skilled eyes. I've been having trouble getting it working as a dataCell in an [[NSTableView]] - it only draws in the first row and I plain can't figure out why.

----

'''Be sure to retain your private instance variables when subclassing'''  (formerly titled [[ImplementingNSCopying]], but that wasn't the problem)

I was subclassing [[NSActionCell]], which seemed to require me to adopt [[NSCopying]] in the subclass otherwise things fail when my subclass is used in a table view. Initially I did so naively, just creating a new instance, setting instance variables and continuing. I realized soon enough that this was probably wrong, since I wasn't setting all the ivars, just my additions. So I changed it to send copyWithZone: to super, but that didn't work at all. The cells disappeared as the table view (column) copied them but the copies ... failed. I got a complaint when debugging that [[NSCFType]] does not respond to -drawWithFrame:inView messages.

The docs on implementing [[NSCopying]] told me that my strategy (alloc/int, [[NSCopyObject]]() or call super's implementation) depends on the implementation of the superclass. ??? I don't ''know'' how [[NSActionCell]] implements -copyWithZone:.

I was wondering whether this has something to do with subclassing Apple classes which adopt [[NSCopying]]. But the solution turned out to be:  I wasn't properly assigning the new private instance variables in the subclass, so they weren't being retained.