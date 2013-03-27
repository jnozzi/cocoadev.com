
I am trying to apply the animated scrolling of text from Apple's General/FancyAbout sample code example to a window with an General/NSTextView object and a button to instigate the scrolling.

The example code says, "To keep things simple, this application just puts the text inside an General/NSScrollView, hides the scroller, and uses a timer to regularly advance the amount by which the text is scrolled". I am trying to do a simpler example, using Interface Builder to create a window with two items, an General/NSTextView and an General/NSButton. I placed some boilerplate text in the General/NSTextView that is longer than the view, so that it has a vertical scroller.

But I am confused about the difference between an General/NSTextView and an General/NSScrollView, and how to access the General/NSScrollView in Interface Builder and Xcode, so I can use the code given in the General/FancyAbout sample to do what I want. Is there an General/NSScrollView automatically created when I caused the vertical scroller to be shown in Interface Builder? When I click on the General/NSTextView item in the Window, the Inspector shows General/NSTextViewInspector and the popup says Attributes. If I change the popup to "Custom Class", it shows Class General/NSScrollView, but I see no way to add an outlet for General/NSScrollView, which is the class used by the example code. Must I use the Layout command "Make Subviews of .. General/ScrollView" in order to add the outlet? But then there are two sets of scroll bars. Sorry I am so dense.

Larry

--------------

I found the answer in the General/CocoaBuilder archives - the method "enclosingScrollerView" returns the desired General/NSScrollView.

Thanks,

Larry