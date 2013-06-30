  I'm trying to add a custom view in my toolbar.  I have set up the toolbar and the item (the custom view) entirely in Interface Builder (in Leopard, of course) and... the view is not currently drawed.
  Is this a bug?  If so, can someone radar it?

Thanks- Luca C.

----
Show us your code/nib

----
  I solved using an General/NSBox, in wich i put my custom General/NSView.  In this way, my view is correctly drawn.
To reproduce this "bug", simply drag the General/NSToolbar to your window in IB; then double click the toolbar and drag in the items' panel a custom view, with something in it. Drag the new toolbar item in the toolbar, so it is displayed, build and go... -Luca C.