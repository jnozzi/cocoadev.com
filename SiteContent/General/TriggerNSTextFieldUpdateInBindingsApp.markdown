

I'm looking for the best way to trigger an update of an [[NSTextField]] in my bindings based app.  The [[NSTextField]] displays a float output of a calculation using data in a [[NSMutableArray]] (bound to an [[NSArrayController]] as [[NSTableView]]).     I added a a binding of the [[NSTextField]] into File's Owner / My Document, where the [[NSMutableArray]] is instantiated and I can do the calculation.   This works fine when I initially load the data, but as I add/update entries, the [[NSTextField]] is not updated.    I assume this is because they are bound to different controllers, so an update is not recognized.  


Is there a delegate that can be used to tell when anything in the [[NSMutableArray]] / [[NSArrayController]] has changed?    Or, is there some better way to do this, without resorting to an "Update" button on the UI (which I'm using now)?