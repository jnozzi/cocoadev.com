

I have been looking to create an General/NSTextField or General/NSTextView that dynamically resizes its vertical height based on text entered. An example of this can be seen in iChat's and Adium's message entering view.

So far I have tried using General/NSTextField's and the size of the attributed string, but of course this has its limitations in that you cannot accurately measure the size of each line in the view. I assume that both iChat and Adium use General/NSTextView's as it seems to provide the best way of gauging the length of a line of text.

Does anyone have any experience with General/NSTextView's and dynamically resizing? I have busied myself with the documentation of General/NSLayoutManager, General/NSText and General/NSTextView for the last few hours but I cannot seem to find any way of achieving it. 

Thanks in advance. -- General/MatPeterson

*There's some code over at General/TextBox that you might find useful.*

I've posted some code for finding the size of an General/NSTextView's contents at General/NSTextViewSizeToFit.

----

Neato, didn't think it was that simple. Once I have the view written up I will post it there. Thanks guys. -- General/MatPeterson

----

Anyone figure this out for an General/NSTextField as opposed to an General/NSTextView? Something like the text boxes in iCal and General/AddressBook.

*You could probably make it work, but in the end it may be easier to simply use General/NSTextViews instead. You can set up an General/NSTextView that looks and acts just like a text field by having its enclosing scroll view draw a focus ring and setting the text view to act like a field editor.*

----

See General/CCDGrowingTextField :)

----

I just finished making General/IFVerticallyExpandingTextfield.  I think this is exactly what you're looking for.

----

I just posted some code here:
http://brockerhoff.net/bb/viewtopic.php?p=1982#1982
to find the minimum size for content, for General/NSTextField; works for any sort of bezel or border, while editing or not. -- General/RainerBrockerhoff