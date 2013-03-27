Is there away to round integer values accessed using bindings to 0 decimal places?

----

Try using an General/NSNumberFormatter. Drag it off the Interface Builder palette (it looks like a text field with a green $ symbol above it) and drop it on whatever text field or table column you want to format. Then, configure it using the "Formatter" pane of the Inspector window (Command-9) when the field/text column is selected.

----

I dragged a General/NSNumberFormatter onto my General/NSTextField and configured it to display only whole numbers but now when I build and run I get the error

    

2004-11-16 16:12:37.430 General/MyApp[3234] An uncaught exception was raised
2004-11-16 16:12:37.459 General/MyApp[3234] [<General/NSTextField 0x33b990> valueForUndefinedKey:]: this class is not key value coding-compliant for the key displayPatternValue1.
2004-11-16 16:12:37.481 General/MyApp[3234] *** Uncaught exception: <General/NSUnknownKeyException> [<General/NSTextField 0x33b990> valueForUndefinedKey:]: this class is not key value coding-compliant for the key displayPatternValue1.



Does that mean you can't attach a General/NSNumberFormatter to a General/NSTextField or have I just done it wrong?

----

No, it means General/NSTextField is not key value coding-compliant for the key displayPatternValue1. ;-) Seriously, though, unbind from the General/NSTextField's displayPatternValue1 binding and bind to its VALUE to use a formatter.