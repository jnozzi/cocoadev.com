Did anybody try to set layer - General/CALayer or General/CATiledLayer of a view embeded in General/NSScrollView in a General/NSSplitView. I had tried and the result was absolute disaster. I can't figure out how to make it work.

Appkit Release Notes states:
"Note that when using layer-backed mode for an General/NSScrollView's document view, it's necessary for the enclosing General/NSScrollView, or at least its General/NSClipView ("content view"), to also be layer-backed in order for scrolling to function correctly.". Did that help?