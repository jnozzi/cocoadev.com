

The following describe the direction the content moves--that is, the opposite direction of the viewport. When transitioning into a submenu, use UIT<nowiki/>ransitionShiftLeft; when navigating back, use UIT<nowiki/>ransitionShiftRight.

<code>
typedef enum
{
  [[UITransitionShiftImmediate]] = 0, // actually, zero or anything > 9
  [[UITransitionShiftLeft]] = 1,
  [[UITransitionShiftRight]] = 2,
  [[UITransitionShiftUp]] = 3,
  [[UITransitionFade]] = 6,
  [[UITransitionShiftDown]] = 7
} [[UITransitionStyle]];
</code>

%%BEGINCODESTYLE%%- (void)transition:(UIT<nowiki/>ransitionStyle)style toView:([[UIView]]'')view;%%ENDCODESTYLE%%

Animate only the to view. Will look like a "slide over".

%%BEGINCODESTYLE%%- (void)transition:(UIT<nowiki/>ransitionStyle)style fromView:([[UIView]]'')view toView:([[UIView]]'')view;%%ENDCODESTYLE%%

Animate both views. Will look like a "swap".

%%BEGINCODESTYLE%%- (void)setDelegate:(id)delegate;%%ENDCODESTYLE%%

----

'''Delegate methods'''

%%BEGINCODESTYLE%%- (float)durationForTransition:([[UITransitionView]]'')view;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)transitionViewDidStart:([[UITransitionView]]'')view;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)transitionViewDidComplete:([[UITransitionView]]'')view fromView:([[UIView]]'')from toView:([[UIView]]'')to;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)transitionViewDidComplete:([[UITransitionView]]'')view finished:(BOOL)flag;%%ENDCODESTYLE%%

%%BEGINCODESTYLE%%- (void)transitionViewDidComplete:([[UITransitionView]]'')view;%%ENDCODESTYLE%%

----

I found a more complete version on a Japanese site (http://son-son.sakura.ne.jp/programming/iphone_uitransitionview.html). Now I can't read Japanese, but they do seem to work!

<code>
typedef enum
{
  [[UITransitionNothing]] = 0,
  [[UITransitionBothShiftLeft]] = 1,
  [[UITransitionBothShiftRight]] = 2,
  [[UITransitionBothShiftUp]] = 3,
  UITransitionError4 = 4,
  [[UITransitionCurrentShiftDown]] = 5,
  UITransitionError6 = 6,
  [[UITransitionBothShiftDown]] = 7,
  [[UITransitionNextShiftUp]] = 8,
  [[UITransitionNextShiftDown]] = 9
} [[UITransitionStyle]];
</code>