

The following is from http://www.lucasnewman.com/iphone/

'''[[UIAnimation]]'''

An abstract superclass used to animate properties of a [[UIView]]. It is supported by a collection concrete subclasses provided for the alpha, frame, scroll position, affine transformation (including a special subclass for rotation), and zooming.

<code>
typedef enum {
    kUIAnimationCurveEaseInEaseOut,
    kUIAnimationCurveEaseIn,
    kUIAnimationCurveEaseOut,
    kUIAnimationCurveLinear,
} [[UIAnimationCurve]];
</code>

// Creating animations

%%BEGINCODESTYLE%%- (id)initWithTarget:(id)target;%%ENDCODESTYLE%%

// Properties

%%BEGINCODESTYLE%%- (id)target;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setDelegate:(id)delegate;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (id)delegate;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setAction:(SEL)action;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (SEL)action;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setAnimationCurve:([[UIAnimationCurve]])animationCurve;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (float)progressForFraction:(float)fraction;%%ENDCODESTYLE%%

// Implemented by subclasses

%%BEGINCODESTYLE%%- (void)setProgress:(float)progress;%%ENDCODESTYLE%%

// Controlling animations

%%BEGINCODESTYLE%%- (void)stopAnimation;%%ENDCODESTYLE%%

----

'''Provided [[UIAnimation]] subclasses:'''

'''[[UIAlphaAnimation]]'''

%%BEGINCODESTYLE%%- (void)setStartAlpha:(float)alpha;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setEndAlpha:(float)alpha;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (float)alphaForFraction:(float)fraction;%%ENDCODESTYLE%%

'''[[UIFrameAnimation]]'''

%%BEGINCODESTYLE%%- (void)setStartFrame:([[CGRect]])frame;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setEndFrame:([[CGRect]])frame;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- ([[CGRect]])endFrame;%%ENDCODESTYLE%%

'''[[UIRotationAnimation]]'''

%%BEGINCODESTYLE%%- (void)setStartRotationAngle:(float)angle;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setEndRotationAngle:(float)angle;%%ENDCODESTYLE%%

'''[[UIScrollAnimation]]'''

%%BEGINCODESTYLE%%- (void)setStartPoint:([[CGPoint]])startPoint;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setEndPoint:([[CGPoint]])endPoint;%%ENDCODESTYLE%%

'''[[UITransformAnimation]]'''

%%BEGINCODESTYLE%%- (void)setStartTransform:([[CGAffineTransform]])transform;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setEndTransform:([[CGAffineTransform]])transform;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- ([[CGAffineTransform]])transformForFraction:(float)fraction;%%ENDCODESTYLE%%

'''[[UIZoomAnimation]]'''

%%BEGINCODESTYLE%%+ (float)defaultDuration;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (id)zoomAnimationForTarget:(id)target endScale:(float)scale endScrollPoint:([[CGPoint]])point;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (id)zoomAnimationForTarget:(id)target focusRect:([[CGRect]])focusRect deviceBoundaryRect:([[CGRect]])deviceBoundaryRect scale:(float)scale;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setEndScale:(float)scale;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setStartScale:(float)scale;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setEndScrollPoint:([[CGPoint]])point;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)setStartScrollPoint:([[CGPoint]])point;%%ENDCODESTYLE%%

----

'''[[UIAnimator]]'''

[[UIAnimator]] provides a shared controller for starting and stopping global animations.

%%BEGINCODESTYLE%%+ (id)sharedAnimator;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (void)disableAnimation;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (void)enableAnimation;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)addAnimation:([[UIAnimation]] '')animation withDuration:(double)duration start:(BOOL)start;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)addAnimations:([[NSArray]] '')animations withDuration:(double)duration start:(BOOL)start;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)removeAnimationsForTarget:(id)target;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)removeAnimationsForTarget:(id)target ofKind:(Class)classOfTarget;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)startAnimation:([[UIAnimation]] '')animation;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)stopAnimation:([[UIAnimation]] '')animation;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (float)fractionForAnimation:([[UIAnimation]] '')animation;%%ENDCODESTYLE%%

----

'''[[UIView]] (Animation)'''

This category on [[UIView]] allows adding [[UIAnimations]] to the view, and also allows modifying global animation parameters.

%%BEGINCODESTYLE%%+ (void)beginAnimations:([[NSArray]] '')animations;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (void)endAnimations;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (void)enableAnimation;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (void)disableAnimation;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (void)setAnimationAutoreverses:(BOOL)autoreverses;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (void)setAnimationCurve:([[UIAnimationCurve]])animationCurve;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (void)setAnimationDelay:(double)startDelay;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (void)setAnimationDelegate:(id)delegate;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (void)setAnimationDuration:(double)duration;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (void)setAnimationFrameInterval:(double)minimumTimeIntervalBetweenFrames;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (void)setAnimationFromCurrentState:(BOOL)shouldAnimateFromCurrentState;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (void)setAnimationPosition:([[CGPoint]])position;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (void)setAnimationStartTime:(double)startTime;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (void)setAnimationRepeatCount:(float)repeatCount;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (void)setAnimationRoundsToInteger:(BOOL)shouldRoundToInteger;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (void)setAnimationWillStartSelector:(SEL)willStartSelector;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%+ (void)setAnimationDidStopSelector:(SEL)willEndSelector;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)addAnimation:([[UIAnimation]] '')animation forKey:([[NSString]] '')key;%%ENDCODESTYLE%%