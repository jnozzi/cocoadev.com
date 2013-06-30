

I am intersted in having a window with multi-Palettes much like what IB has. Thus each palette would have its own set of buttons and also text boxes, etc.

Thanks,
Vyom

----

It seems the way IB does this is through a toolbar. Each toolbar item, when clicked, triggers the change in the window's content. See the General/InterfaceBuilder example General/MultipleNibTabView, then convert it to a tabless view and change tabs at the click of the toolbar items. I'm sure this has been discussed somewhere else on this site too...so browse around a bit. --General/JediKnil

----

I better way that would be more efficient would be to just use -General/[NSWindow setContentView:] to change the actual content view of the window. It actually works very well if you mix it with the animated setFrame:.

I'm sorry... I always bug you about your implementations, you are a good coder don't get me wrong :^)

*Hmmm. The best part about using a tab view is that you can edit its contents in General/InterfaceBuilder, but if you are going to use multiple nibs (not to mention window resizing, like you said -- see General/WhereIsCoolSystemPrefsWindowEffect) this advantage basically disappears. And you do need multiple nibs if you want to be able to add and remove palettes. So I guess you're right, Dan! --General/JediKnil*

Even if you use a single nib, manual view twiddling is often easier in IB, since you can add a bunch of raw General/CustomViews to the nib, and it's somewhat less annoying to edit separate General/CustomViews than it is to edit the contents of a tab view.

----

The General/OmniInspector framework is certainly worth a look.

----

Even with a single nib I use that design (it also works with an General/NSBox) to make the different views just drag a new view to the nib file, sure it is a little more cluttered, however going to different views in a borderless tab view sure is a pain.

----

In Tiger, Apple started making some assumptions about the content view of a window. Swapping it out with some other view has bitten me in the past. I highly recommend adding your custom content as a *subview* of the window's content view, rather than making it the content view directly.

----
Using customViews in Nib's works great. Only the name length in General/InterfaceBui.... is a little short.
Keep in mind that, having views in your nib file and move one of those into your window, box or whatever view, creates a copy of that nib-view. And this will call awakefromNib twice, one for each instance. I hear/read sometimes about that awakefromNib is called twice for an object, and don't understands why. This could be the trigger. If they check, it not the same of course. Just FYI.