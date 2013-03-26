

Is there any way to be notified when a textView is scrolled by user?

----

An [[NSTextView]] in IB is actually an [[NSTextView]] inside an [[NSClipView]] inside an [[NSScrollView]]. Either the [[NSTextView]] or the [[NSClipView]] will be changing their bounds or frame during a scrolling operation; most likely the [[NSClipView]] will change its bounds. You can have any [[NSView]] send an [[NSNotification]] when its bounds or frame are changed.