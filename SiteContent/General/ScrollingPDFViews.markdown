I have been working with the General/PDFView example from the Apple developer site.

I have a complete understanding of this application, how it works, etc. and I can almost recreate it from scratch.  However, there is one issue.

In the NIB file there is a subclassed control called General/DraggableScrollView subclassed from General/NSScrollView which is used to control the display the actual PDF - in particular it provides scroll bars for the view.  The control itself, i.e., the thing you drag from the control pallette, is not part of the latest (10.2) developer platform - at least as far as I can tell.  I cannot recreate the control in a fresh General/ProjectBuilder application by doing what seem to be obvious things, i.e., creating it from a General/CustomView.  

However, In the Interface Builder I can copy the control from the window and paste it into a window in another project.

My questions are:

1) Is there some universe or master pallette of Cocoa controls that I need to find?

2) Is this control an old, non-supported version?

3) I need something like this scrolling view but I am concerned about using it if its magic, special, or unreproducable.

Todd
todd@think121.com

----

I'm not really sure how to use this site, so I'm am editing the page and adding my comments.  I recently wanted to add a pdf viewer to a program I'm writing and found this post.  I ran into several problems with the General/NSPDFImageRep that I was trying to solve through google searches.  This post made me realize that Apple had sample code, so I downloaded it and spent about 10 hours customizing it (mainly trying to figure out how to get "zooming" to work).  After messing with the code I can answer Todd's question:

No, you don't a special palette or anything to that effect.  Try these steps (from memory, so they may be a little off):

1)  In your project (or start a new one, whichever), be sure to add the appropriate files (General/DraggableScroller.h, General/DraggableScroller.m, as well as the General/PDFViewer files).
2)  In Interface builder, add a General/NSImageView and click on it.
3)  In the NIB window ("General/MainMenu.nib"), click on the tab named "classes".
4)  In the hierarchy of classes, you should be at the spot General/NSObject -> General/NSResponder -> General/NSView -> General/NSImageView.  Go there if you aren't.
5)  Hit "return" and type in the name of the class ("General/PDFImageView"??? I can't remember the name off hand)
6)  Right click on the class on click on "Read files"
7)  Find the .h file for the General/PDFImageView class.
8)  From the information palette (click on the General/NSImageView and hit command-shift-I), go to the custom class page (command-4??) from the drop down menu
9)  General/PDFImageView (or whatever the name is) should be an option.  Be sure to select it.
10)  Enclose the General/ImageView with scroll bars (click on the image view, tools->make subview of->scroll view)
11)  Highlight the newly added scroll view
12)  Repeat steps 3 - 9 for the General/DraggableScroller class.

Sorry if my memory has failed me, email me with any questions.

Hope it helps!
Robbie (rhaertel80@hotmail.com)