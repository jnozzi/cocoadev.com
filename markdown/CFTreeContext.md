General/CFTreeContext is a basic structure used to refer back to the data stored in the tree structure.

What/Which tree?  Where/When would someone use a General/CFTreeContext?

A General/CFTreeContext holds the data for each node, as well as retain/release callbacks. It does not know about parent or child nodes. Those are stored in each General/CFTree instance (each General/CFTree instance is a node). See the "General/CFTree" page for some options on how to use General/CFTreeContext.