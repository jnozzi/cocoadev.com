

Sorry for going a little off-topic, but I need an [[AppleScript]] to save all modified documents in Interface Builder (i.e. like Xcode does before you do a build), but I can't figure out how.

It seems IB doesn't respond to <code>documents</code> and the <code>window</code> object has no <code>document</code> property. Strangely it does have a <code>document edited</code> property (so I can get to whether IB has modified documents, just not save them).

I'd be grateful for any help on the subject!