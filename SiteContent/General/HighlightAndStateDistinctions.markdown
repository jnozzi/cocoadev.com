

Hi there.

I am one of the developers on the General/ActionStep project (http://osflash.org/projects/actionstep), which is an OSS implementation of Cocoa in General/ActionScript 2.0 (Flash).

Now this may seem like a completely elementary question, but for I'm having the hardest time figuring out how highlighting and states interact during the drawing of General/NSButtonCell. Would someone be so kind as to describe the big picture surrounding these two concepts, and how they affect drawing. Just pick a button type...let's say General/NSSwitchButton.

Thank you,
Scott Hyndman

(And if you're interested in looking at some our code, here's the repo address http://svn1.cvsdude.com/osflash/actionstep/trunk/src/org/actionstep/)

----

Highlight and state are two abstract pieces of metadata that are given a visual interpretation using the showsStateBy and highlightsBy masks.

State can be on, off, or mixed.  All buttons change state when they are clicked, but most buttons do not display a visual difference when on, due to the contents of the showsStateBy mask.

Highlight is just on or off.  Unfortunately it means slightly different things for different kinds of cells[1].  For a button, highlighted is pretty much synonymous with "pressed".  All buttons turn highlighted when pressed, but they show the highlight differently following the highlightsBy mask.

The visual interpretation mask options are General/NSPushInCellMask, General/NSContentsCellMask, General/NSChangeGrayCellMask and General/NSChangeBackgroundCellMask.  Unfortunately, these date back to the General/NeXTStep operating system and make less sense now then they did then.

General/NSPushInCellMask is easy.  Look pushed.

General/NSContentsCellMask means "use alternate title and image".  So if the showsStateBy mask contains General/NSContentsCellMask, then an on button will display its alternate image.  If the highlightsBy mask contains General/NSContentsCellMask, then a _pressed_ button cell will display its alternate image.

General/NSChangeGrayCellMask and General/NSChangeBackgroundCellMask are interpreted pretty loosely these days as "look different".  They're effectively similar to General/NSPushInCellMask.

IB doesn't directly expose the highlightsBy and showsStateBy masks.  It lets you call setButtonType:, which is a convenience method for setting up collections of button attributes.  For most button types, the only attributes set are the highlightsBy mask and showsStateBy mask.

A lot of this stuff is the way it is for compatibility with older code.

Checkboxes are also a funky case.  Most other complex button styles are exposed as 'bezel types', where the bezel drawing is a monolithic drawBezel method (which means it can have an arbitrary number of different looks).  Checkboxes are borderless (== no bezel) buttons, which draw the checkbox as images.  Buuut there are many different images, while General/NSButtonCell can only be configured with two (image, alternateImage).

But, at a very high level it's the same.  state gives on, off or mixed, highlighted gives pressed or unpressed.

[1] For most cells, setting the highlight to YES is something done by, say, General/NSTableView for cells that are in a selected row.  General/NSTableView has to know that General/NSButtonCell interprets highlight as pressed, and thus not set it in this circumstance.

----

Thank you. I think that's all I need to continue.

----

*
[1] For most cells, setting the highlight to YES is something done by, say, General/NSTableView for cells that are in a selected row.  General/NSTableView has to know that General/NSButtonCell interprets highlight as pressed, and thus not set it in this circumstance.
*

Wow, that seems like very poor design. I actually just finished writing the table view and that's why I'm getting into this business. Let's hope I can figure out a workaround without special cases all over the place.