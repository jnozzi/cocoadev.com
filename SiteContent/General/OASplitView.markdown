

A subclass of [[NSSplitView]] that adds auto-saving of the sizes of its subviews.
In %%BEGINCODESTYLE%%- awakeFromNib%%ENDCODESTYLE%%, send the split view %%BEGINCODESTYLE%%setPositionAutosaveName:([[NSString]] '')name%%ENDCODESTYLE%%. It works just like the [[NSWindow]] %%BEGINCODESTYLE%%setFrameAutosaveName%%ENDCODESTYLE%%. method.

''In the latest version of the [[OmniFrameworks]], it also adds a method the delegate can implement to do something when the divider is double-clicked. (Like completely collapse a particular subview)