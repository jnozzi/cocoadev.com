Does anyone know how in Mail and now iTunes (5) the split view as no separator bar??
Meaning that the two views are tightly connected and the resizing bar is in the title or bottom bar.

----

Subclass General/NSSplitView and override     dividerThickness to return something small like 1.0.

----

Thanks

----

You could also use General/RBSplitView for more goodies that would speed up your development :-).

----

General/RBSplitView is great, but pretty heavy - be warned.

JKP