

Part of the iPhone [[UIKit]] framework. Subclass of [[UIResponder]]. So very much like [[NSView]].

%%BEGINCODESTYLE%%- (id)initWithFrame:([[CGRect]])rect;%%ENDCODESTYLE%%

Designated initializer.

%%BEGINCODESTYLE%%- (void)addSubview:([[UIView]]'')view;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)drawRect:([[CGRect]])rect;%%ENDCODESTYLE%%

Since we don't have a [[UIGraphicsContext]] class, [[CoreGraphics]] is our friend now. All those CG calls need a [[CGContextRef]], and here's how you get it:

  <code>[[CGContextRef]] [[UICurrentContext]]();</code>

%%BEGINCODESTYLE%%- (void)setNeedsDisplay;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setNeedsDisplayInRect:([[CGRect]])rect;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- ([[CGRect]])frame;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- ([[CGRect]])bounds;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setTapDelegate:(id)delegate;%%ENDCODESTYLE%%

Sets the tap delegate. See below.

'''
Swiping!
'''

<code>
typedef enum
{
	kUIViewSwipeUp = 1,
	kUIViewSwipeDown = 2,
	kUIViewSwipeLeft = 4,
	kUIViewSwipeRight = 8
} [[UIViewSwipeDirection]];
</code>

%%BEGINCODESTYLE%%- (BOOL)canHandleSwipes;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (int)swipe:([[UIViewSwipeDirection]])num withEvent:([[GSEvent]]'')event;%%ENDCODESTYLE%%

This one is listed in the [[UIView]]-[[LKLayerDelegate]].h header, and the iTetris demo uses it to good effect, but it does nothing for me. Can't tell why, but I don't really get layers yet..

%%BEGINCODESTYLE%%- (void)drawLayer:(id)inLayer inContext:([[CGContextRef]])inContext;%%ENDCODESTYLE%%

----
'''iTetris follows some bad practices when it comes to drawing.  A [[UIView]] is transparently backed by an [[LKLayer]], and the view uses this method to draw itself internally, so don't override it! Just use -drawRect: and everything will work as expected.''' -- Lucas Newman
----

'''
Tap delegate methods
'''

%%BEGINCODESTYLE%%view:handleTapWithCount:event:%%BEGINCODESTYLE%%

%%BEGINCODESTYLE%%view:handleTapWithCount:event:fingerCount:%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%viewHandleTouchPause:isDown:%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%viewDoubleTapDelay:%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%viewRejectAsTapThrehold:%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%viewTouchPauseThreshold:%%ENDCODESTYLE%%