General/CCDAppKit contains some General/AppKit improvements for your enjoyment.

----
**Categories**

*General/NSBezierPathCategory
*General/NSFileManagerCategory
*General/NSMatrixCategory
*General/NSMenuCategory
*General/NSMenuItemCategory
*General/NSTextViewCategory


**Subclasses**

* General/CCDTextField, General/CCDTextFieldCell and General/CCDPTextView all go together. They allow you to embed a cell in the left and right hand sides of your text fields. Good if you want to do something like iChat's input field. It can also draw a progress bar behind the text like Safari's address field and has limited support for colored labels.
* General/CCDProgressIndicator is good for drawing rounded progress bars.
* General/CCDGrowingTextField is a simple General/NSTextField subclass that expands to fit its content.
* General/CCDGradientSelectionTableView attempts to mimic iTunes' "Source" list, example project included.


Feel free to add more here.

----
**plan:**

Create General/CCDSearchField and General/CCDSearchFieldCell, based on General/CCDTextField and General/CCDTextFieldCell.

----
Taken from General/CCDMessageDistributer, *I do think that it was presumptuous of me to use the CCD prefix for cocoadev. In fact thinking about it, that's more likely to cause a namespace conflict than anything else. And who decides what goes under CCD?*

I've sort of been thinking along the same lines. I'm not sure how it's likely to cause a namespace conflict though. And I think everyone decides what goes under CCD, I have faith in the wiki process. If it doesn't belong it'll rot and I'm ok with that. Is that the right attitude to have?

----

The one thing that I (remain) concerned with is that we not unnecessarily fragment the code contributions of this wiki.  I hope we will eventually wrap in code such as the General/CocoaDevUsersAdditions and such.  There's already some problem with this.  Look at the bottom of General/CocoaOpen and try to figure out how it's different from General/ObjectLibrary.
----
I don't see why the "Components" section of General/CocoaOpen shouldn't be in General/ObjectLibrary, if it's not already. And some of the stuff in General/ObjectLibrary should be in General/CocoaOpen I bet. I think the purposes of the pages overlap in some cases is all.

Anyway, I think fragmentation could be avoided with a little reorganizing. I was actually thinking about mirroring the General/AppKit section of General/CocoaDevUsersAdditions here and the foundation section on (err..) General/CCDFoundation.

Any objections or volunteers?
----
It would be cooler if it wasn't done manually but it's a start. Should I do the same on General/CCDFoundation or should I create General/CCDFoundationKit?